resource "aws_ssm_parameter" "primary_target_group_arn" {
  name  = "/${var.project_name}/${local.environment}/alb/primary/target_group_arn"
  type  = "String"
  value = module.load-balancer.primary_target_group_arn
}

resource "aws_ssm_parameter" "standby_target_group_arn" {
  name  = "/${var.project_name}/${local.environment}/alb/standby/target_group_arn"
  type  = "String"
  value = module.load-balancer.standby_target_group_arn
}

resource "aws_ssm_parameter" "primary_alb_dns_name" {
  name  = "/${var.project_name}/${local.environment}/alb/primary/dns_name"
  type  = "String"
  value = module.load-balancer.primary_alb_dns_name
}

resource "aws_ssm_parameter" "standby_alb_dns_name" {
  name  = "/${var.project_name}/${local.environment}/alb/standby/dns_name"
  type  = "String"
  value = module.load-balancer.standby_alb_dns_name
}

resource "aws_ssm_parameter" "target_group_port" {
  name  = "/${var.project_name}/${local.environment}/alb/config/target_group_port"
  type  = "String"
  value = tostring(var.target_group_config.port)
}
