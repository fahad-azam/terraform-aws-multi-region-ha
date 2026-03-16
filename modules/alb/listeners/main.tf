resource "aws_lb_listener" "primary" {

  load_balancer_arn = var.primary_lb_arn

  port     = var.listener_config.port
  protocol = var.listener_config.protocol

  default_action {
    type             = "forward"
    target_group_arn = var.primary_tg_arn
  }
}
resource "aws_lb_listener" "standby" {
  provider          = aws.standby_region_aws
  load_balancer_arn = var.standby_lb_arn

  port     = var.listener_config.port
  protocol = var.listener_config.protocol

  default_action {
    type             = "forward"
    target_group_arn = var.standby_tg_arn
  }
}