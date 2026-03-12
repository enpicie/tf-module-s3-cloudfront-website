variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}

variable "bucket_name" {
  description = "Name of the S3 bucket to create for hosting the static website"
  type        = string
}
