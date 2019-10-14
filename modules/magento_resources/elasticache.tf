resource "aws_elasticache_subnet_group" "redis_subnets" {
  name       = "magento-${var.env}-redis-subnet-group"
  subnet_ids = ["${aws_subnet.int_net.id}"]
}

resource "aws_elasticache_cluster" "redis_cache" {
  cluster_id         = "rediscache"
  engine             = "redis"
  maintenance_window = "sat:01:00-sat:03:00"
  engine_version     = "2.8.24"
  node_type          = "cache.m3.xlarge"
  num_cache_nodes    = 1
  port               = 6379

  subnet_group_name = "${aws_elasticache_subnet_group.redis_subnets.name}"

  security_group_ids = [
    "${aws_security_group.redis_sg.id}",
  ]

  tags {
    Name = "redis_cache"
    Role = "redis"
    Env  = "${var.env}"
  }
}

resource "aws_elasticache_cluster" "redis_session" {
  cluster_id         = "redissession"
  engine             = "redis"
  maintenance_window = "sun:01:00-sun:03:00"
  engine_version     = "2.8.24"
  node_type          = "cache.m3.xlarge"
  num_cache_nodes    = 1
  port               = 6379

  subnet_group_name = "${aws_elasticache_subnet_group.redis_subnets.name}"

  security_group_ids = [
    "${aws_security_group.redis_sg.id}",
  ]

  tags {
    Name = "redis_session"
    Role = "redis"
    Env  = "${var.env}"
  }
}
