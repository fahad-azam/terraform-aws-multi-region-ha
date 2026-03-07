data "aws_availability_zones" "primary" {
  state = "available"
}

data "aws_availability_zones" "standby" {
  provider = aws.standby_region_aws
  state    = "available"
}

resource "aws_subnet" "primary_vpc_subnets" {
  for_each = local.subnets_vpcs

  vpc_id                  = var.vpc_id["primary"]
  cidr_block              = cidrsubnet(var.primary_vpc_cidr, 8, each.value.cidr_index)
  availability_zone       = data.aws_availability_zones.primary.names[each.value.az_index]
  map_public_ip_on_launch = each.value.public
}

resource "aws_subnet" "standby_vpc_subnets" {
  for_each = local.subnets_vpcs

  provider                = aws.standby_region_aws
  vpc_id                  = var.vpc_id["standby"]
  cidr_block              = cidrsubnet(var.standby_vpc_cidr, 8, each.value.cidr_index)
  availability_zone       = data.aws_availability_zones.standby.names[each.value.az_index]
  map_public_ip_on_launch = each.value.public
}