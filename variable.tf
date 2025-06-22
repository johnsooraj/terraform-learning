variable "project_name" {
  description = "The name of the project"
  type        = string

}

variable "bucket_names" {
  description = "List of S3 bucket names to create"
  type        = list(string)
  default     = []

}

variable "priject_name" {
  description = "The name of the project for tagging purposes"
  type        = string
  default     = "default-project"

}

variable "workspace_name" {
  description = "The name of the workspace"
  type        = string
  default     = "default-workspace"

}

variable "create_new_bucket" {
  description = "Flag to create new S3 buckets"
  type        = bool
  default     = true
}
