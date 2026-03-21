output "ssm_replication_lambda_name" {
  description = "Name of the SSM replication Lambda"
  value       = module.jobs.ssm_replication_lambda_name
}

output "full_failover_lambda_name" {
  description = "Name of the full failover Lambda"
  value       = module.jobs.full_failover_lambda_name
}
