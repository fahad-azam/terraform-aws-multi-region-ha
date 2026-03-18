resource "aws_ssm_parameter" "primary_artifact_bucket_name" {
  name  = "/${var.project_name}/${local.environment}/storage/primary/artifact_bucket_name"
  type  = "String"
  value = module.storage.primary_artifact_bucket_name
}

resource "aws_ssm_parameter" "standby_artifact_bucket_name" {
  name  = "/${var.project_name}/${local.environment}/storage/standby/artifact_bucket_name"
  type  = "String"
  value = module.storage.standby_artifact_bucket_name
}

resource "aws_ssm_parameter" "primary_data_bucket_name" {
  name  = "/${var.project_name}/${local.environment}/storage/primary/data_bucket_name"
  type  = "String"
  value = module.storage.primary_data_bucket_name
}

resource "aws_ssm_parameter" "standby_data_bucket_name" {
  name  = "/${var.project_name}/${local.environment}/storage/standby/data_bucket_name"
  type  = "String"
  value = module.storage.standby_data_bucket_name
}

resource "aws_ssm_parameter" "primary_artifact_bucket_arn" {
  name  = "/${var.project_name}/${local.environment}/storage/primary/artifact_bucket_arn"
  type  = "String"
  value = module.storage.primary_artifact_bucket_arn
}

resource "aws_ssm_parameter" "standby_artifact_bucket_arn" {
  name  = "/${var.project_name}/${local.environment}/storage/standby/artifact_bucket_arn"
  type  = "String"
  value = module.storage.standby_artifact_bucket_arn
}

resource "aws_ssm_parameter" "primary_data_bucket_arn" {
  name  = "/${var.project_name}/${local.environment}/storage/primary/data_bucket_arn"
  type  = "String"
  value = module.storage.primary_data_bucket_arn
}

resource "aws_ssm_parameter" "standby_data_bucket_arn" {
  name  = "/${var.project_name}/${local.environment}/storage/standby/data_bucket_arn"
  type  = "String"
  value = module.storage.standby_data_bucket_arn
}

resource "aws_ssm_parameter" "application_artifact_key" {
  name  = "/${var.project_name}/${local.environment}/storage/application_artifact_key"
  type  = "String"
  value = module.storage.application_artifact_key
}
