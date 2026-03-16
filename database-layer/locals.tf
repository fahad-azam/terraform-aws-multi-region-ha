locals {
  common_tags = merge(
    {
      Project     = var.project_name
      ManagedBy   = "Terraform"
      Layer       = "Database"
      Environment = lower(var.environment)
    },
    var.additional_tags
  )
  environment = lower(var.environment)
}
