output "primary_alb_arn" {
  value = aws_lb.primary_alb.arn
}

output "primary_alb_dns_name" {
  value = aws_lb.primary_alb.dns_name
}

output "primary_alb_zone_id" {
  value = aws_lb.primary_alb.zone_id
}

output "standby_alb_arn" {
  value = aws_lb.standby_alb.arn
}

output "standby_alb_dns_name" {
  value = aws_lb.standby_alb.dns_name
}

output "standby_alb_zone_id" {
  value = aws_lb.standby_alb.zone_id
}