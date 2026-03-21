import os
import random
import time

import boto3
from botocore.exceptions import ClientError


PROJECT = os.environ["PROJECT_NAME"]
ENVIRONMENT = os.environ["ENVIRONMENT"]
PRIMARY_REGION = os.environ["PRIMARY_REGION"]
STANDBY_REGION = os.environ["STANDBY_REGION"]

primary_ssm = boto3.client("ssm", region_name=PRIMARY_REGION)
standby_ssm = boto3.client("ssm", region_name=STANDBY_REGION)
MAX_RETRIES = 8
BASE_DELAY_SECONDS = 0.5


def prefix():
    return f"/{PROJECT}/{ENVIRONMENT}/"


def list_parameters():
    paginator = primary_ssm.get_paginator("get_parameters_by_path")
    for page in paginator.paginate(Path=prefix(), Recursive=True, WithDecryption=False):
        for param in page["Parameters"]:
            yield param


def put_parameter_with_retry(param):
    for attempt in range(MAX_RETRIES):
        try:
            standby_ssm.put_parameter(
                Name=param["Name"],
                Value=param["Value"],
                Type=param["Type"],
                Overwrite=True,
            )
            return
        except ClientError as exc:
            error_code = exc.response["Error"].get("Code", "")
            if error_code not in {"ThrottlingException", "TooManyUpdates"} or attempt == MAX_RETRIES - 1:
                raise

            # Exponential backoff with jitter to stay under SSM write limits.
            delay = BASE_DELAY_SECONDS * (2 ** attempt) + random.uniform(0, 0.25)
            time.sleep(delay)


def handler(event, context):
    copied = []
    for param in list_parameters():
        put_parameter_with_retry(param)
        copied.append(param["Name"])

    return {
        "status": "success",
        "copied_count": len(copied),
        "copied_parameters": copied,
    }
