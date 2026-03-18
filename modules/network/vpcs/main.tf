resource "aws_vpc" "primary_vpc" {
  cidr_block           = var.primary_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.primary_vpc_name
  }
}

resource "aws_vpc" "standby_vpc" {
  provider             = aws.standby_region_aws
  cidr_block           = var.standby_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.standby_vpc_name
  }
} 
