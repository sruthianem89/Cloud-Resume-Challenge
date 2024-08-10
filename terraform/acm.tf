# Creating Certificate using Terraform

# Retrieve the Cloudflare zone ID
data "cloudflare_zones" "zone" {
  filter {
    name = "sruthianem.com"
  }
}

# ACM Certificate
resource "aws_acm_certificate" "cert" {
  domain_name       = "sruthianem.com"
  validation_method = "DNS"

  subject_alternative_names = [
    "*.sruthianem.com"
  ]

  tags = {
    Name = "sruthianem-cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# DNS Validation Record in Cloudflare
resource "cloudflare_record" "cert_validation" {
  zone_id = data.cloudflare_zones.zone.zones[0].id
  name    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_name
  value   = aws_acm_certificate.cert.domain_validation_options[0].resource_record_value
  type    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_type
  ttl     = 300

  depends_on = [aws_acm_certificate.cert]
}

# Output the ARN of the certificate
output "certificate_arn" {
  value = aws_acm_certificate.cert.arn
}