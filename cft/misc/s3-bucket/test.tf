resource "aws_s3_bucket" "mybucket" {
  #zs:skip=AC_AWS_0214 ignore
  #zs:skip=AC_AWS_0497 ignore
  #zs:skip=AC_AWS_0208 ignore
  #zs:skip=AC_AWS_0496 ignore
  #zs:skip=AC_AWS_0214 ignore
  bucket = "mybucket"
  acl = "public"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  #zs:skip=AC_AWS_0214 ignore
  #zs:skip=AC_AWS_0497 ignore
  #zs:skip=AC_AWS_0208 ignore
  #zs:skip=AC_AWS_0496 ignore
  #zs:skip=AC_AWS_0214 ignore
  bucket = aws_s3_bucket.example.id

  block_public_acls   = true
  block_public_policy = true
}

resource "aws_s3_bucket_policy" "b" {
  bucket = aws_s3_bucket.b.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {
        Sid       = "IPAllow"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.b.arn,
          "${aws_s3_bucket.b.arn}/*",
        ]
        Condition = {
          IpAddress = {
            "aws:SourceIp" = "8.8.8.8/32"
          }
        }
      },
    ]
  })
}
