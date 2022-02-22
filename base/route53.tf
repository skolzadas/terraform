data "aws_route53_zone" "lightspace" {
  name         = "lightspace.com.br"
  private_zone = false
}


resource "aws_route53_record" "lightspace" {
  name    = tolist(aws_acm_certificate.lightspace.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.lightspace.domain_validation_options)[0].resource_record_type
  records = [tolist(aws_acm_certificate.lightspace.domain_validation_options)[0].resource_record_value]
  zone_id = data.aws_route53_zone.lightspace.zone_id
  ttl     = 60
}


output "domain_validations" {
  value = aws_acm_certificate.lightspace.domain_validation_options
}