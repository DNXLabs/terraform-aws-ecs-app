resource "aws_cloudfront_distribution" "default" {
  enabled         = true
  is_ipv6_enabled = true
  comment         = "${var.name}"
  aliases         = concat(list(var.hostname), compact(split(",", var.hostname_redirects)), list(var.hostname_blue))
  price_class     = "PriceClass_All"

  origin {
    domain_name = "${aws_route53_record.hostname_origin.name}"
    origin_id   = "${var.name}"

    custom_origin_config {
      origin_protocol_policy = "https-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["SSLv3", "TLSv1.1", "TLSv1.2", "TLSv1"]
    }

    custom_header {
      name  = "fromcloudfront"
      value = "${var.alb_cloudfront_key}"
    }
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.name}"
    compress         = true

    forwarded_values {
      query_string = true
      headers      = var.cloudfront_forward_headers

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  viewer_certificate {
    acm_certificate_arn      = "${var.certificate_arn}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  web_acl_id = "${var.cloudfront_web_acl_id != "" ? var.cloudfront_web_acl_id : ""}"

  lifecycle {
    ignore_changes = ["ordered_cache_behavior", "default_cache_behavior", "origin"]
  }

}
