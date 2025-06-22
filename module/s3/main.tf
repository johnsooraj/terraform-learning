locals {
  filter_archive_bucket_names = [
    for name in var.s3_bucket_names : name
    if can(regex("archive", name))
  ]
}




# Creates S3 buckets from list of names
resource "aws_s3_bucket" "s3_bucket" {
  count         = length(var.s3_bucket_names)
  bucket        = var.s3_bucket_names[count.index]
  force_destroy = true
  tags          = var.tags
}

# Define S3 bucket encryption - start
resource "aws_kms_key" "s3_bucket_encryption" {
  count                   = var.create_new_bucket ? length(var.s3_bucket_names) : 0
  description             = "KMS key for S3 bucket encryption"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "name" {
  count = var.create_new_bucket ? length(var.s3_bucket_names) : 0
  # This is the S3 bucket ID to which the encryption configuration will be applied
  bucket = aws_s3_bucket.s3_bucket[count.index].id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3_bucket_encryption[count.index].arn
      sse_algorithm     = "aws:kms"
    }
  }
}
# Define S3 bucket encryption - end

# Define S3 bucket intelligent tiering - start
resource "aws_s3_bucket_intelligent_tiering_configuration" "s3_bucket_intelligent_tiering" {

  # Tireing is only required for archive buckets
  count = var.create_new_bucket ? length(local.filter_archive_bucket_names) : 0
  bucket = aws_s3_bucket.s3_bucket[
    index(var.s3_bucket_names, local.filter_archive_bucket_names[count.index])
  ].id
  name = "IntelligentTieringConfig"
  tiering {
    days        = 180
    access_tier = "DEEP_ARCHIVE_ACCESS"
  }
  tiering {
    days        = 90
    access_tier = "ARCHIVE_ACCESS"
  }
}
# Define S3 bucket intelligent tiering - end
