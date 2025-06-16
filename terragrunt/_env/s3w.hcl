terraform { # ssh host aliased as "github" in ~/.ssh/config
  source = "git@github:kmontocam/terraform-aws//modules/s3w?ref=main"
}

# all inputs come from the dependency
# inputs = {
#   error_key: str
#   is_cf_cname?: bool
#   routing_rules: str
#   s3b_id: str
# }
