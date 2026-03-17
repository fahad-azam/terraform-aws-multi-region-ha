resource "aws_security_group" "primary_application" {
  name        = "${var.project_name}-${var.environment}-primary-app-sg"
  description = "Application security group for the primary region"
  vpc_id      = data.aws_ssm_parameter.primary_vpc_id.value
}

resource "aws_vpc_security_group_ingress_rule" "primary_application_from_alb" {
  security_group_id            = aws_security_group.primary_application.id
  referenced_security_group_id = data.aws_ssm_parameter.primary_public_sg_id.value
  from_port                    = local.application_port
  to_port                      = local.application_port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "primary_application_outbound" {
  security_group_id = aws_security_group.primary_application.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "primary_database_from_app" {
  security_group_id            = data.aws_ssm_parameter.primary_private_sg_id.value
  referenced_security_group_id = aws_security_group.primary_application.id
  from_port                    = tonumber(data.aws_ssm_parameter.primary_db_port.value)
  to_port                      = tonumber(data.aws_ssm_parameter.primary_db_port.value)
  ip_protocol                  = "tcp"
}

resource "aws_launch_template" "primary_application" {
  name_prefix   = "${var.project_name}-${var.environment}-primary-app-"
  image_id      = data.aws_ssm_parameter.al2023_primary.value
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.primary_application.id]

  iam_instance_profile {
    name = data.aws_ssm_parameter.primary_application_instance_profile_name.value
  }

  user_data = base64gzip(templatefile("${path.module}/templates/user_data.sh.tftpl", {
    application_port  = local.application_port
    db_endpoint       = trimsuffix(data.aws_ssm_parameter.primary_db_endpoint.value, ":${data.aws_ssm_parameter.primary_db_port.value}")
    db_port           = data.aws_ssm_parameter.primary_db_port.value
    environment       = var.environment
    health_check_path = var.health_check_path
    project_name      = var.project_name
    region_label      = "primary"
  }))

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.common_tags, {
      Name = "${var.project_name}-${var.environment}-primary-app"
    })
  }
}

resource "aws_autoscaling_group" "primary_application" {
  name                = "${var.project_name}-${var.environment}-primary-app-asg"
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = local.primary_public_subnet_ids
  target_group_arns   = [data.aws_ssm_parameter.primary_target_group_arn.value]
  health_check_type   = "ELB"

  launch_template {
    id      = aws_launch_template.primary_application.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-primary-app"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "standby_application" {
  provider    = aws.standby_region_aws
  name        = "${var.project_name}-${var.environment}-standby-app-sg"
  description = "Application security group for the standby region"
  vpc_id      = data.aws_ssm_parameter.standby_vpc_id.value
}

resource "aws_vpc_security_group_ingress_rule" "standby_application_from_alb" {
  provider                     = aws.standby_region_aws
  security_group_id            = aws_security_group.standby_application.id
  referenced_security_group_id = data.aws_ssm_parameter.standby_public_sg_id.value
  from_port                    = local.application_port
  to_port                      = local.application_port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "standby_application_outbound" {
  provider          = aws.standby_region_aws
  security_group_id = aws_security_group.standby_application.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "standby_database_from_app" {
  provider                     = aws.standby_region_aws
  security_group_id            = data.aws_ssm_parameter.standby_private_sg_id.value
  referenced_security_group_id = aws_security_group.standby_application.id
  from_port                    = tonumber(data.aws_ssm_parameter.standby_db_port.value)
  to_port                      = tonumber(data.aws_ssm_parameter.standby_db_port.value)
  ip_protocol                  = "tcp"
}

resource "aws_launch_template" "standby_application" {
  provider      = aws.standby_region_aws
  name_prefix   = "${var.project_name}-${var.environment}-standby-app-"
  image_id      = data.aws_ssm_parameter.al2023_standby.value
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.standby_application.id]

  iam_instance_profile {
    name = data.aws_ssm_parameter.standby_application_instance_profile_name.value
  }

  user_data = base64encode(templatefile("${path.module}/templates/user_data.sh.tftpl", {
    application_port  = local.application_port
    db_endpoint       = trimsuffix(data.aws_ssm_parameter.standby_db_endpoint.value, ":${data.aws_ssm_parameter.standby_db_port.value}")
    db_port           = data.aws_ssm_parameter.standby_db_port.value
    environment       = var.environment
    health_check_path = var.health_check_path
    project_name      = var.project_name
    region_label      = "standby"
  }))

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.common_tags, {
      Name = "${var.project_name}-${var.environment}-standby-app"
    })
  }
}

resource "aws_autoscaling_group" "standby_application" {
  provider            = aws.standby_region_aws
  name                = "${var.project_name}-${var.environment}-standby-app-asg"
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = local.standby_public_subnet_ids
  target_group_arns   = [data.aws_ssm_parameter.standby_target_group_arn.value]
  health_check_type   = "ELB"

  launch_template {
    id      = aws_launch_template.standby_application.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-standby-app"
    propagate_at_launch = true
  }
}
