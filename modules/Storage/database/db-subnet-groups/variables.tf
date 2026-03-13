variable "project_name" {
  description = "Enter project name to be used as prefix for all resources"
  type        = string
}

variable "primary_region_aws" {
  description = "Enter the AWS region for the primary region"
  type        = string
}

variable "standby_region_aws" {
  description = "Enter the AWS region for the standby region"
  type        = string
}
