# Variables (Matching your output structures)


# The Association Resource
resource "aws_route_table_association" "primary" {
  for_each = var.primary_vpc_subnet

  subnet_id = each.value.id

  # Logic: If public IP on launch is true, use the "public" RT, else "private"
  route_table_id = each.value.map_public_ip_on_launch ? var.primary_rt_ids["public"] : var.primary_rt_ids["private"]
}

resource "aws_route_table_association" "standby" {
  for_each = var.standby_vpc_subnet

  provider  = aws.standby_region_aws
  subnet_id = each.value.id

  # Logic: If public IP on launch is true, use the "public" RT, else "private"
  route_table_id = each.value.map_public_ip_on_launch ? var.standby_rt_ids["public"] : var.standby_rt_ids["private"]
}   