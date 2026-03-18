module "storage" {
  source = "../modules/storage"

  project_name       = var.project_name
  environment        = local.environment
  primary_region_aws = var.primary_region_aws
  standby_region_aws = var.standby_region_aws
  common_tags        = local.common_tags

  providers = {
    aws                    = aws
    aws.standby_region_aws = aws.standby_region_aws
  }
}
