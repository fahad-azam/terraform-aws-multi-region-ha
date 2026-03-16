locals {
  common_tags = merge(
    {
      Project   = var.project_name
      ManagedBy = "Terraform"
      Layer     = "Database"
    },
    var.additional_tags
  )
  environment = var.environment
}
