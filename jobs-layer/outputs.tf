output "ssm_replication_lambda_name" {
  description = "Name of the SSM replication Lambda"
  value       = module.jobs.ssm_replication_lambda_name
}

output "full_failover_lambda_name" {
  description = "Name of the full failover Lambda"
  value       = module.jobs.full_failover_lambda_name
}

output "full_failback_lambda_name" {
  description = "Name of the full failback Lambda"
  value       = module.jobs.full_failback_lambda_name
}

output "rebuild_standby_replica_lambda_name" {
  description = "Name of the standby replica rebuild Lambda"
  value       = module.jobs.rebuild_standby_replica_lambda_name
}
