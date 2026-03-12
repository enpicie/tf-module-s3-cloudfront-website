output "cloudfront_domain_name" {
  description = "CloudFront distribution domain — use this as your website URL"
  value       = module.cloudfront.cloudfront_distribution_domain_name
}

output "s3_bucket_id" {
  description = "S3 bucket id"
  value       = module.s3_website.static_website_id
}

output "bucket_name" {
  description = "S3 bucket name"
  value       = module.s3_website.bucket_name
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = module.s3_website.static_website_arn
}

output "cloudfront_distribution_arn" {
  description = "CloudFront distribution ARN"
  value       = module.cloudfront.cloudfront_distribution_arn
}

output "cloudfront_hosted_zone_id" {
  description = "CloudFront hosted zone ID — use this for Route53 alias records in your DNS repo"
  value       = module.cloudfront.cloudfront_hosted_zone_id
}
