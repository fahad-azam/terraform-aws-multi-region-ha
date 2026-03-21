variable "project_name" {
  description = "Project name used for bucket naming"
  type        = string
}

variable "environment" {
  description = "Normalized deployment environment"
  type        = string
}

variable "primary_region_aws" {
  description = "Primary AWS region"
  type        = string
}

variable "standby_region_aws" {
  description = "Standby AWS region"
  type        = string
}

variable "common_tags" {
  description = "Common tags shared by storage resources"
  type        = map(string)
}

variable "application_artifact_key" {
  description = "Object key used to store the application artifact in S3"
  type        = string
}

variable "application_artifact_filename" {
  description = "Artifact filename located under this module's artifacts directory"
  type        = string
}
