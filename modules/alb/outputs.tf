output "primary_alb_arn" {
  description = "Primary region ALB ARN"
  value       = module.load_balancer.primary_alb_arn
}

output "primary_alb_dns_name" {
  description = "Primary region ALB DNS name"
  value       = module.load_balancer.primary_alb_dns_name
}

output "standby_alb_arn" {
  description = "Standby region ALB ARN"
  value       = module.load_balancer.standby_alb_arn
}

output "standby_alb_dns_name" {
  description = "Standby region ALB DNS name"
  value       = module.load_balancer.standby_alb_dns_name
}

output "primary_target_group_arn" {
  description = "Primary region target group ARN"
  value       = module.target_group.primary_target_group_arn
}

output "standby_target_group_arn" {
  description = "Standby region target group ARN"
  value       = module.target_group.standby_target_group_arn
}
