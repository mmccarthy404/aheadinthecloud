resource "aws_s3_bucket" "logs" {
  bucket = var.local.log_bucket

  force_destroy = !var.local.keep_log_bucket_on_destroy
}

resource "aws_s3_bucket" "domain" {
  bucket = var.local.domain
}

resource "aws_s3_bucket_public_access_block" "domain" {
  bucket = aws_s3_bucket.domain.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
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