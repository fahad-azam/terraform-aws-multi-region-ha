module "iam" {
  source = "../modules/iam"

  project_name = var.project_name
  environment  = local.environment
  common_tags  = local.common_tags

  providers = {
    aws                    = aws
    aws.standby_region_aws = aws.standby_region_aws
  }
}
