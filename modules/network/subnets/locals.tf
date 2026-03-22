locals {

  subnets_vpcs = {
    public_az1   = { cidr_index = 1, az_index = 0, public = true }
    public_az2   = { cidr_index = 2, az_index = 1, public = true }
    private_app1 = { cidr_index = 11, az_index = 0, public = false }
    private_app2 = { cidr_index = 12, az_index = 1, public = false }
    private_db1  = { cidr_index = 21, az_index = 0, public = false }
    private_db2  = { cidr_index = 22, az_index = 1, public = false }
  }
  
}