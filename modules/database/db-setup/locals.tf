# Construct the SSM paths dynamically
# Resulting paths: 
# /${project_name}/network/primary/private_sg_id
# /${project_name}/network/standby/private_sg_id
# since we are using the same key "private_sg_id" for both regions, we can simplify the construction
locals {
  db_regions  = ["primary", "standby"]
  environment = lower(var.environment)
  sg_ssm_paths = {
    for region in local.db_regions :
    region => "/${var.project_name}/${local.environment}/network/${region}/private_sg_id"
  }

}

