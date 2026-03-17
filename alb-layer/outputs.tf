output "primary_target_group_arn" {
  description = "Primary region ALB target group ARN"
  value       = module.load-balancer.primary_target_group_arn
}

output "standby_target_group_arn" {
  description = "Standby region ALB target group ARN"
  value       = module.load-balancer.standby_target_group_arn
}

output "primary_alb_dns_name" {
  description = "Primary region ALB DNS name"
  value       = module.load-balancer.primary_alb_dns_name
}

output "standby_alb_dns_name" {
  description = "Standby region ALB DNS name"
  value       = module.load-balancer.standby_alb_dns_name
}
