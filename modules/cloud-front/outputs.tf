output "cloudfront_distribution_arn" {
  value = aws_cloudfront_distribution.cf-dist.arn
}

output "cloudfront_distribution_domain_name" {
  value = aws_cloudfront_distribution.cf-dist.domain_name
}

output "cloudfront_hosted_zone_id" {
  description = "CloudFront hosted zone ID — use this for Route53 alias records"
  value       = aws_cloudfront_distribution.cf-dist.hosted_zone_id
}
