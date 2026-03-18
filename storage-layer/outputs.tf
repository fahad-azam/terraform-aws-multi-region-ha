output "primary_artifact_bucket_name" {
  description = "Primary region artifact bucket name"
  value       = module.storage.primary_artifact_bucket_name
}

output "standby_artifact_bucket_name" {
  description = "Standby region artifact bucket name"
  value       = module.storage.standby_artifact_bucket_name
}

output "primary_data_bucket_name" {
  description = "Primary region data bucket name"
  value       = module.storage.primary_data_bucket_name
}

output "standby_data_bucket_name" {
  description = "Standby region data bucket name"
  value       = module.storage.standby_data_bucket_name
}

output "application_artifact_key" {
  description = "S3 object key for the deployed application artifact"
  value       = module.storage.application_artifact_key
}
