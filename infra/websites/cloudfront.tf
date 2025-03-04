resource "aws_cloudfront_distribution" "cloudfront" {
  comment = "CloudFront for ${var.domain}"

  aliases = [
    var.domain,
    "www.${var.domain}"
  ]

  enabled         = true
  http_version    = "http2"
  is_ipv6_enabled = false

  origin {
    domain_name        = var.instance_public_dns
    origin_id          = "EC2Origin"
    connection_timeout = 10

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_protocol_policy   = "http-only"
      origin_ssl_protocols     = ["TLSv1.2"]
      origin_keepalive_timeout = 60
      origin_read_timeout      = 30
    }
  }

  default_cache_behavior {
    target_origin_id       = "EC2Origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]

    cache_policy_id          = aws_cloudfront_cache_policy.cache_policy.id
    origin_request_policy_id = "33f36d7e-f396-46d9-90e0-52428a34d9dc"

    compress = true
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.cert_validation.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  logging_config {
    bucket          = "${var.logging_bucket}.s3.amazonaws.com"
    prefix          = "${var.domain}/web/"
    include_cookies = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = merge(local.tags, {
    Name       = "${var.domain}-CloudFrontDistribution"
    CostCenter = "Bugfloyd/Websites/CloudFront"
  })
}

resource "aws_cloudfront_cache_policy" "cache_policy" {
  name = "${replace(var.domain, ".", "_")}-cache-policy"

  default_ttl = 86400
  max_ttl     = 31536000
  min_ttl     = 0

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = "whitelist"
      headers {
        items = ["Host", "Options"]
      }
    }

    query_strings_config {
      query_string_behavior = "all"
    }

    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
  }
}

resource "aws_route53_record" "main_dns_record" {
  zone_id = var.hosted_zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cloudfront.domain_name
    zone_id                = "Z2FDTNDATAQYW2" # CloudFront's Hosted Zone ID
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_dns_record" {
  zone_id = var.hosted_zone_id
  name    = "www.${var.domain}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cloudfront.domain_name
    zone_id                = "Z2FDTNDATAQYW2" # CloudFront's Hosted Zone ID
    evaluate_target_health = false
  }
}
