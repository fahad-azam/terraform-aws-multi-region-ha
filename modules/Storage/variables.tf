variable "project_name" {
  description = "Enter project name to be used as prefix for all resources"
  type        = string
}
variable "additional_tags" {
  description = "Additional AWS tags to apply on top of the default tag set"
  type        = map(string)
  default     = {}
}

variable "primary_region_aws" {
  description = "Primary Region to deploy active instaces"
  type        = string
}

variable "standby_region_aws" {
  description = "Standby Region to deploy secondary instaces"
  type        = string
}
