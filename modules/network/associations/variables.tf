variable "primary_vpc_subnet" {
  type = map(object({
    id                      = string
    availability_zone       = string
    cidr_block              = string
    map_public_ip_on_launch = bool
  }))
  description = "Map of subnet objects in the primary region with detailed subnet information"
}

variable "primary_rt_ids" {
  type        = map(string)
  description = "Map of route table IDs in the primary region (keys: 'public', 'private')"

  validation {
    condition     = alltrue([for k in ["public", "private"] : contains(keys(var.primary_rt_ids), k)])
    error_message = "primary_rt_ids must include both required keys: \"public\" and \"private\"."
  }
}

variable "standby_vpc_subnet" {
  type = map(object({
    id                      = string
    availability_zone       = string
    cidr_block              = string
    map_public_ip_on_launch = bool
  }))
  description = "Map of subnet objects in the standby region with detailed subnet information"
}

variable "standby_rt_ids" {
  type        = map(string)
  description = "Map of route table IDs in the standby region (keys: 'public', 'private')"

  validation {
    condition     = alltrue([for k in ["public", "private"] : contains(keys(var.standby_rt_ids), k)])
    error_message = "standby_rt_ids must include both required keys: \"public\" and \"private\"."
  }
}
