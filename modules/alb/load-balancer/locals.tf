locals {
  ssm_base = "/${var.project_name}/${var.environment}/network"

  # --- Primary Region Parsing ---
  primary_all_names  = data.aws_ssm_parameters_by_path.primary.names
  primary_all_values = data.aws_ssm_parameters_by_path.primary.values

  primary_public_sgs = [
    for i, name in local.primary_all_names : local.primary_all_values[i]
    if can(regex("/public_sg_id$", name))
  ]

  primary_public_subnets = [
    for i, name in local.primary_all_names : local.primary_all_values[i]
    if can(regex("/subnets/public_", name))
  ]

  # --- Standby Region Parsing ---
  standby_all_names  = data.aws_ssm_parameters_by_path.standby.names
  standby_all_values = data.aws_ssm_parameters_by_path.standby.values

  standby_public_sgs = [
    for i, name in local.standby_all_names : local.standby_all_values[i]
    if can(regex("/public_sg_id$", name))
  ]

  standby_public_subnets = [
    for i, name in local.standby_all_names : local.standby_all_values[i]
    if can(regex("/subnets/public_", name))
  ]
}