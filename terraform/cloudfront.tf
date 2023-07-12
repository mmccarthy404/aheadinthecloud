module "cloudfront" {
  source = "terraform-aws-modules/cloudfront/aws"

  aliases = ["${var.local.subdomain}.${var.local.domain}"]

  comment             = "aheadinthecloud.com distribution"
  enabled             = true
  http_version        = "http2and3"
  is_ipv6_enabled     = true
  price_class         = "PriceClass_100"
  retain_on_delete    = false
  wait_for_deployment = false

  # When you enable additional metrics for a distribution, CloudFront sends up to 8 metrics to CloudWatch in the US East (N. Virginia) Region.
  # This rate is charged only once per month, per metric (up to 8 metrics per distribution).
  create_monitoring_subscription = true

  create_origin_access_control = true
  origin_access_control = {
    s3_oac = {
      description      = "cloudfront access to s3"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  logging_config = {
    bucket = aws_s3_bucket.logs.bucket_domain_name
    prefix = var.local.cloudfront_logging_prefix
  }

  origin = {
    s3 = {
      domain_name           = aws_s3_bucket.domain.bucket_domain_name
      origin_access_control = "s3_oac" # key in `origin_access_control`
    }
  }

  default_cache_behavior = {
    target_origin_id       = "s3"
    viewer_protocol_policy = "allow-all"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true
  }

  ordered_cache_behavior = [
    {
      path_pattern           = "*"
      target_origin_id       = "s3"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods  = ["GET", "HEAD"]
      compress        = true
      query_string    = true
    }
  ]

  viewer_certificate = {
    acm_certificate_arn      = aws_acm_certificate_validation.this.certificate_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}