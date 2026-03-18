variable "project_name" {
  description = "Project name used for SSM paths and tags"
  type        = string
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "primary_region_aws" {
  description = "Primary AWS region used for provider and SSM lookups"
  type        = string
}

variable "domain_name" {
  description = "Root public domain managed by Route53"
  type        = string
}

variable "app_record_name" {
  description = "Subdomain label for the application record"
  type        = string
  default     = "app"
}

variable "db_record_name" {
  description = "Subdomain label for the database record"
  type        = string
  default     = "db"
}

variable "db_record_ttl" {
  description = "TTL for the database CNAME record"
  type        = number
  default     = 60
}

variable "app_record_ttl" {
  description = "TTL for the application CNAME record"
  type        = number
  default     = 60
}

variable "additional_tags" {
  description = "Additional AWS tags to apply on top of the default tag set"
  type        = map(string)
  default     = {}
}
