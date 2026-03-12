variable "website_name" {
  description = "Name used for the S3 bucket and as a naming prefix for all resources"
  type        = string
}

variable "source_files" {
  description = "Path to the static website build output directory (e.g. ./dist)"
  type        = string
}

variable "common_tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "domain_name" {
  description = "Custom domain name (e.g. app.example.com). Required if acm_certificate_arn is set."
  type        = string
  default     = null
}

variable "acm_certificate_arn" {
  description = "ARN of an ACM certificate in us-east-1 for the custom domain. Must be in us-east-1 regardless of your stack region."
  type        = string
  default     = null
}
