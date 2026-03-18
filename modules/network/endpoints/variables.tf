variable "vpc_id" {
  description = "VPC IDs keyed by region role"
  type        = map(string)
}

variable "private_route_table_ids" {
  description = "Private route table IDs keyed by region role"
  type        = map(string)
}
