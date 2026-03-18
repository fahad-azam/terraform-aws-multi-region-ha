output "primary_s3_vpc_endpoint_id" {
  description = "Gateway VPC endpoint ID for S3 in the primary region"
  value       = aws_vpc_endpoint.primary_s3.id
}

output "standby_s3_vpc_endpoint_id" {
  description = "Gateway VPC endpoint ID for S3 in the standby region"
  value       = aws_vpc_endpoint.standby_s3.id
}
