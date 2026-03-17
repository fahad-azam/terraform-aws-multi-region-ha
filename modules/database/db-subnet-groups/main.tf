resource "aws_db_subnet_group" "primary" {
  name = "${var.project_name}-primary-db-group"
  # Filter the data source map for keys starting with "primary."
  subnet_ids = [
    for k, v in data.aws_ssm_parameter.db_subnets : v.value
    if startswith(k, "primary.")
  ]

  tags = { Name = "${var.project_name}-primary-db-group" }
}

resource "aws_db_subnet_group" "standby" {
  provider = aws.standby_region_aws
  name     = "${var.project_name}-standby-db-group"
  # Filter the data source map for keys starting with "standby."
  subnet_ids = [
    for k, v in data.aws_ssm_parameter.db_subnets : v.value
    if startswith(k, "standby.")
  ]

  tags = { Name = "${var.project_name}-standby-db-group" }
}