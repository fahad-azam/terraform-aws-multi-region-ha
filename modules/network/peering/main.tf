resource "aws_vpc_peering_connection" "primary_to_standby" {
  vpc_id      = var.vpc_ids["primary"]
  peer_vpc_id = var.vpc_ids["standby"]
  peer_region = var.standby_region_aws
  auto_accept = false

  tags = {
    Name = "${var.project_name}-${var.environment}-primary-standby-peering"
  }
}

resource "aws_vpc_peering_connection_accepter" "standby_accept" {
  provider                  = aws.standby_region_aws
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_standby.id
  auto_accept               = true

  tags = {
    Name = "${var.project_name}-${var.environment}-standby-peering-accepter"
  }
}

resource "aws_vpc_peering_connection_options" "requester" {
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_standby.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  depends_on = [aws_vpc_peering_connection_accepter.standby_accept]
}

resource "aws_vpc_peering_connection_options" "accepter" {
  provider                  = aws.standby_region_aws
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_standby.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  depends_on = [aws_vpc_peering_connection_accepter.standby_accept]
}

resource "aws_route" "primary_private_to_standby" {
  route_table_id            = var.route_table_ids["primary"]
  destination_cidr_block    = var.vpc_cidrs["standby"]
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_standby.id
}

resource "aws_route" "standby_private_to_primary" {
  provider                  = aws.standby_region_aws
  route_table_id            = var.route_table_ids["standby"]
  destination_cidr_block    = var.vpc_cidrs["primary"]
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_standby.id
}
