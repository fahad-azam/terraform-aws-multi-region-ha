output "primary_db_instance_id" {
  description = "Identifier of the primary RDS instance"
  value       = aws_db_instance.primary.identifier
}

output "primary_db_instance_arn" {
  description = "ARN of the primary RDS instance"
  value       = aws_db_instance.primary.arn
}

output "primary_db_endpoint" {
  description = "Connection endpoint of the primary RDS instance"
  value       = aws_db_instance.primary.endpoint
}

output "primary_db_port" {
  description = "Port of the primary RDS instance"
  value       = aws_db_instance.primary.port
}

output "standby_db_instance_id" {
  description = "Identifier of the standby RDS instance"
  value       = aws_db_instance.standby.identifier
}

output "standby_db_instance_arn" {
  description = "ARN of the standby RDS instance"
  value       = aws_db_instance.standby.arn
}

output "standby_db_endpoint" {
  description = "Connection endpoint of the standby RDS instance"
  value       = aws_db_instance.standby.endpoint
}

output "standby_db_port" {
  description = "Port of the standby RDS instance"
  value       = aws_db_instance.standby.port
}
