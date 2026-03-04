resource "aws_security_group" "primary_public_sg" {
  vpc_id     = var.vpc_id["primary"]
  name       = var.primary_sg_name
  description = "Public security group for primary region"
}
resource "aws_security_group" "primary_private_sg" {
  vpc_id     = var.vpc_id["primary"]
  name       = var.primary_private_sg_name
  description = "Private security group for primary region"
  
}

resource "aws_security_group" "standby_public_sg" {
  provider   = aws.standby_region_aws
  vpc_id     = var.vpc_id["standby"]
  name       = var.standby_sg_name
  description = "Public security group for standby region"
}
resource "aws_security_group" "standby_private_sg" {
  provider   = aws.standby_region_aws
  vpc_id     = var.vpc_id["standby"]
  name       = var.standby_private_sg_name
  description = "Private security group for standby region"
}