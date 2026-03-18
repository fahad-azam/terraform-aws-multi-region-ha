data "aws_ssm_parameter" "primary_private_app_subnet_az1" {
  name = "/${var.project_name}/${var.environment}/network/primary/subnets/private_app1/id"
}

data "aws_ssm_parameter" "primary_private_app_subnet_az2" {
  name = "/${var.project_name}/${var.environment}/network/primary/subnets/private_app2/id"
}

data "aws_ssm_parameter" "standby_private_app_subnet_az1" {
  name = "/${var.project_name}/${var.environment}/network/standby/subnets/private_app1/id"
}

data "aws_ssm_parameter" "standby_private_app_subnet_az2" {
  name = "/${var.project_name}/${var.environment}/network/standby/subnets/private_app2/id"
}

data "aws_ssm_parameter" "primary_application_sg_id" {
  name = "/${var.project_name}/${var.environment}/network/primary/application_sg_id"
}

data "aws_ssm_parameter" "standby_application_sg_id" {
  name = "/${var.project_name}/${var.environment}/network/standby/application_sg_id"
}

data "aws_ssm_parameter" "primary_db_endpoint" {
  name = "/${var.project_name}/${var.environment}/rds/primary/endpoint"
}

data "aws_ssm_parameter" "db_record_fqdn" {
  name = "/${var.project_name}/${var.environment}/route53/db_record_fqdn"
}

data "aws_ssm_parameter" "standby_db_endpoint" {
  name = "/${var.project_name}/${var.environment}/rds/standby/endpoint"
}

data "aws_ssm_parameter" "primary_db_port" {
  name = "/${var.project_name}/${var.environment}/rds/primary/port"
}

data "aws_ssm_parameter" "standby_db_port" {
  name = "/${var.project_name}/${var.environment}/rds/standby/port"
}

data "aws_ssm_parameter" "primary_target_group_arn" {
  name = "/${var.project_name}/${var.environment}/alb/primary/target_group_arn"
}

data "aws_ssm_parameter" "standby_target_group_arn" {
  name = "/${var.project_name}/${var.environment}/alb/standby/target_group_arn"
}

data "aws_ssm_parameter" "target_group_port" {
  name = "/${var.project_name}/${var.environment}/alb/config/target_group_port"
}

data "aws_ssm_parameter" "primary_application_instance_profile_name" {
  name = "/${var.project_name}/${var.environment}/iam/primary/application_instance_profile_name"
}

data "aws_ssm_parameter" "standby_application_instance_profile_name" {
  name = "/${var.project_name}/${var.environment}/iam/standby/application_instance_profile_name"
}

data "aws_ssm_parameter" "primary_artifact_bucket_name" {
  name = "/${var.project_name}/${var.environment}/storage/primary/artifact_bucket_name"
}

data "aws_ssm_parameter" "standby_artifact_bucket_name" {
  name = "/${var.project_name}/${var.environment}/storage/standby/artifact_bucket_name"
}

data "aws_ssm_parameter" "primary_data_bucket_name" {
  name = "/${var.project_name}/${var.environment}/storage/primary/data_bucket_name"
}

data "aws_ssm_parameter" "standby_data_bucket_name" {
  name = "/${var.project_name}/${var.environment}/storage/standby/data_bucket_name"
}

data "aws_ssm_parameter" "application_artifact_key" {
  name = "/${var.project_name}/${var.environment}/storage/application_artifact_key"
}

data "aws_ssm_parameter" "al2023_primary" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

data "aws_ssm_parameter" "al2023_standby" {
  provider = aws.standby_region_aws
  name     = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}
