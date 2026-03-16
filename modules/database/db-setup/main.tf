data "vault_generic_secret" "rds_creds" {
  path = "secret/${var.project_name}/${local.environment}/rds"
}

# --- Primary RDS Instance ---
resource "aws_db_instance" "primary" {
  identifier            = "${var.db_params.instance_name}-primary"
  engine                = var.db_params.engine
  engine_version        = var.db_params.engine_version
  instance_class        = var.db_params.instance_class
  allocated_storage     = var.db_params.allocated_storage
  max_allocated_storage = var.db_params.max_storage
  storage_type          = var.db_params.storage_type
  
  db_name               = var.db_params.db_name
  username              = var.db_params.username
  password = data.vault_generic_secret.rds_creds.data["password"]
  parameter_group_name  = var.db_params.parameter_group_name

  # Network & Security
  db_subnet_group_name   = var.primary_db_subnet_group_name
  vpc_security_group_ids = [data.aws_ssm_parameter.db_sgs["primary"].value]
  publicly_accessible    = false

  # High Availability & Backups
  multi_az                = var.db_params.enable_multi_az
  backup_retention_period = 7 # Required for cross-region replicas
  skip_final_snapshot     = true

  tags = {
    Name        = "${var.db_params.instance_name}-primary"
    Environment = "production"
    Project     = var.db_params.project_name
  }
}

# --- Standby RDS Instance (Cross-Region Replica) ---
resource "aws_db_instance" "standby" {
  provider             = aws.standby_region_aws
  identifier           = "${var.db_params.instance_name}-standby"
  replicate_source_db  = aws_db_instance.primary.arn
  instance_class       = var.db_params.instance_class
  
  # Network & Security
  db_subnet_group_name   = var.standby_db_subnet_group_name
  vpc_security_group_ids = [data.aws_ssm_parameter.db_sgs["standby"].value]
  
  parameter_group_name = var.db_params.parameter_group_name
  skip_final_snapshot  = true

  tags = {
    Name        = "${var.db_params.instance_name}-standby"
    Environment = "production"
    Project     = var.db_params.project_name
  }
}