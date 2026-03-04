variable "vpc_id" {
  type        = map(string)
  description = "Map containing VPC IDs for both regions"
}

variable "primary_sg_name" {
  description = "Security group name in the primary region"
  type        = string
  default     = "primary-public-sg"
}

variable "standby_sg_name" {
  description = "Security group name in the standby region"
  type        = string
  default     = "standby-public-sg"
}

variable "primary_private_sg_name" {
  description = "Private security group name in the primary region"
  type        = string
  default     = "primary-private-sg"
}

variable "standby_private_sg_name" {
  description = "Private security group name in the standby region"
  type        = string
  default     = "standby-private-sg"
}
