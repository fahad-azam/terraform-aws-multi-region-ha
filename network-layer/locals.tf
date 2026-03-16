locals {
  common_tags = merge(
    {
      Project   = var.project_name
      ManagedBy = "Terraform"
      Layer     = "network"
    },
    var.additional_tags
  )
  environment = lower(var.environment)
}
