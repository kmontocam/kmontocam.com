terraform { # ssh host aliased as "github" in ~/.ssh/config
  source = "git@github:kmontocam/terraform-aws//modules/s3b?ref=main"
}

locals {
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_name    = local.env_vars.locals.env
  common_tags = local.env_vars.locals.common_tags
  enterprise =  local.env_vars.locals.enterprise
}

inputs = {
  env         = local.env_name
  enterprise  = local.enterprise
  common_tags = local.common_tags
  # additional_tags?: map(string)
  # is_website_bucket?: bool
  # object_lock_enabled?: bool
  # usage: str
}
