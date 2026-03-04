variable "primary_rt_ids" {
  type        = map(string)
  description = "Map of route table IDs in the primary region (keys: 'public', 'private')"
}

variable "standby_rt_ids" {
  type        = map(string)
  description = "Map of route table IDs in the standby region (keys: 'public', 'private')"
}

variable "aws_primary_internet_gateway_id" {
  type        = string
  description = "Internet Gateway ID for the primary region"
}
variable "aws_standby_internet_gateway_id" {
  type        = string
  description = "Internet Gateway ID for the standby region"
}