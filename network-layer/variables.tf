variable "primary_region_aws" {
    description = "Primary Region to deploy active instaces"
    type = string
}
variable "primary_vpc_name" {
    description = "Provide name for the VPC in primary region"
    type = string
}

variable "primary_vpc_cidr" {
    description = "Provide cidr for the VPC in primary region"
    type = string
    validation {
        condition     = can(cidrhost(var.primary_vpc_cidr, 0))
        error_message = "primary_vpc_cidr must be a valid CIDR block (e.g., 10.0.0.0/16)"
    }
}

variable "standby_region_aws" {
    description = "Standby Region to deploy secondary instaces"
    type = string
}

variable "standby_vpc_name" {
    description = "Provide name for the VPC in secondary region"
    type = string
}

variable "standby_vpc_cidr" {
    description = "Provide Cidr for the VPC in standby region"
    type = string
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
    cidrs    = list(string)
  }))
}