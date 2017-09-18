resource "aws_elb" "test-http" {
    name = "test-http-elb"
    security_groups = ["${var.security_groups}"]
    subnets = ["${var.subnet_id}"]

    listener {
        lb_protocol = "http"
        lb_port = 80

        instance_protocol = "http"
        instance_port = 80
    }

    health_check {
        healthy_threshold = 3
        unhealthy_threshold = 2
        timeout = 3
        target = "TCP:80"
        interval = 5
    }

    cross_zone_load_balancing = true
}
