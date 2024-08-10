#dependent on ACM certificate creation
resource "aws_cloudfront_distribution" "frontend_distribution" {
  
  depends_on = [aws_acm_certificate.cert]
  origin {
    domain_name = aws_s3_bucket.frontend_bucket.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.frontend_bucket.bucket}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for frontend bucket"
  default_root_object = "index.html"

  aliases = var.alternate_domain_names

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.frontend_bucket.bucket}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "https-only"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  viewer_certificate {
    acm_certificate_arn 			= aws_acm_certificate.cert.arn
    ssl_support_method              = "sni-only"
    minimum_protocol_version        = "TLSv1.2_2019"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "frontend-distribution"
  }
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "OAI for frontend bucket"
}

