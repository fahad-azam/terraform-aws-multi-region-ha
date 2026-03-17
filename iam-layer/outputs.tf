output "primary_application_role_name" {
  description = "Primary application IAM role name"
  value       = module.iam.primary_application_role_name
}

output "primary_application_instance_profile_name" {
  description = "Primary application IAM instance profile name"
  value       = module.iam.primary_application_instance_profile_name
}

output "standby_application_role_name" {
  description = "Standby application IAM role name"
  value       = module.iam.standby_application_role_name
}

output "standby_application_instance_profile_name" {
  description = "Standby application IAM instance profile name"
  value       = module.iam.standby_application_instance_profile_name
}
