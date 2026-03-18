resource "aws_launch_template" "primary_application" {
  name_prefix   = "${var.project_name}-${var.environment}-primary-app-"
  image_id      = data.aws_ssm_parameter.al2023_primary.value
  instance_type = var.instance_type

  vpc_security_group_ids = [data.aws_ssm_parameter.primary_application_sg_id.value]

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
  vpc_zone_identifier = local.primary_private_app_subnet_ids
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

resource "aws_launch_template" "standby_application" {
  provider      = aws.standby_region_aws
  name_prefix   = "${var.project_name}-${var.environment}-standby-app-"
  image_id      = data.aws_ssm_parameter.al2023_standby.value
  instance_type = var.instance_type

  vpc_security_group_ids = [data.aws_ssm_parameter.standby_application_sg_id.value]

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
  vpc_zone_identifier = local.standby_private_app_subnet_ids
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
