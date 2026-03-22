locals {
  common_tags = merge(
    {
      Project     = var.project_name
      ManagedBy   = "Terraform"
      Layer       = "route53"
      Environment = lower(var.environment)
    },
    var.additional_tags
  )

  environment       = lower(var.environment)
  app_record_fqdn   = "${var.app_record_name}.${var.domain_name}"
  db_record_fqdn    = "${var.db_record_name}.${var.domain_name}"
  primary_db_target = trimsuffix(data.aws_ssm_parameter.primary_db_endpoint.value, ":${data.aws_ssm_parameter.primary_db_port.value}")
}
