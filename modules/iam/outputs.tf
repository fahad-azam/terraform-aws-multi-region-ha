output "primary_application_role_name" {
  description = "Primary application IAM role name"
  value       = aws_iam_role.primary_application.name
}

output "primary_application_instance_profile_name" {
  description = "Primary application instance profile name"
  value       = aws_iam_instance_profile.primary_application.name
}

output "standby_application_role_name" {
  description = "Standby application IAM role name"
  value       = aws_iam_role.standby_application.name
}

output "standby_application_instance_profile_name" {
  description = "Standby application instance profile name"
  value       = aws_iam_instance_profile.standby_application.name
}

output "standby_jobs_lambda_role_arn" {
  description = "IAM role ARN shared by standby jobs Lambdas"
  value       = aws_iam_role.standby_jobs_lambda.arn
}
