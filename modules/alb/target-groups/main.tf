resource "aws_lb_target_group" "primary" {

  name = "${var.project_name}-tg"

  vpc_id = local.primary_vpc_id

  port        = var.target_group_config.port
  protocol    = var.target_group_config.protocol
  target_type = var.target_group_config.target_type

  health_check {
    path                = var.target_group_config.health_check.path
    interval            = var.target_group_config.health_check.interval
    timeout             = var.target_group_config.health_check.timeout
    healthy_threshold   = var.target_group_config.health_check.healthy_threshold
    unhealthy_threshold = var.target_group_config.health_check.unhealthy_threshold
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-tg"
    }
  )
}
resource "aws_lb_target_group" "standby" {
  provider = aws.standby_region_aws
  name     = "${var.project_name}-standby-tg"

  vpc_id = local.standby_vpc_id

  port        = var.target_group_config.port
  protocol    = var.target_group_config.protocol
  target_type = var.target_group_config.target_type

  health_check {
    path                = var.target_group_config.health_check.path
    interval            = var.target_group_config.health_check.interval
    timeout             = var.target_group_config.health_check.timeout
    healthy_threshold   = var.target_group_config.health_check.healthy_threshold
    unhealthy_threshold = var.target_group_config.health_check.unhealthy_threshold
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-standby-tg"
    }
  )
}
