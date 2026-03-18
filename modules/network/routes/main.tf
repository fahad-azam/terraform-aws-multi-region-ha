resource "aws_route" "primary_public_subnet_to_igw" {
  route_table_id         = var.primary_rt_ids["public"]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.aws_primary_internet_gateway_id
}
resource "aws_route" "standby_public_subnet_to_igw" {
  provider               = aws.standby_region_aws
  route_table_id         = var.standby_rt_ids["public"]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.aws_standby_internet_gateway_id
}

resource "aws_route" "primary_private_subnet_to_nat" {
  route_table_id         = var.primary_rt_ids["private"]
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = var.primary_nat_network_interface_id
}

resource "aws_route" "standby_private_subnet_to_nat" {
  provider               = aws.standby_region_aws
  route_table_id         = var.standby_rt_ids["private"]
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = var.standby_nat_network_interface_id
}

