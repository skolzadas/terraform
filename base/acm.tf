
resource "aws_acm_certificate" "lightspace" {
  domain_name               = "lightspace.com.br"
  subject_alternative_names = ["*.lightspace.com.br"]
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_acm_certificate_validation" "lightspace" {
  certificate_arn         = aws_acm_certificate.lightspace.arn
  validation_record_fqdns = [aws_route53_record.lightspace.fqdn]
}