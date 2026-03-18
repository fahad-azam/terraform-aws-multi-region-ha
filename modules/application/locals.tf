locals {
  application_port = tonumber(data.aws_ssm_parameter.target_group_port.value)

  primary_private_app_subnet_ids = [
    data.aws_ssm_parameter.primary_private_app_subnet_az1.value,
    data.aws_ssm_parameter.primary_private_app_subnet_az2.value,
  ]

  standby_private_app_subnet_ids = [
    data.aws_ssm_parameter.standby_private_app_subnet_az1.value,
    data.aws_ssm_parameter.standby_private_app_subnet_az2.value,
  ]
}
