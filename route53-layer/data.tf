data "aws_ssm_parameter" "primary_alb_dns_name" {
  name = "/${var.project_name}/${var.environment}/alb/primary/dns_name"
}

data "aws_ssm_parameter" "primary_db_endpoint" {
  name = "/${var.project_name}/${var.environment}/rds/primary/endpoint"
}

data "aws_ssm_parameter" "primary_db_port" {
  name = "/${var.project_name}/${var.environment}/rds/primary/port"
}
