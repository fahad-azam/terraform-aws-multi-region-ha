data "aws_ssm_parameter" "db_subnets" {
  for_each = {
    for pair in setproduct(local.regions, local.subnet_keys) :
    "${pair[0]}.${pair[1]}" => "/${var.project_name}/network/${pair[0]}/subnets/${pair[1]}/id"
  }
  name = each.value
}