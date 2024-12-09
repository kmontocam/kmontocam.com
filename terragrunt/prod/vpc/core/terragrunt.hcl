include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${get_terragrunt_dir()}/../../../_env/vpc.hcl"
}

inputs = {
  cidr_block  = "10.0.0.0/16"
}
