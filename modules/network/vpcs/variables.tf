variable "primary_vpc_name" {
    description = "Provide name for the VPC in primary region"
    type = string
}

variable "primary_vpc_cidr" {
    description = "Provide cidr for the VPC in primary region"
    type = string
}

variable "standby_vpc_name" {
    description = "Provide name for the VPC in secondary region"
    type = string
}

variable "standby_vpc_cidr" {
    description = "Provide Cidr for the VPC in standby region"
    type = string
}
