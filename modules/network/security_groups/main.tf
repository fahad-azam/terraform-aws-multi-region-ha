resource "aws_security_group" "primary_public_sg" {
  vpc_id      = var.vpc_id["primary"]
  name        = var.primary_sg_name
  description = "Public security group for primary region"

  tags = {
    Name = var.primary_sg_name
  }
}

resource "aws_security_group" "primary_private_sg" {
  vpc_id      = var.vpc_id["primary"]
  name        = var.primary_private_sg_name
  description = "Private security group for primary region"

  tags = {
    Name = var.primary_private_sg_name
  }
}

resource "aws_security_group" "primary_application_sg" {
  vpc_id      = var.vpc_id["primary"]
  name        = var.primary_application_sg_name
  description = "Application security group for primary region"

  tags = {
    Name = var.primary_application_sg_name
  }
}

resource "aws_security_group" "standby_public_sg" {
  provider    = aws.standby_region_aws
  vpc_id      = var.vpc_id["standby"]
  name        = var.standby_sg_name
  description = "Public security group for standby region"

  tags = {
    Name = var.standby_sg_name
  }
}

resource "aws_security_group" "standby_private_sg" {
  provider    = aws.standby_region_aws
  vpc_id      = var.vpc_id["standby"]
  name        = var.standby_private_sg_name
  description = "Private security group for standby region"

  tags = {
    Name = var.standby_private_sg_name
  }
}

resource "aws_security_group" "standby_application_sg" {
  provider    = aws.standby_region_aws
  vpc_id      = var.vpc_id["standby"]
  name        = var.standby_application_sg_name
  description = "Application security group for standby region"

  tags = {
    Name = var.standby_application_sg_name
  }
}
