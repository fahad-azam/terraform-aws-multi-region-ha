resource "aws_ssm_parameter" "app_record_fqdn" {
  name  = "/${var.project_name}/${local.environment}/route53/app_record_fqdn"
  type  = "String"
  value = aws_route53_record.app.fqdn
}

resource "aws_ssm_parameter" "db_record_fqdn" {
  name  = "/${var.project_name}/${local.environment}/route53/db_record_fqdn"
  type  = "String"
  value = aws_route53_record.db.fqdn
}
