resource "aws_s3_bucket" "codebuild-source" {
  bucket = "ort-codebuild-source"
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "codebuild-source" {
  bucket = "${aws_s3_bucket.codebuild-source.id}"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
