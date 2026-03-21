variable "project_name" {
  description = "Enter project name to be used as prefix for all resources"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+(?:-[a-z0-9]+)*$", var.project_name))
    error_message = "project_name must use only lowercase letters, numbers, and hyphens."
  }
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

variable "instance_type" {
  description = "EC2 instance type for the demo application servers"
  type        = string
  default     = "t3.micro"
}

variable "desired_capacity" {
  description = "Desired number of application instances per region"
  type        = number
  default     = 1
}

variable "min_size" {
  description = "Minimum number of application instances per region"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of application instances per region"
  type        = number
  default     = 2
}

variable "health_check_path" {
  description = "Application health check path used by the demo app"
  type        = string
  default     = "/health"
}
