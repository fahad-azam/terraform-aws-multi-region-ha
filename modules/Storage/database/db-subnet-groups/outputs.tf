output "primary_db_subnet_group_name" {
  description = "The ID of the primary region DB subnet group"
  value       = aws_db_subnet_group.primary.name
}

output "primary_db_subnet_group_arn" {
  description = "The ARN of the primary region DB subnet group"
  value       = aws_db_subnet_group.primary.arn
}

output "standby_db_subnet_group_name" {
  description = "The ID of the standby region DB subnet group"
  value       = aws_db_subnet_group.standby.name
}

output "standby_db_subnet_group_arn" {
  description = "The ARN of the standby region DB subnet group"
  value       = aws_db_subnet_group.standby.arn
}

output "primary_subnet_ids_used" {
  description = "The specific subnet IDs filtered for the primary group"
  value       = aws_db_subnet_group.primary.subnet_ids
}

output "standby_subnet_ids_used" {
  description = "The specific subnet IDs filtered for the standby group"
  value       = aws_db_subnet_group.standby.subnet_ids
}