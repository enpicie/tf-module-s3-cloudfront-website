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
