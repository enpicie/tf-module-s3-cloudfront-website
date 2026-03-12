variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "naming_prefix" {
  description = "Prefix used for resource names"
  type        = string
}

variable "s3_bucket_id" {
  description = "ID of the S3 bucket to use as the CloudFront origin"
  type        = string
}

variable "s3_bucket_domain_name" {
  description = "Regional domain name of the S3 bucket"
  type        = string
}

variable "domain_name" {
  description = "Custom domain name (e.g. app.example.com). Required if acm_certificate_arn is set."
  type        = string
  default     = null
}

variable "acm_certificate_arn" {
  description = "ARN of an ACM certificate in us-east-1 for the custom domain. Required if domain_name is set."
  type        = string
  default     = null
}
