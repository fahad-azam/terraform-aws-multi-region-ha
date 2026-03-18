module "network" {
  source = "../modules/network"

  project_name         = var.project_name
  environment          = lower(var.environment)
  standby_region_aws   = var.standby_region_aws
  primary_vpc_name     = var.primary_vpc_name
  primary_vpc_cidr     = var.primary_vpc_cidr
  standby_vpc_name     = var.standby_vpc_name
  standby_vpc_cidr     = var.standby_vpc_cidr
  public_inbound_rules = var.public_inbound_rules
  nat_instance_type    = var.nat_instance_type
  database_port        = var.database_port


  providers = {
    aws                    = aws
    aws.standby_region_aws = aws.standby_region_aws
  }
}
