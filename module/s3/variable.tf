variable "s3_bucket_names" {
  description = "The name of the S3 bucket to create."
  type        = list(string)

}

variable "tags" {
  description = "A map of tags to assign to the S3 bucket."
  type        = map(string)
  default     = {}

}

variable "create_new_bucket" {
  description = "Flag to indicate whether to create a new S3 bucket or use an existing one."
  type        = bool
  default     = true

}
