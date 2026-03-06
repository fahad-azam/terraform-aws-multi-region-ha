module "network" {
    source = "../modules/network"

    primary_vpc_name   = var.primary_vpc_name
    primary_vpc_cidr   = var.primary_vpc_cidr
    standby_vpc_name   = var.standby_vpc_name
    standby_vpc_cidr   = var.standby_vpc_cidr
    public_inbound_rules = var.public_inbound_rules


    providers = {
        aws = aws
        aws.standby_region_aws = aws.standby_region_aws
    }
}
