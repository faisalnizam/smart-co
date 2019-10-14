remote_state {
    backend  = "s3"
    config {
      encrypt     = true
      bucket      = "infra-tfstate-sprii"
      key         = "production/terraform.tfstate"
      region      = "eu-west-1"
      lock_table  = "prod-tfstate-sprii"
    }
}

terraform {
  extra_arguments "common_vars" {
    commands = ["plan", "apply"]
    arguments = [
      "-var-file=terragrunt.hcl"
    ]
  }
    source = "../../modules/magento_resources"
}
