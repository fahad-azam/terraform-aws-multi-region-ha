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
  value       = data.aws_ssm_parameter.primary_application_sg_id.value
}

output "standby_application_security_group_id" {
  description = "Standby region application security group"
  value       = data.aws_ssm_parameter.standby_application_sg_id.value
}
