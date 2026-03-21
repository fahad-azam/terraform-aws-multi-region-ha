locals {
  name_prefix            = "${var.project_name}-${var.environment}-${data.aws_caller_identity.current.account_id}"
  app_artifact_key       = var.application_artifact_key
  app_artifact_file_path = "${path.module}/artifacts/${var.application_artifact_filename}"
}
