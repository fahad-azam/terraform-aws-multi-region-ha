module "database" {
  source = "../modules/database"

  project_name       = var.project_name
  primary_region_aws = var.primary_region_aws
  standby_region_aws = var.standby_region_aws
  environment        = local.environment
  db_params = merge(var.db_params, {
    enable_multi_az = var.enable_multi_az
  })

  providers = {
    aws                    = aws
    aws.standby_region_aws = aws.standby_region_aws
  }
}
