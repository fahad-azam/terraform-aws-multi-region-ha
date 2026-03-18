output "hosted_zone_id" {
  description = "Public hosted zone ID for the domain"
  value       = aws_route53_zone.primary.zone_id
}

output "hosted_zone_name_servers" {
  description = "Name servers to configure at the domain registrar"
  value       = aws_route53_zone.primary.name_servers
}

output "app_record_fqdn" {
  description = "Application DNS record name"
  value       = aws_route53_record.app.fqdn
}

output "db_record_fqdn" {
  description = "Database DNS record name"
  value       = aws_route53_record.db.fqdn
}

output "app_record_target" {
  description = "Primary application DNS target"
  value       = data.aws_ssm_parameter.primary_alb_dns_name.value
  sensitive   = true
}

output "db_record_target" {
  description = "Primary database DNS target"
  value       = local.primary_db_target
  sensitive   = true
}
