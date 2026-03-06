provider "aws" {
    region = var.primary_region_aws
    
}

provider "aws"  {
    region = var.standby_region_aws
    alias = "standby_region_aws"
}
