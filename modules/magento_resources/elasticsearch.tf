resource "aws_security_group" "elasticsearch_sg" {
  name        = "esallow"
  description = "Allow all elasticsearch traffic"
  vpc_id      = "${aws_vpc.ebs-vpc.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = ["pl-12c4e678"]
  }
}



module "es" {
  source                         = "modules/elasticsearch"
  domain_name                    = "sprii-search-domain"
  vpc_options                    = {
    security_group_ids = ["${var.elasticsearch_sg.id}"]
    subnet_ids         = ["${aws_subnet.int_net.id}", "${aws_subnet.db_net.id}"]
  }
  instance_count                 = 1
  instance_type                  = "t2.medium.elasticsearch"
  dedicated_master_type          = "t2.medium.elasticsearch"
  es_zone_awareness              = false
  ebs_volume_size                = 35
}
