locals {
  ssm_base = "/${var.project_name}/${var.environment}/network"
  # --- Primary Region Parsing ---
  primary_all_names  = data.aws_ssm_parameters_by_path.primary.names
  primary_all_values = data.aws_ssm_parameters_by_path.primary.values



  # --- VPC ID Extraction ---

  # Searches for any parameter ending in _vpc_id
  primary_vpc_id = [
    for i, name in local.primary_all_names : local.primary_all_values[i]
    if can(regex("_vpc_id$", name))
  ][0] # Taking the first (and only) match

  # --- Standby Region Parsing ---
  standby_all_names  = data.aws_ssm_parameters_by_path.standby.names
  standby_all_values = data.aws_ssm_parameters_by_path.standby.values

  standby_vpc_id = [
    for i, name in local.standby_all_names : local.standby_all_values[i]
    if can(regex("_vpc_id$", name))
  ][0]
}