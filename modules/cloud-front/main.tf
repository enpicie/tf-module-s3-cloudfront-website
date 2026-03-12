####################################################
# CloudFront Origin Access Control
####################################################
resource "aws_cloudfront_origin_access_control" "cf-s3-oac" {
  name                              = "${var.naming_prefix}-oac"
  description                       = "OAC for ${var.naming_prefix} CloudFront distribution"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

####################################################
# CloudFront distribution
####################################################
resource "aws_cloudfront_distribution" "cf-dist" {
  enabled             = true
  default_root_object = "index.html"
  aliases             = var.domain_name != null ? [var.domain_name] : []

  origin {
    domain_name              = var.s3_bucket_domain_name
    origin_id                = var.s3_bucket_id
    origin_access_control_id = aws_cloudfront_origin_access_control.cf-s3-oac.id
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = var.s3_bucket_id
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  price_class = "PriceClass_All"

  # Return index.html for 403s so React Router handles client-side routing
  # (S3 with OAC returns 403 for missing paths, not 404)
  custom_error_response {
    error_code         = 403
    response_page_path = "/index.html"
    response_code      = 200
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = var.acm_certificate_arn != null ? "sni-only" : null
    minimum_protocol_version       = var.acm_certificate_arn != null ? "TLSv1.2_2021" : null
    cloudfront_default_certificate = var.acm_certificate_arn == null
  }

  tags = merge(var.common_tags, {
    Name = "${var.naming_prefix}-cloudfront"
  })
}
