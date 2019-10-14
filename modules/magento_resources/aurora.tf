resource "aws_db_subnet_group" "rds_subnet" {
  name       = "magento-${var.env}-rds-subnet"
  subnet_ids = ["${aws_subnet.int_net.id}", "${aws_subnet.db_net.id}"]

  tags {
    Name = "magento-${var.env}-rds-subnet"
  }
}

resource "aws_sns_topic" "db_alarms" {
  name = "aurora-db-alarms"
}

module "aurora_db_57" {
  source                          = "modules/aurora"
  engine                          = "aurora"
  engine-version                  = "5.7.12"
  name                            = "sprii-magento-db-57"
  envname                         = "sprii-snapshot-57"
  envtype                         = "production"
  subnets                         = ["${aws_subnet.int_net.id}", "${aws_subnet.db_net.id}"]
  azs                             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  replica_count                   = "1"
  security_groups                 = ["${aws_security_group.db_sg.id}"]
  instance_type                   = "db.t2.medium"
  username                        = "root"
  password                        = "faisalna3232"
  backup_retention_period         = "5"
  final_snapshot_identifier       = "final-db-snapshot-prod"
  storage_encrypted               = "false"
  apply_immediately               = "true"
  monitoring_interval             = "10"
  cw_alarms                       = true
  cw_sns_topic                    = "${aws_sns_topic.db_alarms.id}"
  db_parameter_group_name         = "${aws_db_parameter_group.aurora_db_57_parameter_group.id}"
  db_cluster_parameter_group_name = "${aws_rds_cluster_parameter_group.aurora_57_cluster_parameter_group.id}"
  db_snapshot_identifier          = "${var.db_snapshot_identifier}"
}

resource "aws_db_parameter_group" "aurora_db_57_parameter_group" {
  name        = "sprii-aurora-db-57-parameter-group"
  family      = "aurora-mysql5.7"
  description = "sprii-aurora-db-57-parameter-group"
}

resource "aws_rds_cluster_parameter_group" "aurora_57_cluster_parameter_group" {
  name        = "sprii-aurora-57-cluster-parameter-group"
  family      = "aurora-mysql5.7"
  description = "sprii-aurora-57-cluster-parameter-group"
}
 
