module "db_subnet_groups" {
  source = "./db-subnet-groups"

  project_name        = var.project_name
  primary_region_aws  = var.primary_region_aws
  standby_region_aws  = var.standby_region_aws

  providers = {
    aws                    = aws
    aws.standby_region_aws = aws.standby_region_aws
  }
}
module "db-setup" {
  source = "./db-setup"

  project_name        = var.project_name
  primary_region_aws  = var.primary_region_aws
  standby_region_aws  = var.standby_region_aws
  environment         = var.environment
  db_params           = var.db_params
  # Pass the subnet group names from the sibling module
  primary_db_subnet_group_name = module.db_subnet_groups.primary_db_subnet_group_name
  standby_db_subnet_group_name = module.db_subnet_groups.standby_db_subnet_group_name

  providers = {
    aws                    = aws
    aws.standby_region_aws = aws.standby_region_aws
  }
  
}
