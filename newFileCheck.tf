resource "aws_s3_bucket" "km_blob_storage" {
  #zs:skip=AC_AWS_0207 ignore
  #zs:skip=AC_AWS_0497 ignore 
  #zs:skip=AC_AWS_0214 ignore
  bucket = "km-blob-storage-${var.environment}"
  acl    = "private"
  tags = merge(var.default_tags, {
    name = "km_blob_storage_${var.environment}"
  })
}

resource "aws_s3_bucket" "km_public_blob" {
  bucket = "km-public-blob"
}

resource "aws_s3_bucket_public_access_block" "km_public_blob" {
  bucket = aws_s3_bucket.km_public_blob.id

  block_public_acls   = false
  block_public_policy = false
}
