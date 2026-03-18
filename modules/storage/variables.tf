variable "project_name" {
  description = "Project name used for bucket naming"
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

variable "common_tags" {
  description = "Common tags shared by storage resources"
  type        = map(string)
}
