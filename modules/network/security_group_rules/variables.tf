variable "primary_public_sg_id" {
  type        = string
  description = "The ID of the primary public security group"
}

variable "primary_private_sg_id" {
  type        = string
  description = "The ID of the primary private security group"
}

variable "primary_application_sg_id" {
  type        = string
  description = "The ID of the primary application security group"
}

variable "standby_public_sg_id" {
  type        = string
  description = "The ID of the standby public security group"
}

variable "standby_private_sg_id" {
  type        = string
  description = "The ID of the standby private security group"
}

variable "standby_application_sg_id" {
  type        = string
  description = "The ID of the standby application security group"
}

variable "public_inbound_rules" {
  type = map(object({
    from_port = number
    to_port   = number
    protocol  = string
    cidrs     = list(string)
  }))
}

variable "application_port" {
  description = "Port exposed by the application instances"
  type        = number
}
