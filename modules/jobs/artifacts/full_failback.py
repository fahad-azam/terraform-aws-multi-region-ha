import json
import os
import time
import urllib.request

import boto3


PROJECT = os.environ["PROJECT_NAME"]
ENVIRONMENT = os.environ["ENVIRONMENT"]
PRIMARY_REGION = os.environ["PRIMARY_REGION"]
STANDBY_REGION = os.environ["STANDBY_REGION"]
APP_READINESS_PATH = os.environ.get("APP_READINESS_PATH", "/readiness")
LOCK_TIMEOUT_SECONDS = 1800

ssm = boto3.client("ssm", region_name=STANDBY_REGION)
route53 = boto3.client("route53")
rds_primary = boto3.client("rds", region_name=PRIMARY_REGION)


def ssm_name(suffix):
    return f"/{PROJECT}/{ENVIRONMENT}/{suffix}"


def get_param(name):
    return ssm.get_parameter(Name=name)["Parameter"]["Value"]


def put_param(name, value):
    ssm.put_parameter(Name=name, Value=value, Type="String", Overwrite=True)


def load_config():
    primary_db_endpoint = get_param(ssm_name("rds/primary/endpoint"))
    standby_db_endpoint = get_param(ssm_name("rds/standby/endpoint"))

    return {
        "hosted_zone_id": get_param(ssm_name("route53/hosted_zone_id")),
        "app_record_fqdn": get_param(ssm_name("route53/app_record_fqdn")),
        "db_record_fqdn": get_param(ssm_name("route53/db_record_fqdn")),
        "primary_alb_dns": get_param(ssm_name("alb/primary/dns_name")),
        "standby_alb_dns": get_param(ssm_name("alb/standby/dns_name")),
        "primary_db_endpoint": primary_db_endpoint,
        "standby_db_endpoint": standby_db_endpoint,
        "primary_db_target": primary_db_endpoint.split(":", 1)[0],
        "standby_db_target": standby_db_endpoint.split(":", 1)[0],
        "primary_db_instance_id": get_param(ssm_name("rds/primary/instance_id")),
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
            raise RuntimeError("Failback already in progress")

    put_param(lock_name, f"locked:{now}")


def release_lock():
    put_param(ssm_name("failover/lock"), "unlocked")


def validate_route53_config(config):
    zone = route53.get_hosted_zone(Id=config["hosted_zone_id"])
    if not zone["HostedZone"]["Id"]:
        raise RuntimeError("Hosted zone lookup failed")


def validate_primary_db(config):
    response = rds_primary.describe_db_instances(
        DBInstanceIdentifier=config["primary_db_instance_id"]
    )
    db = response["DBInstances"][0]
    status = db["DBInstanceStatus"]
    if status != "available":
        raise RuntimeError(f"Primary DB is not ready: {status}")


def check_http(url, timeout=5):
    with urllib.request.urlopen(url, timeout=timeout) as response:
        body = response.read().decode("utf-8")
        return response.status, body


def validate_primary_app(config):
    health_url = f"http://{config['primary_alb_dns']}{APP_READINESS_PATH}"
    status, body = check_http(health_url)
    if status != 200:
        raise RuntimeError(f"Unexpected health response from primary app: {status}")
    payload = json.loads(body)
    if payload.get("status") != "ok":
        raise RuntimeError("Primary app health payload does not report ok status")
    if payload.get("region") not in (None, "primary"):
        raise RuntimeError("Primary app health payload does not indicate primary region")


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
    put_param(ssm_name("failover/active_db_region"), "primary")
    put_param(ssm_name("failover/active_app_region"), "primary")
    put_param(ssm_name("failover/last_status"), "success:failback")
    put_param(ssm_name("failover/last_timestamp"), str(int(time.time())))


def write_failure_state(message):
    put_param(ssm_name("failover/last_status"), f"failed:failback:{message}")
    put_param(ssm_name("failover/last_timestamp"), str(int(time.time())))


def handler(event, context):
    operation = event.get("operation", "full_failback")
    if operation != "full_failback":
        return {"status": "failed", "message": f"Unsupported operation: {operation}"}

    config = load_config()
    state = load_state()

    if state["active_app_region"] == "primary" and state["active_db_region"] == "primary":
        return {"status": "no_op", "message": "Primary is already active for both app and db"}

    acquire_lock()
    try:
        validate_route53_config(config)
        validate_primary_db(config)
        validate_primary_app(config)

        upsert_cname(config["db_record_fqdn"], config["primary_db_target"], config["hosted_zone_id"])
        validate_dns_target(config["db_record_fqdn"], config["primary_db_target"], config["hosted_zone_id"])

        upsert_cname(config["app_record_fqdn"], config["primary_alb_dns"], config["hosted_zone_id"])
        validate_dns_target(config["app_record_fqdn"], config["primary_alb_dns"], config["hosted_zone_id"])

        validate_primary_app(config)
        write_success_state()
        return {
            "status": "success",
            "message": "Full failback completed successfully",
            "db_target": config["primary_db_target"],
            "app_target": config["primary_alb_dns"],
        }
    except Exception as exc:
        write_failure_state(str(exc))
        return {"status": "failed", "message": str(exc)}
    finally:
        release_lock()
