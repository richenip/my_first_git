resource "aws_s3_bucket" "static" {
  bucket = local.static_bucket_name

  tags = {
    Environment = terraform.workspace
    Project     = var.project_tag_name
  }
}

resource "aws_s3_bucket_acl" "static" {
  bucket = aws_s3_bucket.static.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "static" {
  bucket = aws_s3_bucket.static.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_cors_configuration" "static" {
  bucket = aws_s3_bucket.static.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = [var.app_hostname]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_policy" "static" {
  bucket = aws_s3_bucket.static.id
  policy = <<POLICY
  {
    "Version": "2008-10-17",
    "Id": "Policy1404382222726",
    "Statement": [
        {
            "Sid": "Stmt1404382216664",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": "s3:GetObject",
            "Resource": "*"
        }
    ]
  }
  POLICY
}
