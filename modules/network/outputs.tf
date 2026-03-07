# File: modules/network/outputs.tf

output "primary_vpc_id" {
  description = "Linear transfer: Passing primary VPC ID from child to root"
  value       = module.vpcs.primary_vpc_id 
}
output "standby_vpc_id" {
  description = "Linear transfer: Passing standby VPC ID from child to root"
  value       = module.vpcs.standby_vpc_id
}
output "primary_vpc_subnet" {
  description = "Structured map of primary subnets bubbled up from child"
  value = module.subnets.primary_vpc_subnet
}
output "standby_vpc_subnet" {
  description = "Structured map of standby subnets bubbled up from child"
  value = module.subnets.standby_vpc_subnet
}
output "primary_public_sg_id" {
  description = "Linear transfer: Passing primary public SG ID from child to root"
  value       = module.security_groups.primary_public_sg_id
}
output "standby_public_sg_id" {
  description = "Linear transfer: Passing standby public SG ID from child to root"
  value       = module.security_groups.standby_public_sg_id
}
output "primary_private_sg_id" {
  description = "Linear transfer: Passing primary private SG ID from child to root"
  value       = module.security_groups.primary_private_sg_id
}
output "standby_private_sg_id" {
  description = "Linear transfer: Passing standby private SG ID from child to root"
  value       = module.security_groups.standby_private_sg_id
}
output "primary_rt_id" {
  description = "Linear transfer: Passing primary route table ID from child to root"
  value       = module.rttables.primary_rt_id
}
output "standby_rt_id" {
  description = "Linear transfer: Passing standby route table ID from child to root"
  value       = module.rttables.standby_rt_id
}
output "primary_igw_id" {
    description = "Linear transfer: Passing primary IGW ID from child to root"
    value       = module.gateways.primary_igw_id
}
output "standby_igw_id" {
    description = "Linear transfer: Passing standby IGW ID from child to root"
    value       = module.gateways.standby_igw_id
} 