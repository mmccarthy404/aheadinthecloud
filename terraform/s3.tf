resource "aws_s3_bucket" "logs" {
  bucket = join("-", [
    var.local.logs_bucket_prefix,
    var.local.region,
    data.aws_caller_identity.current.account_id,
    var.local.env
  ])

  force_destroy = !var.local.keep_log_bucket_on_destroy
}

data "aws_iam_policy_document" "logs" {
  statement {
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.logs.arn}/${var.local.s3_logging_prefix}*"]

    principals {
      type        = "Service"
      identifiers = ["logging.s3.amazonaws.com"]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.domain.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

resource "aws_s3_bucket_policy" "logs" {
  bucket = aws_s3_bucket.logs.id
  policy = data.aws_iam_policy_document.logs.json
}

resource "aws_s3_bucket_ownership_controls" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
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

data "aws_iam_policy_document" "oac" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.domain.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [module.cloudfront.cloudfront_distribution_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "domain" {
  bucket = aws_s3_bucket.domain.id
  policy = data.aws_iam_policy_document.oac.json
}