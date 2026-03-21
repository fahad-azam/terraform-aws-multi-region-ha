data "archive_file" "ssm_replication_package" {
  type        = "zip"
  source_file = "${path.module}/artifacts/replicate_ssm.py"
  output_path = "${path.root}/.terraform/${var.project_name}-${var.environment}-replicate_ssm.zip"
}

data "archive_file" "full_failover_package" {
  type        = "zip"
  source_file = "${path.module}/artifacts/full_failover.py"
  output_path = "${path.root}/.terraform/${var.project_name}-${var.environment}-full_failover.zip"
}

data "archive_file" "full_failback_package" {
  type        = "zip"
  source_file = "${path.module}/artifacts/full_failback.py"
  output_path = "${path.root}/.terraform/${var.project_name}-${var.environment}-full_failback.zip"
}

data "archive_file" "rebuild_standby_replica_package" {
  type        = "zip"
  source_file = "${path.module}/artifacts/rebuild_standby_replica.py"
  output_path = "${path.root}/.terraform/${var.project_name}-${var.environment}-rebuild_standby_replica.zip"
}

data "aws_ssm_parameter" "standby_jobs_lambda_role_arn" {
  provider = aws.standby_region_aws
  name     = "/${var.project_name}/${var.environment}/iam/standby/jobs_lambda_role_arn"
}
