data "aws_region" "primary" {}

data "aws_region" "standby" {
  provider = aws.standby_region_aws
}

resource "aws_vpc_endpoint" "primary_s3" {
  vpc_id            = var.vpc_id["primary"]
  service_name      = "com.amazonaws.${data.aws_region.primary.name}.s3"
  route_table_ids   = [var.private_route_table_ids["primary"]]
  vpc_endpoint_type = "Gateway"
  tags = {
    Name        = "s3-endpoint-primary"
    
  }
}

resource "aws_vpc_endpoint" "standby_s3" {
  provider          = aws.standby_region_aws
  vpc_id            = var.vpc_id["standby"]
  service_name      = "com.amazonaws.${data.aws_region.standby.name}.s3"
  route_table_ids   = [var.private_route_table_ids["standby"]]
  vpc_endpoint_type = "Gateway"
  tags = {
    Name        = "s3-endpoint-standby"
    
  }
}
