terragrunt {
  remote_state {
    backend  = "s3"
    config {
      encrypt     = true
      bucket      = "infra-tfstate-sprii"
      key         = "production/terraform.tfstate"
      region      = "eu-west-1"
      lock_table  = "prod-tfstate-sprii"
    }
  },
  terraform {
    source = "../../modules/magento_resources"
  }
}

aws_region                = "eu-west-1"
profile                  = "sprii" 
env                       = "prodmock"
ssh_user                  = "logiikNew"
db_password               = "UPLARDhjGAWvd3KB9JrV7A"
vpc_cidr                  = "10.1.0.0/16"
public_subnet_cidr        = "10.1.1.0/24"
private_subnet_cidr       = "10.1.2.0/24"
database_subnet_cidr      = "10.1.3.0/24"
magento_ami               = "ami-02e9337b"
cache_ami                 = "ami-8fd760f6"
magento_admin_frontname   = "admin"
magento_admin_user        = "magento"
magento_admin_password    = "UPLARDhjGAWvd3KB9JrV7A"
magento_admin_email       = "faisal@logiik.com"
magento_admin_firstname   = "Faisal"
magento_admin_lastname    = "Nizam"
magento_admin_timezone    = "UTC"
magento_locale            = "en_US"
db_snapshot_identifier    = "arn:aws:rds:eu-west-1:322809376013:cluster-snapshot:mangeto-prod-snapshot-for-tf"
zone_id			  = "Z15G6SOZRJVWNO"
dns_name		  = "logiik.sprii-test.com"

