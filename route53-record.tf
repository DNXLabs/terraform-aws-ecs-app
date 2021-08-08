data "aws_route53_zone" "selected" {
  count        = var.hosted_zone_id == "" && var.alb_only && var.hostname_create ? 1 : 0
  name         = var.hosted_zone
  private_zone = var.hosted_zone_is_internal
}

resource "aws_route53_record" "hostnames" {
  count   = !var.hosted_zone_is_internal && var.alb_only && var.hostname_create && length(var.hostnames) != 0 ? length(var.hostnames) : 0
  zone_id = var.hosted_zone_id == "" ? data.aws_route53_zone.selected.*.zone_id[0] : var.hosted_zone_id
  name    = var.hostnames[count.index]
  type    = "CNAME"
  ttl     = "300"
  records = [var.alb_dns_name]
}

data "aws_lb" "alb_selected" {
  count = var.hosted_zone_is_internal && var.alb_only && var.hostname_create && length(var.hostnames) != 0 ? length(var.hostnames) : 0
  name  = var.alb_name
}

resource "aws_route53_record" "hostnames_internal" {
  count   = var.hosted_zone_is_internal && var.alb_only && var.hostname_create && length(var.hostnames) != 0 ? length(var.hostnames) : 0
  zone_id = var.hosted_zone_id == "" ? data.aws_route53_zone.selected.*.zone_id[0] : var.hosted_zone_id
  name    = var.hostnames[count.index]
  type    = "A"
  alias {
    name                   = data.aws_lb.alb_selected.*.dns_name[0]
    zone_id                = data.aws_lb.alb_selected.*.zone_id[0]
    evaluate_target_health = true
  }
}
