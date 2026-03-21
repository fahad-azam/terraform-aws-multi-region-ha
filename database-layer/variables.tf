variable "project_name" {
  description = "Enter project name to be used as prefix for all resources"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+(?:-[a-z0-9]+)*$", var.project_name))
    error_message = "project_name must use only lowercase letters, numbers, and hyphens."
  }
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
  })
  # Validation for Instance Name
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]*$", var.db_params.instance_name))
    error_message = "The instance_name must start with a letter and contain only lowercase alphanumeric characters or hyphens."
  }

  # Validation for Engine type
  validation {
    condition     = contains(["mysql", "postgres", "mariadb"], var.db_params.engine)
    error_message = "Supported engines are mysql, postgres, or mariadb."
  }

  # Validation for Storage
  validation {
    condition     = var.db_params.max_storage >= var.db_params.allocated_storage
    error_message = "Max storage must be greater than or equal to allocated storage."
  }


}

variable "enable_multi_az" {
  description = "Enable Multi-AZ deployment for the primary RDS instance"
  type        = bool
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string

}
