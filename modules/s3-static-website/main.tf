####################################################
# S3 static website bucket
####################################################
resource "aws_s3_bucket" "s3-static-website" {
  bucket = var.bucket_name
  tags = merge(
    var.common_tags,
    {
      Name = var.bucket_name
    }
  )
}

####################################################
# Block all public access (CloudFront uses OAC)
####################################################
resource "aws_s3_bucket_public_access_block" "static_site_bucket_public_access" {
  bucket = aws_s3_bucket.s3-static-website.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

