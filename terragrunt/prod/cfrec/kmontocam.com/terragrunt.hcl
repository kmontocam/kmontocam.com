include "root" {
  path = find_in_parent_folders("terragrunt.cloudflare.hcl")
}

include "env" {
  path = "${get_terragrunt_dir()}/../../../_env/cfrec.hcl"
}

dependency "s3w" {
  config_path = "${get_terragrunt_dir()}/../../s3w/kmontocam.com"
}

dependency "mle_s3w" {
  config_path = "${get_terragrunt_dir()}/../../s3w/mle.kmontocam.com"
}

inputs = {
  records = [
    {
      content     = dependency.s3w.outputs.s3w_endpoint
      name        = "kmontocam.com"
      ttl         = 1
      proxied     = true
      type        = "CNAME"
    },
    {
      content     = dependency.s3w.outputs.s3w_endpoint
      name        = "www.kmontocam.com"
      ttl         = 1
      proxied     = true
      type        = "CNAME"
    },
    {
      content     = "255.255.255.255" # NOTE: ip that will be dynamically allocated by ddclient
      name        = "ddns.kmontocam.com"
      ttl         = 1
      proxied     = true
      type        = "A"
    },
    {
      content     = dependency.mle_s3w.outputs.s3w_endpoint
      name        = "mle.kmontocam.com"
      ttl         = 1
      proxied     = true
      type        = "CNAME"
    },
  ]
}
