import json
import os
import time
import urllib.request

import boto3


PROJECT = os.environ["PROJECT_NAME"]
ENVIRONMENT = os.environ["ENVIRONMENT"]
STANDBY_REGION = os.environ["STANDBY_REGION"]
APP_HEALTH_PATH = os.environ.get("APP_HEALTH_PATH", "/health")
LOCK_TIMEOUT_SECONDS = 1800

ssm = boto3.client("ssm", region_name=STANDBY_REGION)
route53 = boto3.client("route53")
rds_standby = boto3.client("rds", region_name=STANDBY_REGION)


def ssm_name(suffix):
    return f"/{PROJECT}/{ENVIRONMENT}/{suffix}"


def get_param(name):
    return ssm.get_parameter(Name=name)["Parameter"]["Value"]


def put_param(name, value):
    ssm.put_parameter(Name=name, Value=value, Type="String", Overwrite=True)


def load_config():
    return {
        "hosted_zone_id": get_param(ssm_name("route53/hosted_zone_id")),
        "app_record_fqdn": get_param(ssm_name("route53/app_record_fqdn")),
        "db_record_fqdn": get_param(ssm_name("route53/db_record_fqdn")),
        "primary_alb_dns": get_param(ssm_name("alb/primary/dns_name")),
        "standby_alb_dns": get_param(ssm_name("alb/standby/dns_name")),
        "primary_db_endpoint": get_param(ssm_name("rds/primary/endpoint")),
        "standby_db_endpoint": get_param(ssm_name("rds/standby/endpoint")),
        "standby_db_instance_id": get_param(ssm_name("rds/standby/instance_id")),
    }


def load_state():
    return {
        "active_app_region": get_param(ssm_name("failover/active_app_region")),
        "active_db_region": get_param(ssm_name("failover/active_db_region")),
        "lock": get_param(ssm_name("failover/lock")),
    }


def acquire_lock():
    lock_name = ssm_name("failover/lock")
    current = get_param(lock_name)
    now = int(time.time())

    if current.startswith("locked:"):
        lock_timestamp = int(current.split(":", 1)[1])
        if now - lock_timestamp < LOCK_TIMEOUT_SECONDS:
            raise RuntimeError("Failover already in progress")

    put_param(lock_name, f"locked:{now}")


def release_lock():
    put_param(ssm_name("failover/lock"), "unlocked")


def validate_route53_config(config):
    zone = route53.get_hosted_zone(Id=config["hosted_zone_id"])
    if not zone["HostedZone"]["Id"]:
        raise RuntimeError("Hosted zone lookup failed")


def validate_standby_db(config):
    response = rds_standby.describe_db_instances(
        DBInstanceIdentifier=config["standby_db_instance_id"]
    )
    db = response["DBInstances"][0]
    status = db["DBInstanceStatus"]
    if status != "available":
        raise RuntimeError(f"Standby DB is not ready: {status}")
    if "ReadReplicaSourceDBInstanceIdentifier" not in db:
        raise RuntimeError("Standby DB is not currently a read replica")


def check_http(url, timeout=5):
    with urllib.request.urlopen(url, timeout=timeout) as response:
        body = response.read().decode("utf-8")
        return response.status, body


def validate_standby_app(config):
    health_url = f"http://{config['standby_alb_dns']}{APP_HEALTH_PATH}"
    status, body = check_http(health_url)
    if status != 200:
        raise RuntimeError(f"Unexpected health response from standby app: {status}")
    payload = json.loads(body)
    if payload.get("status") != "ok":
        raise RuntimeError("Standby app health payload does not report ok status")
    if payload.get("region") not in (None, "standby"):
        raise RuntimeError("Standby app health payload does not indicate standby region")


def promote_standby_db(config):
    rds_standby.promote_read_replica(
        DBInstanceIdentifier=config["standby_db_instance_id"]
    )


def wait_for_db_promotion(config, timeout=1800, interval=30):
    deadline = time.time() + timeout
    while time.time() < deadline:
        response = rds_standby.describe_db_instances(
            DBInstanceIdentifier=config["standby_db_instance_id"]
        )
        db = response["DBInstances"][0]
        status = db["DBInstanceStatus"]
        if status == "available" and "ReadReplicaSourceDBInstanceIdentifier" not in db:
            return
        time.sleep(interval)
    raise RuntimeError("Timed out waiting for standby DB promotion")


def upsert_cname(record_name, target, hosted_zone_id, ttl=60):
    route53.change_resource_record_sets(
        HostedZoneId=hosted_zone_id,
        ChangeBatch={
            "Changes": [
                {
                    "Action": "UPSERT",
                    "ResourceRecordSet": {
                        "Name": record_name,
                        "Type": "CNAME",
                        "TTL": ttl,
                        "ResourceRecords": [{"Value": target}],
                    },
                }
            ]
        },
    )


def get_record_target(record_name, hosted_zone_id):
    paginator = route53.get_paginator("list_resource_record_sets")
    for page in paginator.paginate(HostedZoneId=hosted_zone_id):
        for record in page["ResourceRecordSets"]:
            if record["Name"].rstrip(".") == record_name.rstrip(".") and record["Type"] == "CNAME":
                return record["ResourceRecords"][0]["Value"].rstrip(".")
    raise RuntimeError(f"Record not found: {record_name}")


def validate_dns_target(record_name, expected_target, hosted_zone_id):
    actual = get_record_target(record_name, hosted_zone_id)
    if actual.rstrip(".") != expected_target.rstrip("."):
        raise RuntimeError(
            f"DNS validation failed for {record_name}: expected {expected_target}, got {actual}"
        )


def write_success_state():
    put_param(ssm_name("failover/active_db_region"), "standby")
    put_param(ssm_name("failover/active_app_region"), "standby")
    put_param(ssm_name("failover/last_status"), "success")
    put_param(ssm_name("failover/last_timestamp"), str(int(time.time())))


def write_failure_state(message):
    put_param(ssm_name("failover/last_status"), f"failed:{message}")
    put_param(ssm_name("failover/last_timestamp"), str(int(time.time())))


def handler(event, context):
    operation = event.get("operation", "full_failover")
    if operation != "full_failover":
        return {"status": "failed", "message": f"Unsupported operation: {operation}"}

    config = load_config()
    state = load_state()

    if state["active_app_region"] == "standby" and state["active_db_region"] == "standby":
        return {"status": "no_op", "message": "Standby is already active for both app and db"}

    acquire_lock()
    try:
        validate_route53_config(config)
        validate_standby_db(config)
        validate_standby_app(config)

        promote_standby_db(config)
        wait_for_db_promotion(config)

        upsert_cname(config["db_record_fqdn"], config["standby_db_endpoint"], config["hosted_zone_id"])
        validate_dns_target(config["db_record_fqdn"], config["standby_db_endpoint"], config["hosted_zone_id"])

        upsert_cname(config["app_record_fqdn"], config["standby_alb_dns"], config["hosted_zone_id"])
        validate_dns_target(config["app_record_fqdn"], config["standby_alb_dns"], config["hosted_zone_id"])

        validate_standby_app(config)
        write_success_state()
        return {
            "status": "success",
            "message": "Full failover completed successfully",
            "db_target": config["standby_db_endpoint"],
            "app_target": config["standby_alb_dns"],
        }
    except Exception as exc:
        write_failure_state(str(exc))
        return {"status": "failed", "message": str(exc)}
    finally:
        release_lock()
