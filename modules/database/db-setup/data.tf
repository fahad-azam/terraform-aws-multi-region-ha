# Fetch Security Group IDs from SSM using the project name from the object
data "aws_ssm_parameter" "db_sgs" {
  for_each = local.sg_ssm_paths
  name     = each.value
}