module "application" {
  source = "../modules/application"

  project_name      = var.project_name
  environment       = local.environment
  instance_type     = var.instance_type
  desired_capacity  = var.desired_capacity
  min_size          = var.min_size
  max_size          = var.max_size
  health_check_path = var.health_check_path
  common_tags       = local.common_tags

  providers = {
    aws                    = aws
    aws.standby_region_aws = aws.standby_region_aws
  }
}
