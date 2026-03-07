# File: network-layer/ssm.tf

resource "aws_ssm_parameter" "primary_vpc_id" {
  name  = "/${var.project_name}/network/primary_vpc_id"
  type  = "String"
  value = module.network.primary_vpc_id
}

resource "aws_ssm_parameter" "standby_vpc_id" {
  name  = "/${var.project_name}/network/standby_vpc_id"
  type  = "String"
  value = module.network.standby_vpc_id
}
resource "aws_ssm_parameter" "primary_subnets" {
  for_each = module.network.primary_vpc_subnet
  name     = "/${var.project_name}/network/primary/subnets/${each.key}/id"
  type     = "String"
  value    = each.value.id
}
resource "aws_ssm_parameter" "standby_subnets" {
  for_each = module.network.standby_vpc_subnet
  name     = "/${var.project_name}/network/standby/subnets/${each.key}/id"
  type     = "String"
  value    = each.value.id
}
resource "aws_ssm_parameter" "primary_route_tables" {
  for_each = module.network.primary_rt_id
  name     = "/${var.project_name}/network/primary/route_tables/${each.key}/id"
  type     = "String"
  value    = each.value
}
resource "aws_ssm_parameter" "standby_route_tables" {
  for_each = module.network.standby_rt_id
  name     = "/${var.project_name}/network/standby/route_tables/${each.key}/id"
  type     = "String"
  value    = each.value
}
resource "aws_ssm_parameter" "primary_igw_id" {
  name  = "/${var.project_name}/network/primary/igw_id"
  type  = "String"
  value = module.network.primary_igw_id
}
resource "aws_ssm_parameter" "standby_igw_id" {
  name  = "/${var.project_name}/network/standby/igw_id"
  type  = "String"
  value = module.network.standby_igw_id
}
resource "aws_ssm_parameter" "primary_public_sg_id" {
  name  = "/${var.project_name}/network/primary/public_sg_id"
  type  = "String"
  value = module.network.primary_public_sg_id
}
resource "aws_ssm_parameter" "standby_public_sg_id" {
  name  = "/${var.project_name}/network/standby/public_sg_id"
  type  = "String"
  value = module.network.standby_public_sg_id
}
resource "aws_ssm_parameter" "primary_private_sg_id" {
  name  = "/${var.project_name}/network/primary/private_sg_id"
  type  = "String"
  value = module.network.primary_private_sg_id
}
resource "aws_ssm_parameter" "standby_private_sg_id" {
  name  = "/${var.project_name}/network/standby/private_sg_id"
  type  = "String"
  value = module.network.standby_private_sg_id
}