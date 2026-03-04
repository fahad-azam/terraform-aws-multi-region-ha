output "primary_vpc_id" {
    description = "The ID of the primary VPC"
    value       = aws_vpc.primary_vpc.id
}

output "standby_vpc_id" {
    description = "The ID of the standby VPC"
    value       = aws_vpc.standby_vpc.id
}