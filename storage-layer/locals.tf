locals {
  common_tags = merge(
    {
      Project   = var.project_name
      ManagedBy = "Terraform"
      Layer     = "Storage"
    },
    var.additional_tags
  )
}
