locals {
  common_tags = merge(
    {
      Project     = var.project_name
      ManagedBy   = "Terraform"
      Layer       = "Application-Load-Balancer"
      Environment = lower(var.environment)
    },
    var.additional_tags
  )
  environment = lower(var.environment)

}
