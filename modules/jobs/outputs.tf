output "ssm_replication_lambda_name" {
  description = "Name of the SSM replication Lambda"
  value       = aws_lambda_function.ssm_replication.function_name
}

output "full_failover_lambda_name" {
  description = "Name of the full failover Lambda"
  value       = aws_lambda_function.full_failover.function_name
}
