output "primary_rt_id" {
  
  description = "The ID of the primary route table"
  value       = { for k, v in aws_route_table.primary_rt : k => v.id }
}
output "standby_rt_id" {

  description = "The ID of the standby route table"
  value       = { for k, v in aws_route_table.standby_rt : k => v.id }
}