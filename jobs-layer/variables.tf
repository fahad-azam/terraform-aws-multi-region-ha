variable "project_name" {
  description = "Project name used for job resources"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+(?:-[a-z0-9]+)*$", var.project_name))
    error_message = "project_name must use only lowercase letters, numbers, and hyphens."
  }
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "primary_region_aws" {
  description = "Primary AWS region"
  type        = string
}

variable "standby_region_aws" {
  description = "Standby AWS region"
  type        = string
}

variable "db_port" {
  description = "Database port used by the application"
  type        = number
  default     = 5432
}

variable "app_health_path" {
  description = "Application health endpoint path"
  type        = string
  default     = "/health"
}

variable "additional_tags" {
  description = "Additional tags to apply to job resources"
  type        = map(string)
  default     = {}
}
