variable "primary_rt_ids" {
  type        = map(string)
  description = "Map of route table IDs in the primary region (keys: 'public', 'private')"

  validation {
    condition     = alltrue([for k in ["public", "private"] : contains(keys(var.primary_rt_ids), k)])
    error_message = "primary_rt_ids must include both required keys: \"public\" and \"private\"."
  }
}

variable "standby_rt_ids" {
  type        = map(string)
  description = "Map of route table IDs in the standby region (keys: 'public', 'private')"

  validation {
    condition     = alltrue([for k in ["public", "private"] : contains(keys(var.standby_rt_ids), k)])
    error_message = "standby_rt_ids must include both required keys: \"public\" and \"private\"."
  }
}

variable "aws_primary_internet_gateway_id" {
  type        = string
  description = "Internet Gateway ID for the primary region"
}
variable "aws_standby_internet_gateway_id" {
  type        = string
  description = "Internet Gateway ID for the standby region"
}

variable "primary_nat_network_interface_id" {
  type        = string
  description = "Primary network interface ID for the primary NAT instance"
}

variable "standby_nat_network_interface_id" {
  type        = string
  description = "Primary network interface ID for the standby NAT instance"
}
