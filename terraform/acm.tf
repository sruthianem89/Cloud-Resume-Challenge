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

locals {
  domain_validation_options = [
    for val in aws_acm_certificate.cert.domain_validation_options : {
      name  = val.resource_record_name
      value = val.resource_record_value
      type  = val.resource_record_type
    }
  ]
}

resource "cloudflare_record" "cert_validation" {

    zone_id = data.cloudflare_zones.zone.zones[0].id
    name    = local.domain_validation_options[0].name
    value   = local.domain_validation_options[0].value
    type    = local.domain_validation_options[0].type
    ttl     = 300

  depends_on = [aws_acm_certificate.cert]
}

