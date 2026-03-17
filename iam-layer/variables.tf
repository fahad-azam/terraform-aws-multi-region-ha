variable "project_name" {
  description = "Enter project name to be used as prefix for all resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
}

variable "primary_region_aws" {
  description = "Primary Region to deploy active instances"
  type        = string
}

variable "standby_region_aws" {
  description = "Standby Region to deploy secondary instances"
  type        = string
}

variable "additional_tags" {
  description = "Additional AWS tags to apply on top of the default tag set"
  type        = map(string)
  default     = {}
}
