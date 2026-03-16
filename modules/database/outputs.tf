output "primary_db_subnet_group_name" {
  description = "The ID of the primary region DB subnet group"
  value       = module.db_subnet_groups.primary_db_subnet_group_name
}

output "primary_db_subnet_group_arn" {
  description = "The ARN of the primary region DB subnet group"
  value       = module.db_subnet_groups.primary_db_subnet_group_arn
}

output "standby_db_subnet_group_name" {
  description = "The ID of the standby region DB subnet group"
  value       = module.db_subnet_groups.standby_db_subnet_group_name
}

output "standby_db_subnet_group_arn" {
  description = "The ARN of the standby region DB subnet group"
  value       = module.db_subnet_groups.standby_db_subnet_group_arn
}

# output "primary_subnet_ids_used" {
#   description = "The specific subnet IDs filtered for the primary group"
#   value       = module.db_subnet_groups.primary_db_subnet_group.subnet_ids
# }

# output "standby_subnet_ids_used" {
#   description = "The specific subnet IDs filtered for the standby group"
#   value       = module.db_subnet_groups.standby_db_subnet_group.subnet_ids
# }
output "primary_db_instance_id" {
  description = "Identifier of the primary RDS instance"
  value       = module.db-setup.primary_db_instance_id
}

output "primary_db_instance_arn" {
  description = "ARN of the primary RDS instance"
  value       = module.db-setup.primary_db_instance_arn
}

output "primary_db_endpoint" {
  description = "Connection endpoint of the primary RDS instance"
  value       = module.db-setup.primary_db_endpoint
}

output "primary_db_port" {
  description = "Port of the primary RDS instance"
  value       = module.db-setup.primary_db_port
}

output "standby_db_instance_id" {
  description = "Identifier of the standby RDS instance"
  value       = module.db-setup.standby_db_instance_id
}

output "standby_db_instance_arn" {
  description = "ARN of the standby RDS instance"
  value       = module.db-setup.standby_db_instance_arn
}

output "standby_db_endpoint" {
  description = "Connection endpoint of the standby RDS instance"
  value       = module.db-setup.standby_db_endpoint
}

output "standby_db_port" {
  description = "Port of the standby RDS instance"
  value       = module.db-setup.standby_db_port
}











