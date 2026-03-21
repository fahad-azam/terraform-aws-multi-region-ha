import os

import boto3


PROJECT = os.environ["PROJECT_NAME"]
ENVIRONMENT = os.environ["ENVIRONMENT"]
PRIMARY_REGION = os.environ["PRIMARY_REGION"]
STANDBY_REGION = os.environ["STANDBY_REGION"]

primary_ssm = boto3.client("ssm", region_name=PRIMARY_REGION)
standby_ssm = boto3.client("ssm", region_name=STANDBY_REGION)


def prefix():
    return f"/{PROJECT}/{ENVIRONMENT}/"


def list_parameters():
    paginator = primary_ssm.get_paginator("get_parameters_by_path")
    for page in paginator.paginate(Path=prefix(), Recursive=True, WithDecryption=False):
        for param in page["Parameters"]:
            yield param


def handler(event, context):
    copied = []
    for param in list_parameters():
      standby_ssm.put_parameter(
          Name=param["Name"],
          Value=param["Value"],
          Type=param["Type"],
          Overwrite=True,
      )
      copied.append(param["Name"])

    return {
        "status": "success",
        "copied_count": len(copied),
        "copied_parameters": copied,
    }
