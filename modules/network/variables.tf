variable "project_name" {
  description = "Project name used for naming and tags"
  type        = string
}

variable "environment" {
  description = "Normalized deployment environment"
  type        = string
}

variable "standby_region_aws" {
  description = "Standby AWS region"
  type        = string
}

variable "primary_vpc_name" {
  description = "Provide name for the VPC in primary region"
  type        = string
}

variable "primary_vpc_cidr" {
  description = "Provide cidr for the VPC in primary region"
  type        = string
  validation {
    condition     = can(cidrhost(var.primary_vpc_cidr, 0))
    error_message = "primary_vpc_cidr must be a valid CIDR block (e.g., 10.0.0.0/16)"
  }
}

variable "standby_vpc_name" {
  description = "Provide name for the VPC in secondary region"
  type        = string
}

variable "standby_vpc_cidr" {
  description = "Provide Cidr for the VPC in standby region"
  type        = string
  validation {
    condition     = can(cidrhost(var.standby_vpc_cidr, 0))
    error_message = "standby_vpc_cidr must be a valid CIDR block (e.g., 192.168.0.0/16)"
  }
}
variable "public_inbound_rules" {
  type = map(object({
    from_port = number
    to_port   = number
    protocol  = string
    cidrs     = list(string)
  }))
}

variable "application_port" {
  description = "Port exposed by the application instances behind the load balancer"
  type        = number
  default     = 80
}

variable "nat_instance_type" {
  description = "Instance type for the lightweight NAT instances in each region"
  type        = string
  default     = "t3.nano"
}

variable "database_port" {
  description = "Database port to allow for cross-region application-to-DB access"
  type        = number
}
