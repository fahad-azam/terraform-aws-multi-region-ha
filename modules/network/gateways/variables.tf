variable "vpc_id" {
  type        = map(string)
  description = "Map containing VPC IDs for both regions"

  validation {
    condition     = alltrue([for k in ["primary", "standby"] : contains(keys(var.vpc_id), k)])
    error_message = "vpc_id must include both required keys: \"primary\" and \"standby\"."
  }
}

variable "vpc_cidrs" {
  type        = map(string)
  description = "Map containing VPC CIDR blocks for both regions"

  validation {
    condition     = alltrue([for k in ["primary", "standby"] : contains(keys(var.vpc_cidrs), k)])
    error_message = "vpc_cidrs must include both required keys: \"primary\" and \"standby\"."
  }
}

variable "public_subnet_ids" {
  type        = map(string)
  description = "Map containing public subnet IDs used to host NAT instances in both regions"

  validation {
    condition     = alltrue([for k in ["primary", "standby"] : contains(keys(var.public_subnet_ids), k)])
    error_message = "public_subnet_ids must include both required keys: \"primary\" and \"standby\"."
  }
}

variable "nat_instance_type" {
  description = "Instance type for the NAT instance deployed in each region"
  type        = string
}

