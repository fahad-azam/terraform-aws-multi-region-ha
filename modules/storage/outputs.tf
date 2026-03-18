output "primary_artifact_bucket_name" {
  description = "Primary region artifact bucket name"
  value       = aws_s3_bucket.primary_artifact.bucket
}

output "primary_artifact_bucket_arn" {
  description = "Primary region artifact bucket ARN"
  value       = aws_s3_bucket.primary_artifact.arn
}

output "standby_artifact_bucket_name" {
  description = "Standby region artifact bucket name"
  value       = aws_s3_bucket.standby_artifact.bucket
}

output "standby_artifact_bucket_arn" {
  description = "Standby region artifact bucket ARN"
  value       = aws_s3_bucket.standby_artifact.arn
}

output "primary_data_bucket_name" {
  description = "Primary region data bucket name"
  value       = aws_s3_bucket.primary_data.bucket
}

output "primary_data_bucket_arn" {
  description = "Primary region data bucket ARN"
  value       = aws_s3_bucket.primary_data.arn
}

output "standby_data_bucket_name" {
  description = "Standby region data bucket name"
  value       = aws_s3_bucket.standby_data.bucket
}

output "standby_data_bucket_arn" {
  description = "Standby region data bucket ARN"
  value       = aws_s3_bucket.standby_data.arn
}

output "application_artifact_key" {
  description = "Object key for the application artifact"
  value       = local.app_artifact_key
}
