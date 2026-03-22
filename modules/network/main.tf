# written on 2026-02-17
# Orchestration of all network components 

module "vpcs" {
  source = "./vpcs"

  primary_vpc_name = var.primary_vpc_name
  primary_vpc_cidr = var.primary_vpc_cidr
  standby_vpc_name = var.standby_vpc_name
  standby_vpc_cidr = var.standby_vpc_cidr

  providers = {
    aws                    = aws
    aws.standby_region_aws = aws.standby_region_aws
  }
}


module "subnets" {
  
  source = "./subnets"
   project_name       = var.project_name
  environment        = var.environment  
  
  vpc_id = {
    primary = module.vpcs.primary_vpc_id,
    standby = module.vpcs.standby_vpc_id
  }
  primary_vpc_cidr = var.primary_vpc_cidr
  standby_vpc_cidr = var.standby_vpc_cidr

  providers = {
    aws                    = aws
    aws.standby_region_aws = aws.standby_region_aws
  }

}

module "gateways" {
  source = "./gateways"
  vpc_id = {
    primary = module.vpcs.primary_vpc_id,
    standby = module.vpcs.standby_vpc_id
  }
  vpc_cidrs = {
    primary = var.primary_vpc_cidr,
    standby = var.standby_vpc_cidr
  }
  public_subnet_ids = {
    primary = module.subnets.primary_vpc_subnet["public_az1"].id,
    standby = module.subnets.standby_vpc_subnet["public_az1"].id
  }
  nat_instance_type = var.nat_instance_type

  providers = {
    aws                    = aws
    aws.standby_region_aws = aws.standby_region_aws
  }

}
module "rttables" {
  source = "./rttables"
  vpc_id = {
    primary = module.vpcs.primary_vpc_id,
    standby = module.vpcs.standby_vpc_id
  }

  providers = {
    aws                    = aws
    aws.standby_region_aws = aws.standby_region_aws
  }

}
module "routes" {
  source                           = "./routes"
  primary_rt_ids                   = module.rttables.primary_rt_id
  standby_rt_ids                   = module.rttables.standby_rt_id
  aws_primary_internet_gateway_id  = module.gateways.primary_igw_id
  aws_standby_internet_gateway_id  = module.gateways.standby_igw_id
  primary_nat_network_interface_id = module.gateways.primary_nat_network_interface_id
  standby_nat_network_interface_id = module.gateways.standby_nat_network_interface_id

  providers = {
    aws                    = aws
    aws.standby_region_aws = aws.standby_region_aws
  }
}

module "peering" {
  source = "./peering"

project_name       = var.project_name
environment        = var.environment
  standby_region_aws = var.standby_region_aws
  vpc_ids = {
    primary = module.vpcs.primary_vpc_id
    standby = module.vpcs.standby_vpc_id
  }
  vpc_cidrs = {
    primary = var.primary_vpc_cidr
    standby = var.standby_vpc_cidr
  }
  route_table_ids = {
    primary = module.rttables.primary_rt_id["private"]
    standby = module.rttables.standby_rt_id["private"]
  }

  providers = {
    aws                    = aws
    aws.standby_region_aws = aws.standby_region_aws
  }
}

module "endpoints" {
  source = "./endpoints"

  vpc_id = {
    primary = module.vpcs.primary_vpc_id
    standby = module.vpcs.standby_vpc_id
  }
  private_route_table_ids = {
    primary = module.rttables.primary_rt_id["private"]
    standby = module.rttables.standby_rt_id["private"]
  }

  providers = {
    aws                    = aws
    aws.standby_region_aws = aws.standby_region_aws
  }
}

module "associations" {
  source             = "./associations"
  primary_vpc_subnet = module.subnets.primary_vpc_subnet
  primary_rt_ids     = module.rttables.primary_rt_id
  standby_vpc_subnet = module.subnets.standby_vpc_subnet
  standby_rt_ids     = module.rttables.standby_rt_id

  providers = {
    aws                    = aws
    aws.standby_region_aws = aws.standby_region_aws
  }

}

module "security_groups" {
  source = "./security_groups"

  vpc_id = {
    primary = module.vpcs.primary_vpc_id,
    standby = module.vpcs.standby_vpc_id
  }

  providers = {
    aws                    = aws
    aws.standby_region_aws = aws.standby_region_aws
  }
}
module "security_group_rules" {
  source = "./security_group_rules"

  primary_public_sg_id      = module.security_groups.primary_public_sg_id
  primary_private_sg_id     = module.security_groups.primary_private_sg_id
  primary_application_sg_id = module.security_groups.primary_application_sg_id
  standby_public_sg_id      = module.security_groups.standby_public_sg_id
  standby_private_sg_id     = module.security_groups.standby_private_sg_id
  standby_application_sg_id = module.security_groups.standby_application_sg_id
  public_inbound_rules      = var.public_inbound_rules
  application_port          = var.application_port
  primary_vpc_cidr          = var.primary_vpc_cidr
  standby_vpc_cidr          = var.standby_vpc_cidr
  database_port             = var.database_port

  providers = {
    aws                    = aws
    aws.standby_region_aws = aws.standby_region_aws
  }
}
