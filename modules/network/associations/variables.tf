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
}