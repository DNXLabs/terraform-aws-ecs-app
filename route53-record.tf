data "aws_route53_zone" "selected" {
  name = "${var.hosted_zone}"
}

resource "aws_route53_record" "hostname" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "${var.hostname}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_cloudfront_distribution.default.domain_name}"]
}

resource "aws_route53_record" "hostname_blue" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "${var.hostname_blue}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_cloudfront_distribution.default.domain_name}"]
}

resource "aws_route53_record" "hostname_origin" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "${var.hostname_origin}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${var.alb_dns_name}"]
}
