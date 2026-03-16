variable "project_name" {
  description = "The name of the project. This will be used as a prefix for all resources created by this module."
  type        = string
}
variable "environment" {
  description = "The environment for which the resources are being created (e.g., dev, staging, prod). This will be used as a suffix for all resources created by this module."
  type        = string
}

variable "target_group_config" {
  type = object({
    port        = number
    protocol    = string
    target_type = string

    health_check = object({
      path                = string
      interval            = number
      timeout             = number
      healthy_threshold   = number
      unhealthy_threshold = number
    })
  })
}
variable "common_tags" {
  description = "A map of common tags to apply to all resources created by this module."
  type        = map(string)
}
variable "listener_config" {
  type = object({
    port     = number
    protocol = string
  })
}
