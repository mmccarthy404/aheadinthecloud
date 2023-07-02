data "aws_route53_zone" "selected" {
  name = var.local.domain
}

resource "aws_route53_record" "domain" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.local.domain
  type    = "A"

  alias {
    name                   = aws_s3_bucket_website_configuration.domain.website_domain
    zone_id                = aws_s3_bucket.domain.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "subdomain" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "www.${var.local.domain}"
  type    = "A"

  alias {
    name                   = aws_s3_bucket_website_configuration.subdomain.website_domain
    zone_id                = aws_s3_bucket.subdomain.hosted_zone_id
    evaluate_target_health = false
  }
}