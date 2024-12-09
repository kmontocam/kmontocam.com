include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${get_terragrunt_dir()}/../../../_env/s3b.hcl"
}

inputs = {
  additional_tags   = {"Project": "Home"}
  is_website_bucket = true
  tld               = "com"
  subdomain         = "www"
}
