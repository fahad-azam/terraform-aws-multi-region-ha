locals {
  common_tags = merge(
    {
      Project     = var.project_name
      ManagedBy   = "Terraform"
      Layer       = "iam"
      Environment = lower(var.environment)
    },
    var.additional_tags
  )
  environment = lower(var.environment)
}
