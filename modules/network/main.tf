# Provider Configuration Pattern
# Each module explicitly receives both provider configurations (primary and standby regions)
# This is necessary for multi-region deployments because:
# 1. Modules need access to multiple AWS providers with different region aliases
# 2. Terraform requires explicit provider passing when using provider aliases
# 3. This pattern allows each module to deploy resources to both regions independently
# 4. Alternative (using required_providers in each module) would require declaring requirements
#    in each submodule, making the provider hierarchy harder to trace and manage

module "vpcs" {
    source = "./vpcs"

    primary_vpc_name   = var.primary_vpc_name
    primary_vpc_cidr   = var.primary_vpc_cidr
    standby_vpc_name   = var.standby_vpc_name
    standby_vpc_cidr   = var.standby_vpc_cidr

    providers = {
        aws = aws
        aws.standby_region_aws = aws.standby_region_aws
    }
}

module "subnets" {
    source = "./subnets"

    vpc_id = {
        primary = module.vpcs.primary_vpc_id,
        standby = module.vpcs.standby_vpc_id      
    }
    primary_vpc_cidr = var.primary_vpc_cidr
    standby_vpc_cidr = var.standby_vpc_cidr
    
    providers = {
        aws = aws
        aws.standby_region_aws = aws.standby_region_aws
    }

}

module "gateways" {
    source  = "./gateways"
    vpc_id = {
        primary = module.vpcs.primary_vpc_id,
        standby = module.vpcs.standby_vpc_id    
    }

    providers = {
        aws = aws
        aws.standby_region_aws = aws.standby_region_aws
    }   
  
}
module "rttables" {
    source  = "./rttables"
    vpc_id = {
        primary = module.vpcs.primary_vpc_id,
        standby = module.vpcs.standby_vpc_id    
    }

    providers = {
        aws = aws
        aws.standby_region_aws = aws.standby_region_aws
    }
  
}
module "routes" {
    source  = "./routes"
    primary_rt_ids = module.rttables.primary_rt_id
    standby_rt_ids = module.rttables.standby_rt_id
    aws_primary_internet_gateway_id = module.gateways.primary_igw_id
    aws_standby_internet_gateway_id = module.gateways.standby_igw_id

    providers = {
        aws = aws
        aws.standby_region_aws = aws.standby_region_aws
    }
}

module "associations" {
    source  = "./associations"
    primary_vpc_subnet = module.subnets.primary_vpc_subnet
    primary_rt_ids = module.rttables.primary_rt_id
    standby_vpc_subnet = module.subnets.standby_vpc_subnet
    standby_rt_ids = module.rttables.standby_rt_id

    providers = {
        aws = aws
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
        aws = aws
        aws.standby_region_aws = aws.standby_region_aws
    }
}
module "security_group_rules" {
  source = "./security_group_rules"

    primary_public_sg_id = module.security_groups.primary_public_sg_id
    primary_private_sg_id = module.security_groups.primary_private_sg_id
    standby_public_sg_id = module.security_groups.standby_public_sg_id
    standby_private_sg_id = module.security_groups.standby_private_sg_id
    public_inbound_rules = var.public_inbound_rules
    
  providers = {
    aws = aws
    aws.standby_region_aws = aws.standby_region_aws
  }
}
