resource "aws_ssm_parameter" "primary_application_instance_profile_name" {
  name  = "/${var.project_name}/${local.environment}/iam/primary/application_instance_profile_name"
  type  = "String"
  value = module.iam.primary_application_instance_profile_name
}

resource "aws_ssm_parameter" "standby_application_instance_profile_name" {
  name  = "/${var.project_name}/${local.environment}/iam/standby/application_instance_profile_name"
  type  = "String"
  value = module.iam.standby_application_instance_profile_name
}
