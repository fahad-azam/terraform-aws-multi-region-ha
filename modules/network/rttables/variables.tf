variable "vpc_id" {
    type = map(string)
    description = "Map containing VPC IDs for both regions"
}

# variable "rt_tables" {
#     type = map(object(
#         {
#             is_public = bool
#             suffix = string
#         }
#     )

#     )
# }