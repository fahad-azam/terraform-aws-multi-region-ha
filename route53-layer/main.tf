resource "aws_route53_zone" "primary" {
  name = var.domain_name

  tags = merge(local.common_tags, {
    Name = var.domain_name
  })
}

resource "aws_route53_record" "app" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = local.app_record_fqdn
  type    = "CNAME"
  ttl     = var.app_record_ttl
  records = [data.aws_ssm_parameter.primary_alb_dns_name.value]
}

resource "aws_route53_record" "db" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = local.db_record_fqdn
  type    = "CNAME"
  ttl     = var.db_record_ttl
  records = [local.primary_db_target]
}
