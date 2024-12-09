include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${get_terragrunt_dir()}/../../../_env/s3b.hcl"
}

inputs = {
  usage = "core"
}
