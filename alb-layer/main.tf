module "load-balancer" {
  source       = "../modules/alb"
  project_name = var.project_name
  environment  = var.environment

  target_group_config = var.target_group_config
  listener_config     = var.listener_config
  common_tags         = local.common_tags
  providers = {
    aws                    = aws
    aws.standby_region_aws = aws.standby_region_aws
  }

}