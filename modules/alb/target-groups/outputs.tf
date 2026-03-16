output "primary_target_group_arn" {
  value = aws_lb_target_group.primary.arn
}

output "primary_target_group_name" {
  value = aws_lb_target_group.primary.name
}

output "standby_target_group_arn" {
  value = aws_lb_target_group.standby.arn
}

output "standby_target_group_name" {
  value = aws_lb_target_group.standby.name
}