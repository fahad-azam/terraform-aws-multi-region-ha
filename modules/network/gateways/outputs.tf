output "primary_igw_id" {
  value       = aws_internet_gateway.igw_primary.id
  description = "The ID of the Primary Internet Gateway"
}
output "standby_igw_id" {
  value       = aws_internet_gateway.igw_standby.id
  description = "The ID of the Standby Internet Gateway"
}
