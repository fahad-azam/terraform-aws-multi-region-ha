variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Normalized deployment environment"
  type        = string
}

variable "common_tags" {
  description = "Common tags shared by IAM resources"
  type        = map(string)
}
