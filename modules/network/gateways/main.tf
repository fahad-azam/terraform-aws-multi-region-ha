resource "aws_internet_gateway" "igw_primary" {

  vpc_id = var.vpc_id["primary"]
  tags = {
    Name = "igw-primary"
  }

}
resource "aws_internet_gateway" "igw_standby" {
  provider = aws.standby_region_aws
  vpc_id   = var.vpc_id["standby"]
  tags = {
    Name = "igw-standby"
  }

}
