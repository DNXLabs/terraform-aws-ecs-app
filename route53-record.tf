data "aws_route53_zone" "selected" {
  count = var.alb_only && var.hostname_create ? 1 : 0
  name  = var.hosted_zone
}

resource "aws_route53_record" "hostname" {
  count   = var.alb_only && var.hostname_create ? 1 : 0
  zone_id = data.aws_route53_zone.selected.*.zone_id[0]
  name    = var.hostname
  type    = "CNAME"
  ttl     = "300"
  records = list(var.alb_dns_name)
}