generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
  provider "cloudflare" {
    # expects CLOUDFLARE_API_TOKEN to be set in the environment
  }

  terraform {
    required_providers {
      cloudflare = {
        source  = "cloudflare/cloudflare"
        version = "~> 4.0"
      }
    }
  }
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
