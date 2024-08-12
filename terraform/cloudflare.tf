resource "cloudflare_record" "root_domain" {
  zone_id = data.cloudflare_zones.zone.zones[0].id
  name    = var.domain_name
  value   = aws_cloudfront_distribution.frontend_distribution.domain_name
  type    = "CNAME"
  proxied = true

  depends_on = [
    aws_cloudfront_distribution.frontend_distribution
  ]
}

resource "cloudflare_record" "wildcard_subdomain" {
  zone_id = data.cloudflare_zones.zone.zones[0].id
  name    = var.sub_domain_name
  value   = aws_cloudfront_distribution.frontend_distribution.domain_name
  type    = "CNAME"
  proxied = true

  depends_on = [
    aws_cloudfront_distribution.frontend_distribution
  ]
}

# Purge Cloudflare cache for both root domain and subdomain
resource "cloudflare_zone_cache_purge" "purge_cache" {
  zone_id = data.cloudflare_zones.zone.zones[0].id

  depends_on = [
    cloudflare_record.root_domain,
    cloudflare_record.wildcard_subdomain
  ]
}