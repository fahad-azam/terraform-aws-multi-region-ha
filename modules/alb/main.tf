module "load_balancer" {
  source = "./load-balancer"

  project_name    = var.project_name
  environment     = var.environment
  common_tags     = var.common_tags
  providers = {
    aws                    = aws
    aws.standby_region_aws = aws.standby_region_aws
  }
}

module "target_group" {
  source = "./target-groups"

  project_name        = var.project_name
  environment         = var.environment
  
  common_tags         = var.common_tags
  target_group_config = var.target_group_config

  providers = {
    aws                    = aws
    aws.standby_region_aws = aws.standby_region_aws
  }
}

module "listeners" {
  source = "./listeners"

  project_name    = var.project_name
  environment     = var.environment
  primary_lb_arn  = module.load_balancer.primary_alb_arn
  standby_lb_arn  = module.load_balancer.standby_alb_arn
  primary_tg_arn  = module.target_group.primary_target_group_arn
  standby_tg_arn  = module.target_group.standby_target_group_arn
  listener_config = var.listener_config

  providers = {
    aws                    = aws
    aws.standby_region_aws = aws.standby_region_aws
  }
}
