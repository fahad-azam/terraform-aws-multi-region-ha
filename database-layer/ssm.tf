# --- Primary RDS SSM Parameters ---
resource "aws_ssm_parameter" "primary_db_id" {
  name  = "/${var.project_name}/${local.environment}/rds/primary/instance_id"
  type  = "String"
  value = module.database.primary_db_instance_id
  tags  = { Name = "primary-db-instance-id", Environment = local.environment }
}

resource "aws_ssm_parameter" "primary_db_arn" {
  name  = "/${var.project_name}/${local.environment}/rds/primary/arn"
  type  = "String"
  value = module.database.primary_db_instance_arn
  tags  = { Name = "primary-db-arn", Environment = local.environment }
}

resource "aws_ssm_parameter" "primary_db_endpoint" {
  name  = "/${var.project_name}/${local.environment}/rds/primary/endpoint"
  type  = "String"
  value = module.database.primary_db_endpoint
  tags  = { Name = "primary-db-endpoint", Environment = local.environment }
}

resource "aws_ssm_parameter" "primary_db_port" {
  name  = "/${var.project_name}/${local.environment}/rds/primary/port"
  type  = "String"
  value = module.database.primary_db_port
  tags  = { Name = "primary-db-port", Environment = local.environment }
}

# --- Standby RDS SSM Parameters ---
resource "aws_ssm_parameter" "standby_db_id" {
  
  name     = "/${var.project_name}/${local.environment}/rds/standby/instance_id"
  type     = "String"
  value    = module.database.standby_db_instance_id
  tags     = { Name = "standby-db-instance-id", Environment = local.environment }
}

resource "aws_ssm_parameter" "standby_db_arn" {
 
  name     = "/${var.project_name}/${local.environment}/rds/standby/arn"
  type     = "String"
  value    = module.database.standby_db_instance_arn
  tags     = { Name = "standby-db-arn", Environment = local.environment }
}

resource "aws_ssm_parameter" "standby_db_endpoint" {
  
  name     = "/${var.project_name}/${local.environment}/rds/standby/endpoint"
  type     = "String"
  value    = module.database.standby_db_endpoint
  tags     = { Name = "standby-db-endpoint", Environment = local.environment }
}

resource "aws_ssm_parameter" "standby_db_port" {
  
  name     = "/${var.project_name}/${local.environment}/rds/standby/port"
  type     = "String"
  value    = module.database.standby_db_port
  tags     = { Name = "standby-db-port", Environment = local.environment }
}
