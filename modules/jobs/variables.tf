variable "project_name" {
  description = "Project name used for job resources"
  type        = string
}

variable "environment" {
  description = "Normalized deployment environment"
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
}

variable "app_readiness_path" {
  description = "Application readiness endpoint path"
  type        = string
}

variable "common_tags" {
  description = "Common tags for jobs resources"
  type        = map(string)
}
