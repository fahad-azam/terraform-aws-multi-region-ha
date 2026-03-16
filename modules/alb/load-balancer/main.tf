resource "aws_lb" "primary_alb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  
  security_groups    = local.primary_public_sgs
  subnets            = local.primary_public_subnets

  tags = merge(var.common_tags, { Name = "${var.project_name}-alb" })
}

resource "aws_lb" "standby_alb" {
  provider           = aws.standby_region_aws
  name               = "${var.project_name}-standby-alb"
  internal           = false
  load_balancer_type = "application"
  
  security_groups    = local.standby_public_sgs
  subnets            = local.standby_public_subnets

  tags = merge(var.common_tags, { Name = "${var.project_name}-standby-alb" })
}