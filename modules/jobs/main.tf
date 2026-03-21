resource "aws_ssm_parameter" "active_app_region" {
  provider = aws.standby_region_aws
  name     = "/${var.project_name}/${var.environment}/failover/active_app_region"
  type     = "String"
  value    = "primary"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "active_db_region" {
  provider = aws.standby_region_aws
  name     = "/${var.project_name}/${var.environment}/failover/active_db_region"
  type     = "String"
  value    = "primary"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "last_status" {
  provider = aws.standby_region_aws
  name     = "/${var.project_name}/${var.environment}/failover/last_status"
  type     = "String"
  value    = "never-run"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "last_timestamp" {
  provider = aws.standby_region_aws
  name     = "/${var.project_name}/${var.environment}/failover/last_timestamp"
  type     = "String"
  value    = "0"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "lock" {
  provider = aws.standby_region_aws
  name     = "/${var.project_name}/${var.environment}/failover/lock"
  type     = "String"
  value    = "unlocked"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_lambda_function" "ssm_replication" {
  provider         = aws.standby_region_aws
  function_name    = "${var.project_name}-${var.environment}-ssm-replication"
  role             = data.aws_ssm_parameter.standby_jobs_lambda_role_arn.value
  handler          = "replicate_ssm.handler"
  runtime          = "python3.13"
  filename         = data.archive_file.ssm_replication_package.output_path
  source_code_hash = data.archive_file.ssm_replication_package.output_base64sha256
  timeout          = 900
  memory_size      = 256

  environment {
    variables = {
      PROJECT_NAME   = var.project_name
      ENVIRONMENT    = var.environment
      PRIMARY_REGION = var.primary_region_aws
      STANDBY_REGION = var.standby_region_aws
    }
  }
}

resource "aws_lambda_function" "full_failover" {
  provider         = aws.standby_region_aws
  function_name    = "${var.project_name}-${var.environment}-full-failover"
  role             = data.aws_ssm_parameter.standby_jobs_lambda_role_arn.value
  handler          = "full_failover.handler"
  runtime          = "python3.13"
  filename         = data.archive_file.full_failover_package.output_path
  source_code_hash = data.archive_file.full_failover_package.output_base64sha256
  timeout          = 900
  memory_size      = 256

  environment {
    variables = {
      PROJECT_NAME    = var.project_name
      ENVIRONMENT     = var.environment
      PRIMARY_REGION  = var.primary_region_aws
      STANDBY_REGION  = var.standby_region_aws
      APP_HEALTH_PATH = var.app_health_path
      DB_PORT         = tostring(var.db_port)
    }
  }

  depends_on = [aws_lambda_function.ssm_replication]
}
