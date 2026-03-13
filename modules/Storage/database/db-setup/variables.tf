variable "project_name" {
  type        = string
  description = "Project name for SSM paths"
}
variable "primary_region_aws" {
  description = "Enter the AWS region for the primary region"
  type        = string
}

variable "standby_region_aws" {
  description = "Enter the AWS region for the standby region"
  type        = string
}
# variable "db_config" {
#   description = "Configuration object for RDS instances"
#   type = object({
#     instance_name        = string
#     engine               = string
#     engine_version       = string
#     instance_class       = string
#     allocated_storage    = number
#     max_storage          = number
#     storage_type         = string
#     db_name              = string
#     username             = string
#     password             = string
#     parameter_group_name = string
#     enable_multi_az      = bool
#   })
# }
variable "db_params" {
  description = "Complete RDS configuration object"
  type = object({
    project_name         = string
    instance_name        = string
    engine               = string
    engine_version       = string
    instance_class       = string
    allocated_storage    = number
    max_storage          = number
    storage_type         = string
    db_name              = string
    username             = string    
    parameter_group_name = string
    enable_multi_az      = bool

  })
}

variable "primary_db_subnet_group_name" {
  type = string
}

variable "standby_db_subnet_group_name" {
  type = string
}