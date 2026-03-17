output "primary_asg_name" {
  description = "Primary region Auto Scaling Group name"
  value       = aws_autoscaling_group.primary_application.name
}

output "standby_asg_name" {
  description = "Standby region Auto Scaling Group name"
  value       = aws_autoscaling_group.standby_application.name
}

output "primary_application_security_group_id" {
  description = "Primary region application security group"
  value       = aws_security_group.primary_application.id
}

output "standby_application_security_group_id" {
  description = "Standby region application security group"
  value       = aws_security_group.standby_application.id
}
