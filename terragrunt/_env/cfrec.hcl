terraform { # ssh host aliased as "github" in ~/.ssh/config
  source = "git@github:kmontocam/terraform-cf//modules/cfrec?ref=main"
}

locals {
  env_cf_vars = read_terragrunt_config(find_in_parent_folders("env.cloudflare.hcl"))
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  plan        = local.env_cf_vars.locals.plan
  zone_id     = local.env_cf_vars.locals.zone_id
}

inputs = {
  plan    = local.plan
  zone_id = local.zone_id
  # records: list(object)
  # NOTE: not env, no ignore env prefixed record
}
