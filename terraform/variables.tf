variable "local" {
  type = object({
    env                        = string
    region                     = string
    domain                     = string
    subdomain                  = string
    index_doc                  = string
    error_doc                  = string
    domain_bucket_prefix       = string
    logs_bucket_prefix         = string
    s3_logging_prefix          = string
    cloudfront_logging_prefix  = string
    keep_log_bucket_on_destroy = bool
    cloudfront_description     = string
  })
}