data "aws_ssm_parameters_by_path" "primary" {
  path      = "${local.ssm_base}/primary"
  recursive = true
}
data "aws_ssm_parameters_by_path" "standby" {
  path      = "${local.ssm_base}/standby"
  recursive = true
}