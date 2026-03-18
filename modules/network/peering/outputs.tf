output "vpc_peering_connection_id" {
  description = "Cross-region VPC peering connection ID"
  value       = aws_vpc_peering_connection.primary_to_standby.id
}

output "vpc_peering_status" {
  description = "Cross-region VPC peering status"
  value       = aws_vpc_peering_connection_accepter.standby_accept.accept_status
}
