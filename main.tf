# Terraform initialization for AWS
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-south-1"
}

locals {
  // Customazing bucket names
  s3_data_bucket        = var.create_new_bucket ? format("%s-%s-%s", var.project_name, var.workspace_name, var.bucket_names[0]) : "${var.priject_name}-data"
  s3_archive_bucket     = var.create_new_bucket ? format("%s-%s-%s", var.project_name, var.workspace_name, var.bucket_names[1]) : "${var.priject_name}-archive"
  prefixed_bucket_names = [for name in var.bucket_names : var.create_new_bucket ? format("%s-%s-%s", var.project_name, var.workspace_name, name) : "${var.project_name}-${name}"]
}

# Defning the S3 bucket module
module "s3bucket" {
  source            = "./module/s3"
  s3_bucket_names   = local.prefixed_bucket_names // array values
  create_new_bucket = var.create_new_bucket
  tags = {
    Environment = "Dev"
    Project     = "MyProject"
  }
}
