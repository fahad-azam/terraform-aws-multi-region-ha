module "jobs" {
  source = "../modules/jobs"

  project_name       = var.project_name
  environment        = local.environment
  primary_region_aws = var.primary_region_aws
  standby_region_aws = var.standby_region_aws
  db_port            = var.db_port
  app_readiness_path = var.app_readiness_path
  common_tags        = local.common_tags

  providers = {
    aws                    = aws
    aws.standby_region_aws = aws.standby_region_aws
  }
}
