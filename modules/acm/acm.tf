resource "aws_acm_certificate" "pritunl_cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "Pritunl ACM Certificate"
  }
}

resource "aws_route53_record" "cert_validation" {
  count   = length(aws_acm_certificate.pritunl_cert.domain_validation_options)

  name    = element(tolist(aws_acm_certificate.pritunl_cert.domain_validation_options), count.index).resource_record_name
  type    = element(tolist(aws_acm_certificate.pritunl_cert.domain_validation_options), count.index).resource_record_type
  zone_id = var.hosted_zone_id
  records = [element(tolist(aws_acm_certificate.pritunl_cert.domain_validation_options), count.index).resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.pritunl_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
