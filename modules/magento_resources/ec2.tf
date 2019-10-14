data "template_file" "magento_install" {
  template = "${file("templates/admin_magento_install.tpl")}"

  vars {
    MAGE_MODE    = "developer"
    SHARED_MOUNT = "${aws_efs_mount_target.shared_mount_target.dns_name}"
    
    ENVIRONMENT_NAME = "logiik" 

    MAGENTO_HOST_NAME = "${aws_elb.magento_elb.dns_name}"
    MAGENTO_BASE_URL  = "http://${aws_elb.magento_elb.dns_name}/"

    MAGENTO_DATABASE_HOST = "${module.aurora_db_57.cluster_endpoint}"
    MAGENTO_DATABASE_PORT = "3306"
    MAGENTO_DATABASE_NAME = "magento"
    MAGENTO_DATABASE_USER = "magento"
    MAGENTO_DATABASE_PASSWORD = "${var.db_password}"

    MAGENTO_REDIS_CACHE_HOST_NAME   = "${aws_elasticache_cluster.redis_cache.cache_nodes.0.address}"
    MAGENTO_REDIS_SESSION_HOST_NAME = "${aws_elasticache_cluster.redis_session.cache_nodes.0.address}"
    MAGENTO_REDIS_PORT              = "${aws_elasticache_cluster.redis_cache.port}"
  }
}

data "template_file" "nginx_install" {
  template = "${file("templates/nginx.tpl")}"

  vars {
    MAGENTO_HTTP_URL = "http://${aws_elb.magento_elb.dns_name}/"
    MAGENTO_BASE_URL = "${aws_elb.magento_elb.dns_name}"
  }
}

resource "aws_launch_configuration" "magento_lc" {
  name          = "magento-${var.env}-launchc"
  image_id      = "${var.magento_ami}"
  instance_type = "${var.magento_type}"
  key_name      = "${var.ssh_user}"
#  user_data	= "Hello World" 
  user_data     = "${data.template_file.magento_install.rendered}"

  security_groups = [
    "${aws_security_group.magento_sg.id}",
  ]

  lifecycle {
    create_before_destroy = true
  }
}

#resource "aws_eip" "lb" {
#  instance = "${aws_instance.cache_primary.id}"
#  vpc      = true
#}

resource "aws_elb" "magento_elb" {
  name            = "magento-${var.env}-elb"
  security_groups = ["${aws_security_group.elb_sg.id}"]
  subnets         = ["${aws_subnet.int_net.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 5
    target              = "TCP:80"
    interval            = 120
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "magento-${var.env}-elb"
  }
}

resource "aws_autoscaling_group" "magento_asg" {
  depends_on                = ["aws_efs_mount_target.shared_mount_target"]
  vpc_zone_identifier       = ["${aws_subnet.int_net.id}"]
  name                      = "magento-${var.env}-asg"
  load_balancers            = ["${aws_elb.magento_elb.id}"]
  max_size                  = "${var.max_size}"
  min_size                  = "${var.min_size}"
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = "${var.min_size}"
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.magento_lc.name}"

  tags = [
    {
      key                 = "Name"
      value               = "magento-instance"
      propagate_at_launch = true
    },
    {
      key                 = "Role"
      value               = "magento"
      propagate_at_launch = true
    },
    {
      key                 = "Env"
      value               = "${var.env}"
      propagate_at_launch = true
    },
  ]
}

resource "aws_autoscaling_policy" "magento_asg_add_policy" {
  name                   = "magento-${var.env}-scaling-add-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.magento_asg.name}"
}

resource "aws_autoscaling_policy" "magento_asg_drop_policy" {
  name                   = "magento-${var.env}-scaling-drop-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.magento_asg.name}"
}

resource "aws_cloudwatch_metric_alarm" "cpualarm_up" {
  alarm_name          = "magento-${var.env}-cpualarm-scale-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "60"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.magento_asg.name}"
  }

  alarm_description = "This metric monitor EC2 instance cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.magento_asg_add_policy.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "cpualarm_down" {
  alarm_name          = "magento-${var.env}-cpualarm-scale-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "10"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.magento_asg.name}"
  }

  alarm_description = "This metric monitor EC2 instance cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.magento_asg_drop_policy.arn}"]
}

resource "aws_instance" "cache_primary" {
  ami                         = "${var.cache_ami}"
  instance_type               = "${var.cache_type}"
  subnet_id                   = "${aws_subnet.ext_net.id}"
  associate_public_ip_address = true

  vpc_security_group_ids = [
    "${aws_security_group.cache_sg.id}",
  ]

  key_name = "${var.ssh_user}"

  #  provisioner "remote-exec" {
  #    inline = [
  #      "sudo apt install -y nginx"
  #    ]
  #
  #    connection {
  #      type        = "ssh"
  #      user        = "ubuntu"
  #      private_key = "${file("~/.ssh/${var.ssh_user}.pem")}"
  #    }
  #  }
  #
  #  provisioner "file" {
  #    content     = "${data.template_file.nginx_install.rendered}"
  #    destination = "/home/ubuntu/nginx.conf"
  #
  #    connection {
  #      type        = "ssh"
  #      user        = "ubuntu"
  #      private_key = "${file("~/.ssh/${var.ssh_user}.pem")}"
  #    }
  #  }
  #
  #  provisioner "remote-exec" {
  #    inline = [
  #      "sudo mv /home/ubuntu/nginx.conf /etc/nginx/",
  #      "sudo systemctl enable nginx.service",
  #      "sudo systemctl restart nginx.service"
  #    ]
  #
  #    connection {
  #      type        = "ssh"
  #      user        = "ubuntu"
  #      private_key = "${file("~/.ssh/${var.ssh_user}.pem")}"
  #    }
  #  }

  tags {
    Name = "cache_primary"
    Role = "cache"
    Env  = "${var.env}"
  }
}

resource "aws_efs_file_system" "shared_mount" {
  creation_token   = "magento_share"
  performance_mode = "maxIO"

  tags {
    Name = "magento_share"
    Env  = "${var.env}"
  }
}

resource "aws_efs_mount_target" "shared_mount_target" {
  file_system_id  = "${aws_efs_file_system.shared_mount.id}"
  subnet_id       = "${aws_subnet.int_net.id}"
  security_groups = ["${aws_security_group.efs_sg.id}"]
}

#resource "aws_instance" "cache_secondary" {
#  ami                         = "${var.cache_ami}"
#  instance_type               = "${var.cache_type}"
#  subnet_id                   = "${aws_subnet.ext_net.id}"
#	 associate_public_ip_address = true
#  vpc_security_group_ids      = [
#    "${aws_security_group.cache_sg.id}"
#  ]
#  key_name                    = "${var.ssh_user}"
#
#  tags {
#      Name  = "cache_secondary"
#      Role  = "cache"
#      Env   = "${var.env}"
#  }
#}

resource "aws_route53_record" "dangerman" {
  zone_id = "${var.zone_id}"
  name    = "${var.dns_name}"
  name    = "logiik.sprii.com"
  type    = "A"

  alias {
    name                   = "${aws_elb.magento_elb.dns_name}"
    zone_id                = "${aws_elb.magento_elb.zone_id}"
    evaluate_target_health = false
  }
}
