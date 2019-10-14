data "aws_availability_zones" "available" {}

variable "aws_region" {
  description = "AWS Region"
}

variable "env" {
  description = "Environment"
}

variable "ssh_user" {
  description = "SSH User"
}

variable "db_password" {
  description = "RDS root password"
  default     = "test1234"
}

variable "vpc_cidr" {
  description = "VPC netblock"
  default     = "10.1.0.0/16"
}

variable "public_subnet_cidr" {
  description = "VPC public subnet"
  default     = "10.1.1.0/24"
}

variable "private_subnet_cidr" {
  description = "VPC private subnet"
  default     = "10.1.2.0/24"
}

variable "database_subnet_cidr" {
  description = "VPC database subnet"
  default     = "10.1.3.0/24"
}

variable "magento_ami" {
  description = "Magento AMI"
}

variable "magento_type" {
  description = "Magento Instance Type"
  default     = "c5.xlarge"
}

variable "min_size" {
  description = "ASG Minimum Instances"
  default     = "1"
}

variable "max_size" {
  description = "ASG Maximum Instances"
  default     = "2"
}

variable "cache_ami" {
  description = "cache AMI"
}

variable "cache_type" {
  description = "cache Instance Type"
  default     = "t2.medium"
}

variable "magento_admin_frontname" {
  description = "magento_admin_frontname"
}

variable "magento_admin_user" {
  description = "magento_admin_user"
}

variable "magento_admin_password" {
  description = "magento_admin_password"
}

variable "magento_admin_email" {
  description = "magento_admin_email"
}

variable "magento_admin_firstname" {
  description = "magento_admin_firstname"
}

variable "magento_admin_lastname" {
  description = "magento_admin_lastname"
}

variable "magento_admin_timezone" {
  description = "magento_admin_timezone"
}

variable "magento_locale" {
  description = "magento_locale"
}

variable "db_snapshot_identifier" {
  description = "DB Snapshot identifier"
}

variable "zone_id" { 
  description = "Zone ID" 
} 

variable "dns_name" { 
  description = "DNS Name" 
}
