locals {
  name_prefix            = "${var.project_name}-${var.environment}-${data.aws_caller_identity.current.account_id}"
  app_artifact_key       = "applications/resume-portal/app.py"
  app_artifact_file_path = "${path.module}/artifacts/resume_portal.py"
}
