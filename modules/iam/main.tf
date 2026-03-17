resource "aws_iam_role" "primary_application" {
  name               = "${var.project_name}-${var.environment}-primary-app-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-primary-app-role"
  })
}

resource "aws_iam_role_policy_attachment" "primary_ssm_managed_core" {
  role       = aws_iam_role.primary_application.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "primary_application" {
  name = "${var.project_name}-${var.environment}-primary-app-profile"
  role = aws_iam_role.primary_application.name

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-primary-app-profile"
  })
}

resource "aws_iam_role" "standby_application" {
  name               = "${var.project_name}-${var.environment}-standby-app-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-standby-app-role"
  })
}

resource "aws_iam_role_policy_attachment" "standby_ssm_managed_core" {
  role       = aws_iam_role.standby_application.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "standby_application" {
  name = "${var.project_name}-${var.environment}-standby-app-profile"
  role = aws_iam_role.standby_application.name

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-standby-app-profile"
  })
}
