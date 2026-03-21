import time

import boto3
from botocore.exceptions import ClientError


PROJECT = __import__("os").environ["PROJECT_NAME"]
ENVIRONMENT = __import__("os").environ["ENVIRONMENT"]
PRIMARY_REGION = __import__("os").environ["PRIMARY_REGION"]
STANDBY_REGION = __import__("os").environ["STANDBY_REGION"]
LOCK_TIMEOUT_SECONDS = 1800

primary_ssm = boto3.client("ssm", region_name=PRIMARY_REGION)
standby_ssm = boto3.client("ssm", region_name=STANDBY_REGION)
rds_primary = boto3.client("rds", region_name=PRIMARY_REGION)
rds_standby = boto3.client("rds", region_name=STANDBY_REGION)


def ssm_name(suffix):
    return f"/{PROJECT}/{ENVIRONMENT}/{suffix}"


def get_param(name):
    return standby_ssm.get_parameter(Name=name)["Parameter"]["Value"]


def put_param(client, name, value):
    client.put_parameter(Name=name, Value=str(value), Type="String", Overwrite=True)


def write_both_regions(name, value):
    put_param(primary_ssm, name, value)
    put_param(standby_ssm, name, value)


def load_state():
    return {
        "active_db_region": get_param(ssm_name("failover/active_db_region")),
        "lock": get_param(ssm_name("failover/lock")),
    }


def load_config():
    return {
        "primary_db_instance_id": get_param(ssm_name("rds/primary/instance_id")),
        "primary_db_arn": get_param(ssm_name("rds/primary/arn")),
        "primary_private_sg_id": get_param(ssm_name("network/primary/private_sg_id")),
        "standby_db_instance_id": get_param(ssm_name("rds/standby/instance_id")),
        "standby_db_arn": get_param(ssm_name("rds/standby/arn")),
        "standby_private_sg_id": get_param(ssm_name("network/standby/private_sg_id")),
        "primary_db_subnet_group_name": f"{PROJECT}-primary-db-group",
        "standby_db_subnet_group_name": f"{PROJECT}-standby-db-group",
    }


def acquire_lock():
    lock_name = ssm_name("failover/lock")
    current = get_param(lock_name)
    now = int(time.time())

    if current.startswith("locked:"):
        lock_timestamp = int(current.split(":", 1)[1])
        if now - lock_timestamp < LOCK_TIMEOUT_SECONDS:
            raise RuntimeError("Another failover job is already in progress")

    put_param(standby_ssm, lock_name, f"locked:{now}")


def release_lock():
    put_param(standby_ssm, ssm_name("failover/lock"), "unlocked")


def describe_db(client, identifier):
    try:
        response = client.describe_db_instances(DBInstanceIdentifier=identifier)
        return response["DBInstances"][0]
    except ClientError as exc:
        if exc.response["Error"]["Code"] == "DBInstanceNotFound":
            return None
        raise


def wait_for_deleted(client, identifier, timeout=3600, interval=30):
    deadline = time.time() + timeout
    while time.time() < deadline:
        db = describe_db(client, identifier)
        if db is None:
            return
        time.sleep(interval)
    raise RuntimeError(f"Timed out waiting for DB deletion: {identifier}")


def wait_for_replica(client, identifier, expected_source_id, timeout=7200, interval=30):
    deadline = time.time() + timeout
    while time.time() < deadline:
        db = describe_db(client, identifier)
        if db is None:
            time.sleep(interval)
            continue

        status = db["DBInstanceStatus"]
        source = db.get("ReadReplicaSourceDBInstanceIdentifier")
        if status == "available" and source:
            if source.endswith(expected_source_id) or source == expected_source_id:
                return db
        time.sleep(interval)

    raise RuntimeError(f"Timed out waiting for standby replica readiness: {identifier}")


def ensure_target_removed(target_client, target_identifier, active_source_identifier):
    target_db = describe_db(target_client, target_identifier)
    if target_db is None:
        return "missing"

    status = target_db["DBInstanceStatus"]
    source = target_db.get("ReadReplicaSourceDBInstanceIdentifier")
    if status == "available" and source and (source.endswith(active_source_identifier) or source == active_source_identifier):
        return "already_replica"

    if status == "deleting":
        wait_for_deleted(target_client, target_identifier)
        return "deleted"

    target_client.delete_db_instance(
        DBInstanceIdentifier=target_identifier,
        SkipFinalSnapshot=True,
        DeleteAutomatedBackups=True,
    )
    wait_for_deleted(target_client, target_identifier)
    return "deleted"


