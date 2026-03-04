output "primary_vpc_subnet" {
    description = "The ID of the subnet"
    value       = {for k, v in aws_subnet.primary_vpc_subnets : k =>{
        id = v.id,
        availability_zone = v.availability_zone,
        cidr_block = v.cidr_block,
        map_public_ip_on_launch = v.map_public_ip_on_launch
    }}
}
output "standby_vpc_subnet" {
  description = "The ID of the standby subnet"
  value = {for k, v in aws_subnet.standby_vpc_subnets : k =>{
    id = v.id,
    availability_zone = v.availability_zone,
    cidr_block = v.cidr_block,
    map_public_ip_on_launch = v.map_public_ip_on_launch
  }}
}