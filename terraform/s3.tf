resource "aws_s3_bucket" "logs" {
  bucket = "logs.${var.local.domain}"
}

resource "aws_s3_bucket" "domain" {
  bucket = var.local.domain
}

resource "aws_s3_bucket_public_access_block" "domain" {
  bucket = aws_s3_bucket.domain.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read_get_object" {
  bucket = aws_s3_bucket.domain.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Principal = "*"
        Effect    = "Allow"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${var.local.domain}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_logging" "domain" {
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
    key = "404/index.html"
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