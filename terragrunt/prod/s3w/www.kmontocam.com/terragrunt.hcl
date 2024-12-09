include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${get_terragrunt_dir()}/../../../_env/s3w.hcl"
}

dependency "s3b" {
  config_path = "${get_terragrunt_dir()}/../../s3b/www.kmontocam.com"
}

inputs = {
  s3b_id        = dependency.s3b.outputs.s3b_id
  routing_rules = null
  is_cf_cname   = true
}
