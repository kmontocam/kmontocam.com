locals {
  env         = "prod"
  enterprise  = "kmontocam"
  common_tags = {
    "Environment" = local.env
    "Enterprise" = local.enterprise
    "Project" = "Many"
  }
}