def create_replica(source_client, target_client, source_region, source_arn, source_identifier, target_identifier, target_subnet_group_name, target_private_sg_id):
    source_db = describe_db(source_client, source_identifier)
    if source_db is None:
        raise RuntimeError(f"Source DB not found: {source_identifier}")
    if source_db["DBInstanceStatus"] != "available":
        raise RuntimeError(f"Source DB is not ready: {source_db['DBInstanceStatus']}")

    target_client.create_db_instance_read_replica(
        DBInstanceIdentifier=target_identifier,
        SourceDBInstanceIdentifier=source_arn,
        SourceRegion=source_region,
        DBInstanceClass=source_db["DBInstanceClass"],
        PubliclyAccessible=False,
        DBSubnetGroupName=target_subnet_group_name,
        VpcSecurityGroupIds=[target_private_sg_id],
        CopyTagsToSnapshot=True,
        AutoMinorVersionUpgrade=True,
    )

    return wait_for_replica(target_client, target_identifier, source_identifier)


def write_db_params(role_name, db):
    prefix = ssm_name(f"rds/{role_name}")
    write_both_regions(f"{prefix}/instance_id", db["DBInstanceIdentifier"])
    write_both_regions(f"{prefix}/arn", db["DBInstanceArn"])
    write_both_regions(f"{prefix}/endpoint", f"{db['Endpoint']['Address']}:{db['Endpoint']['Port']}")
    write_both_regions(f"{prefix}/port", db["Endpoint"]["Port"])


def write_status(value):
    timestamp = str(int(time.time()))
    put_param(standby_ssm, ssm_name("failover/last_status"), value)
    put_param(standby_ssm, ssm_name("failover/last_timestamp"), timestamp)


def handler(event, context):
    operation = event.get("operation", "rebuild_standby_replica")
    if operation != "rebuild_standby_replica":
        return {"status": "failed", "message": f"Unsupported operation: {operation}"}

    state = load_state()
    config = load_config()

    if state["active_db_region"] == "primary":
        source_region = PRIMARY_REGION
        source_client = rds_primary
        source_role = "primary"
        source_identifier = config["primary_db_instance_id"]
        source_arn = config["primary_db_arn"]
        target_client = rds_standby
        target_role = "standby"
        target_identifier = config["standby_db_instance_id"]
        target_subnet_group_name = config["standby_db_subnet_group_name"]
        target_private_sg_id = config["standby_private_sg_id"]
    elif state["active_db_region"] == "standby":
        source_region = STANDBY_REGION
        source_client = rds_standby
        source_role = "standby"
        source_identifier = config["standby_db_instance_id"]
        source_arn = config["standby_db_arn"]
        target_client = rds_primary
        target_role = "primary"
        target_identifier = config["primary_db_instance_id"]
        target_subnet_group_name = config["primary_db_subnet_group_name"]
        target_private_sg_id = config["primary_private_sg_id"]
    else:
        return {"status": "failed", "message": f"Unsupported active_db_region state: {state['active_db_region']}"}

    acquire_lock()
    try:
        ensure_result = ensure_target_removed(target_client, target_identifier, source_identifier)
        if ensure_result == "already_replica":
            write_status(f"success:replica-already-ready:{target_role}")
            return {
                "status": "no_op",
                "message": f"{target_role} database is already a replica of the active writer",
                "active_region": state["active_db_region"],
                "replica_region": target_role,
            }

        replica = create_replica(
            source_client=source_client,
            target_client=target_client,
            source_region=source_region,
            source_arn=source_arn,
            source_identifier=source_identifier,
            target_identifier=target_identifier,
            target_subnet_group_name=target_subnet_group_name,
            target_private_sg_id=target_private_sg_id,
        )

        write_db_params(target_role, replica)
        write_status(f"success:replica-rebuilt:{target_role}")
        return {
            "status": "success",
            "message": f"Rebuilt {target_role} database as a replica of the active {source_role} writer",
            "active_region": state["active_db_region"],
            "replica_region": target_role,
            "replica_instance_id": replica["DBInstanceIdentifier"],
            "replica_endpoint": replica["Endpoint"]["Address"],
        }
    except Exception as exc:
        write_status(f"failed:replica-rebuild:{exc}")
        return {"status": "failed", "message": str(exc)}
    finally:
        release_lock()
