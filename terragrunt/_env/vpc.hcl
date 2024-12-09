terraform { # ssh host aliased as "github" in ~/.ssh/config
  source = "git@github:kmontocam/terraform-aws//modules/vpc?ref=main"
}

locals {
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  common_tags = local.env_vars.locals.common_tags
}

inputs = {
  common_tags = local.common_tags
  # additional_tags?: map(string)
  # cidr_block: string
}
