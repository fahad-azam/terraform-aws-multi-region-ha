variable "project_name" {
  description = "Project name used for SSM discovery and resource naming"
  type        = string
}

variable "environment" {
  description = "Normalized deployment environment"
  type        = string
}

variable "primary_region_aws" {
  description = "Primary AWS region for the application stack"
  type        = string
}

variable "standby_region_aws" {
  description = "Standby AWS region for the application stack"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the demo app"
  type        = string
}

variable "desired_capacity" {
  description = "Desired instance count per region"
  type        = number
}

variable "min_size" {
  description = "Minimum instance count per region"
  type        = number
}

variable "max_size" {
  description = "Maximum instance count per region"
  type        = number
}

variable "health_check_path" {
  description = "Health check path served by the demo app"
  type        = string
}

variable "common_tags" {
  description = "Common tags shared by application resources"
  type        = map(string)
}
