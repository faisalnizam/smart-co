resource "aws_vpc" "ebs-vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "magento-${var.env}-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.ebs-vpc.id}"
}

resource "aws_subnet" "ext_net" {
  vpc_id = "${aws_vpc.ebs-vpc.id}"

  cidr_block              = "${var.public_subnet_cidr}"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags {
    Name = "magento-${var.env}-ext_net"
  }
}

resource "aws_subnet" "int_net" {
  vpc_id = "${aws_vpc.ebs-vpc.id}"

  cidr_block              = "${var.private_subnet_cidr}"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags {
    Name = "magento-${var.env}-int_net"
  }
}

resource "aws_subnet" "db_net" {
  vpc_id = "${aws_vpc.ebs-vpc.id}"

  cidr_block              = "${var.database_subnet_cidr}"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags {
    Name = "magento-${var.env}-db_net"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = "${aws_vpc.ebs-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "magento-${var.env}-rt"
  }
}

resource "aws_route_table_association" "ext_rta" {
  subnet_id      = "${aws_subnet.ext_net.id}"
  route_table_id = "${aws_route_table.rt.id}"
}

resource "aws_route_table_association" "int_rta" {
  subnet_id      = "${aws_subnet.int_net.id}"
  route_table_id = "${aws_route_table.rt.id}"
}
