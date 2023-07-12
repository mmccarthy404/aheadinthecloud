resource "aws_s3_bucket" "logs" {
  bucket = join("-", [
    var.local.logs_bucket_prefix,
    "logs",
    var.local.region,
    data.aws_caller_identity.current.account_id,
    var.local.env
  ])

  force_destroy = !var.local.keep_log_bucket_on_destroy
}

resource "aws_s3_bucket" "domain" {
  bucket = join("-", [
    var.local.domain_bucket_prefix,
    var.local.region,
    data.aws_caller_identity.current.account_id,
    var.local.env
  ])
}

resource "aws_s3_bucket_logging" "domain" {
  bucket = aws_s3_bucket.domain.id

  target_bucket = aws_s3_bucket.logs.id
  target_prefix = var.local.s3_logging_prefix
}

resource "aws_s3_bucket_website_configuration" "domain" {
  bucket = aws_s3_bucket.domain.id

  index_document {
    suffix = var.local.index_doc
  }

  error_document {
    key = var.local.error_doc
  }
}