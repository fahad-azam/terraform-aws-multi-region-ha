output "primary_igw_id" {
  value       = aws_internet_gateway.igw_primary.id
  description = "The ID of the Primary Internet Gateway"
}
output "standby_igw_id" {
  value       = aws_internet_gateway.igw_standby.id
  description = "The ID of the Standby Internet Gateway"
}

output "primary_nat_instance_id" {
  value       = aws_instance.primary_nat.id
  description = "The ID of the primary region NAT instance"
}

output "standby_nat_instance_id" {
  value       = aws_instance.standby_nat.id
  description = "The ID of the standby region NAT instance"
}

output "primary_nat_network_interface_id" {
  value       = aws_instance.primary_nat.primary_network_interface_id
  description = "The primary network interface ID of the primary NAT instance"
}

output "standby_nat_network_interface_id" {
  value       = aws_instance.standby_nat.primary_network_interface_id
  description = "The primary network interface ID of the standby NAT instance"
}
