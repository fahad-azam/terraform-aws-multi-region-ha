variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment name"
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

variable "additional_tags" {
  description = "Additional AWS tags to apply on top of the default tag set"
  type        = map(string)
  default     = {}
}
