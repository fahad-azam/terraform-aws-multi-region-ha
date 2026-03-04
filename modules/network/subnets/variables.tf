variable "vpc_id" {
  type        = map(string)
  description = "Map containing VPC IDs for both regions"
}


variable "standby_vpc_cidr" {
    description = "Provide Cidr for the VPC in standby region"
    type = string
}
variable "primary_vpc_cidr" {
    description = "Provide cidr for the VPC in primary region"
    type = string
}