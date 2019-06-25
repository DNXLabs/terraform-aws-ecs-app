resource "aws_cloudfront_distribution" "default" {
  enabled         = true
  is_ipv6_enabled = true
  comment         = "${var.name}"
  aliases         = ["${var.hostname}", "${var.hostname_blue}"]

  # multiple hosts not yet supported on ALB Listener Rules until this PR
  # https://github.com/terraform-providers/terraform-provider-aws/pull/8268
  # is merged. It's done manually for now, so we only support one hostname
  # and ignore changes to avoid rolling back manual changes
  # aliases         = ["${concat(split(",", var.hostname), var.hostname_blue)}"]
  lifecycle {
    ignore_changes = ["aliases"]
  }

  price_class = "PriceClass_All"

  origin {
    domain_name = "${aws_route53_record.hostname_origin.name}"
    origin_id   = "${var.name}"

    custom_origin_config {
      origin_protocol_policy = "https-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["SSLv3", "TLSv1.1", "TLSv1.2", "TLSv1"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.name}"
    compress         = true

    forwarded_values {
      query_string = true
      headers      = ["*"]

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
}
