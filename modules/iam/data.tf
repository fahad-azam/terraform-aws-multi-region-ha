data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_ssm_parameter" "primary_artifact_bucket_arn" {
  name = "/${var.project_name}/${var.environment}/storage/primary/artifact_bucket_arn"
}

data "aws_ssm_parameter" "standby_artifact_bucket_arn" {
  name = "/${var.project_name}/${var.environment}/storage/standby/artifact_bucket_arn"
}

data "aws_ssm_parameter" "primary_data_bucket_arn" {
  name = "/${var.project_name}/${var.environment}/storage/primary/data_bucket_arn"
}

data "aws_ssm_parameter" "standby_data_bucket_arn" {
  name = "/${var.project_name}/${var.environment}/storage/standby/data_bucket_arn"
}

data "aws_iam_policy_document" "primary_application_storage" {
  statement {
    sid       = "ListArtifactBucket"
    actions   = ["s3:ListBucket"]
    resources = [data.aws_ssm_parameter.primary_artifact_bucket_arn.value]
  }

  statement {
    sid = "ReadArtifactObjects"
    actions = [
      "s3:GetObject",
    ]
    resources = ["${data.aws_ssm_parameter.primary_artifact_bucket_arn.value}/*"]
  }

  statement {
    sid       = "ListDataBucket"
    actions   = ["s3:ListBucket"]
    resources = [data.aws_ssm_parameter.primary_data_bucket_arn.value]
  }

  statement {
    sid = "UseDataObjects"
    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:PutObject",
    ]
    resources = ["${data.aws_ssm_parameter.primary_data_bucket_arn.value}/*"]
  }
}

data "aws_iam_policy_document" "standby_application_storage" {
  statement {
    sid       = "ListArtifactBucket"
    actions   = ["s3:ListBucket"]
    resources = [data.aws_ssm_parameter.standby_artifact_bucket_arn.value]
  }

  statement {
    sid = "ReadArtifactObjects"
    actions = [
      "s3:GetObject",
    ]
    resources = ["${data.aws_ssm_parameter.standby_artifact_bucket_arn.value}/*"]
  }

  statement {
    sid       = "ListDataBucket"
    actions   = ["s3:ListBucket"]
    resources = [data.aws_ssm_parameter.standby_data_bucket_arn.value]
  }

  statement {
    sid = "UseDataObjects"
    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:PutObject",
    ]
    resources = ["${data.aws_ssm_parameter.standby_data_bucket_arn.value}/*"]
  }
}
