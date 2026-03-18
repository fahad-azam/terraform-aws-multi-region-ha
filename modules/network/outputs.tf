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
  value       = module.subnets.primary_vpc_subnet
}
output "standby_vpc_subnet" {
  description = "Structured map of standby subnets bubbled up from child"
  value       = module.subnets.standby_vpc_subnet
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

output "primary_application_sg_id" {
  description = "Linear transfer: Passing primary application SG ID from child to root"
  value       = module.security_groups.primary_application_sg_id
}

output "standby_private_sg_id" {
  description = "Linear transfer: Passing standby private SG ID from child to root"
  value       = module.security_groups.standby_private_sg_id
}

output "standby_application_sg_id" {
  description = "Linear transfer: Passing standby application SG ID from child to root"
  value       = module.security_groups.standby_application_sg_id
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

output "primary_nat_instance_id" {
  description = "Linear transfer: Passing primary NAT instance ID from child to root"
  value       = module.gateways.primary_nat_instance_id
}

output "standby_nat_instance_id" {
  description = "Linear transfer: Passing standby NAT instance ID from child to root"
  value       = module.gateways.standby_nat_instance_id
}

output "primary_nat_network_interface_id" {
  description = "Linear transfer: Passing primary NAT network interface ID from child to root"
  value       = module.gateways.primary_nat_network_interface_id
}

output "standby_nat_network_interface_id" {
  description = "Linear transfer: Passing standby NAT network interface ID from child to root"
  value       = module.gateways.standby_nat_network_interface_id
}

output "vpc_peering_connection_id" {
  description = "Linear transfer: Passing VPC peering connection ID from child to root"
  value       = module.peering.vpc_peering_connection_id
}

output "vpc_peering_status" {
  description = "Linear transfer: Passing VPC peering status from child to root"
  value       = module.peering.vpc_peering_status
}

output "primary_s3_vpc_endpoint_id" {
  description = "Gateway VPC endpoint ID for S3 in the primary region"
  value       = module.endpoints.primary_s3_vpc_endpoint_id
}

output "standby_s3_vpc_endpoint_id" {
  description = "Gateway VPC endpoint ID for S3 in the standby region"
  value       = module.endpoints.standby_s3_vpc_endpoint_id
}
