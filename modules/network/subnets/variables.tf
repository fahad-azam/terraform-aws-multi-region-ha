variable "vpc_id" {
  type        = map(string)
  description = "Map containing VPC IDs for both regions"

  validation {
    condition     = alltrue([for k in ["primary", "standby"] : contains(keys(var.vpc_id), k)])
    error_message = "vpc_id must include both required keys: \"primary\" and \"standby\"."
  }
}

variable "project_name" {
  description = "Project name used for subnet names"
  type        = string
  
}
variable "environment" {
  description = "Normalized deployment environment used for subnet names"
  type        = string
  
}

variable "standby_vpc_cidr" {
  description = "Provide Cidr for the VPC in standby region"
  type        = string
}

variable "primary_vpc_cidr" {
  description = "Provide cidr for the VPC in primary region"
  type        = string
}

variable "project_name" {
  description = "Project name used for subnet names"
  type        = string
}

variable "environment" {
  description = "Normalized deployment environment used for subnet names"
  type        = string
}
