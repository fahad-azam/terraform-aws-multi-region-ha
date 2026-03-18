variable "project_name" {
  description = "Project name used for naming and tags"
  type        = string
}

variable "environment" {
  description = "Normalized deployment environment"
  type        = string
}

variable "vpc_ids" {
  description = "Map of VPC IDs for primary and standby regions"
  type        = map(string)
}

variable "vpc_cidrs" {
  description = "Map of VPC CIDR blocks for primary and standby regions"
  type        = map(string)
}

variable "route_table_ids" {
  description = "Map of private route table IDs for primary and standby regions"
  type        = map(string)
}

variable "standby_region_aws" {
  description = "Standby AWS region"
  type        = string
}
