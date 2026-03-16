variable "project_name" {
  description = "Enter project name to be used as prefix for all resources"
  type        = string
}
variable "additional_tags" {
  description = "Additional AWS tags to apply on top of the default tag set"
  type        = map(string)
  default     = {}
}

variable "primary_region_aws" {
  description = "Primary Region to deploy active instaces"
  type        = string
}

variable "standby_region_aws" {
  description = "Standby Region to deploy secondary instaces"
  type        = string
}

variable "environment" {
  description = "Normalized deployment environment name"
  type        = string
}

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
