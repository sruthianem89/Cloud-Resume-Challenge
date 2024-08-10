resource "cloudflare_record" "root_domain" {
  zone_id = data.cloudflare_zones.zone.zones[0].id
  name    = "sruthianem.com"
  value   = aws_cloudfront_distribution.frontend_distribution.domain_name
  type    = "CNAME"
  proxied = true

  depends_on = [
    aws_cloudfront_distribution.frontend_distribution
  ]
}

resource "cloudflare_record" "wildcard_subdomain" {
  zone_id = data.cloudflare_zones.zone.zones[0].id
  name    = "*.sruthianem.com"
  value   = aws_cloudfront_distribution.frontend_distribution.domain_name
  type    = "CNAME"
  proxied = true

  depends_on = [
    aws_cloudfront_distribution.frontend_distribution
  ]
}