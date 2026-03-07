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
