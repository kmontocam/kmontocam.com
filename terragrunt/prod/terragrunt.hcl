generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
  terraform {
    required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
      }
    }
  }

  provider "aws" {
    region       = "us-east-1"
    default_tags { # match as in ./env.hcl. currently no way to import local from file
      tags = {
        "Environment" = "prod"
        "Enterprise"  = "kmontocam"
        "Project"     = "Many"
      }
    } 
  }

  provider "http" {}
  EOF
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }

  config = {
    bucket                         = "s3b-kmontocam-core-prod"
    region                         = "us-east-1"
    encrypt                        = true
    key                            = "tfstate/${path_relative_to_include()}/terraform.tfstate"
    skip_bucket_versioning         = false
    skip_bucket_ssencryption       = false
    skip_bucket_root_access        = false
    skip_bucket_enforced_tls       = false
    skip_credentials_validation    = false
    enable_lock_table_ssencryption = false

    skip_metadata_api_check = false
    force_path_style        = true
  }
}
