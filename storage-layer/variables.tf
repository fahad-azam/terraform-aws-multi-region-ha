variable "primary_region_aws" {
    description = "Primary Region to deploy active instaces"
    type = string
}

variable "standby_region_aws" {
    description = "Standby Region to deploy passive instances"
    type = string
}