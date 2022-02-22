


data "aws_route53_zone" "lightspace" {
  name         = "lightspace.com.br"
  private_zone = false
}


resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.lightspace.zone_id
  name    = "www.lightspace.com.br"
  type    = "A"

  alias {
    name                   = aws_elb.web2_server_lb.dns_name
    zone_id                = aws_elb.web2_server_lb.zone_id
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "lightspace" {
  zone_id = data.aws_route53_zone.lightspace.zone_id
  name    = "lightspace.com.br"
  type    = "A"

  alias {
    name                   = aws_elb.web2_server_lb.dns_name
    zone_id                = aws_elb.web2_server_lb.zone_id
    evaluate_target_health = true
  }
}