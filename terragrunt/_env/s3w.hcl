terraform { # ssh host aliased as "github" in ~/.ssh/config
  source = "git@github:kmontocam/terraform-aws//modules/s3w?ref=main"
}

# all inputs come from the dependency
# inputs = {
#   s3b_id: str
#   routing_rules: str
#   is_cf_cname?: bool
# }
