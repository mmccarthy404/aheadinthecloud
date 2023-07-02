resource "aws_s3_bucket" "logs" {
  bucket = "logs.${var.local.domain}"
}

resource "aws_s3_bucket" "domain" {
  bucket = var.local.domain
}

resource "aws_s3_bucket_logging" "example" {
  bucket = aws_s3_bucket.domain.id

  target_bucket = aws_s3_bucket.logs.id
  target_prefix = "logs/"
}

resource "aws_s3_bucket_website_configuration" "domain" {
  bucket = aws_s3_bucket.domain.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket" "subdomain" {
  bucket = "www.${var.local.domain}"
}

resource "aws_s3_bucket_website_configuration" "subdomain" {
  bucket = aws_s3_bucket.subdomain.id

  redirect_all_requests_to {
    host_name = var.local.domain
    protocol  = "http"
  }
}