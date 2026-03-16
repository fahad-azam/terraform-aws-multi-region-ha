variable "listener_config" {
  type = object({
    port     = number
    protocol = string
  })
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "primary_lb_arn" {
  type = string
}

variable "standby_lb_arn" {
  type = string
}

variable "primary_tg_arn" {
  type = string
}

variable "standby_tg_arn" {
  type = string
}