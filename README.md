# Terraform Learning

This repository contains Terraform configurations for managing AWS resources.

## Overview

The main focus of this project is to provision and manage AWS S3 buckets using Terraform. The configuration is defined in `main.tf`.

## Features

- Creation of AWS S3 buckets
- S3 bucket encryption enabled
- Intelligent Tiering storage class configuration

## S3 Bucket Encryption

S3 bucket encryption ensures that all objects stored in the bucket are automatically encrypted at rest using AWS-managed keys (SSE-S3) or customer-managed keys (SSE-KMS). This enhances data security and helps meet compliance requirements.

**Example in Terraform:**
```hcl
resource "aws_s3_bucket" "example" {
    bucket = "my-example-bucket"

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }
}
```

## S3 Intelligent Tiering

S3 Intelligent-Tiering is a storage class that automatically moves data between two access tiers (frequent and infrequent) based on changing access patterns. This helps optimize storage costs without impacting performance.

**Example in Terraform:**
```hcl
resource "aws_s3_bucket" "example" {
    bucket = "my-example-bucket"

    lifecycle_rule {
        id      = "intelligent-tiering"
        enabled = true

        transition {
            days          = 0
            storage_class = "INTELLIGENT_TIERING"
        }
    }
}
```

## Usage

1. Clone the repository.
2. Update variables as needed.
3. Run `terraform init` and `terraform apply`.

---

For more details, see the [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket).