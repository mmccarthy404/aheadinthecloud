local = {
  env                        = "prod"
  region                     = "us-east-1"
  domain                     = "aheadinthecloud.com"
  subdomain                  = "www"
  index_doc                  = "index.html"
  error_doc                  = "404/index.html"
  log_bucket                 = "logs.aheadinthecloud.com"
  s3_logging_prefix          = "s3"
  cloudfront_logging_prefix  = "cloudfront"
  keep_log_bucket_on_destroy = false
}