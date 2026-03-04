

resource "aws_route_table" "primary_rt" {
  for_each = local.rt_tables

  vpc_id = var.vpc_id["primary"]
    tags = {
        Name = "rt-${each.value.suffix}"
    }
}

resource "aws_route_table" "standby_rt" {
  for_each = local.rt_tables

  provider = aws.standby_region_aws
  vpc_id = var.vpc_id["standby"]
    tags = {
        Name = "rt-${each.value.suffix}"
    }
}