
resource "aws_elb" "web2_server_lb" {
  name               = "web-server-instance-elb"
  subnets            = [aws_subnet.public.id]
  security_groups     = [aws_security_group.allow_web.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  
  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${data.aws_acm_certificate.gadget-acm.arn}"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = [aws_instance.web-server-instance.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "example-terraform-elb"
  }
}


resource "aws_elb_attachment" "attach_ec2_to_elb" {
  elb = "${aws_elb.web2_server_lb.id}"
  instance = "${aws_instance.web-server-instance.id}"
  depends_on = [aws_instance.web-server-instance]
}




output "aws_elb_dns" {
  value = aws_elb.web2_server_lb.dns_name 
}