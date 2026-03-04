output "primary_public_sg_id" {
  value       = aws_security_group.primary_public_sg.id
  description = "The ID of the primary public security group"
}

output "primary_private_sg_id" {
  value       = aws_security_group.primary_private_sg.id
  description = "The ID of the primary private security group"
}

output "standby_public_sg_id" {
  value       = aws_security_group.standby_public_sg.id
  description = "The ID of the standby public security group"
}

output "standby_private_sg_id" {
  value       = aws_security_group.standby_private_sg.id
  description = "The ID of the standby private security group"
}