locals {
  application_port = tonumber(data.aws_ssm_parameter.target_group_port.value)
  runtime_name     = replace(lower(var.project_name), "_", "-")
  install_dir      = "/opt/${local.runtime_name}"
  env_file_path    = "/etc/${local.runtime_name}.env"
  service_name     = "${local.runtime_name}.service"

  primary_private_app_subnet_ids = [
    data.aws_ssm_parameter.primary_private_app_subnet_az1.value,
    data.aws_ssm_parameter.primary_private_app_subnet_az2.value,
  ]

  standby_private_app_subnet_ids = [
    data.aws_ssm_parameter.standby_private_app_subnet_az1.value,
    data.aws_ssm_parameter.standby_private_app_subnet_az2.value,
  ]
}
