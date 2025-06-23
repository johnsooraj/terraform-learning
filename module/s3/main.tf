
# Creates S3 buckets from list of names
resource "aws_s3_bucket" "s3_bucket" {
  count         = var.create_new_bucket ? length(local.all_buckets) : 0
  bucket        = local.all_buckets[count.index]
  force_destroy = true
  tags          = var.tags
}

# Define S3 bucket encryption - start
resource "aws_kms_key" "s3_bucket_encryption" {
  count                   = var.create_new_bucket ? length(local.all_buckets) : 0
  description             = "KMS key for S3 bucket encryption"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_encryption" {
  count = var.create_new_bucket ? length(local.all_buckets) : 0
  # This is the S3 bucket ID to which the encryption configuration will be applied
  bucket = local.all_buckets[count.index]
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
  count  = var.create_new_bucket ? length(local.archive_buckets) : 0 // if any bucket, then create
  bucket = local.archive_buckets[count.index]
  name   = "IntelligentTieringConfig"
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

# Define S3 bucket versioning - start
resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
  count = var.create_new_bucket ? length(local.all_buckets) : 0
  # This is the S3 bucket ID to which the versioning configuration will be applied
  bucket = local.all_buckets[count.index]
  versioning_configuration {
    status = "Enabled"
  }
}
# Define S3 bucket versioning - end


# S3 Policy to data bucket
resource "aws_s3_bucket_policy" "s3_data_bucket_policy" {
  count  = var.create_new_bucket ? length(local.data_buckets) : 0
  bucket = local.data_buckets[count.index]
  policy = data.aws_iam_policy_document.s3_bucket_policy[count.index].json
}


# S3 Public Access Block
resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  count = var.create_new_bucket ? length(local.all_buckets) : 0
  # This is the S3 bucket ID to which the public access block configuration will be applied
  bucket                  = local.all_buckets[count.index]
  block_public_acls       = false
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  depends_on = [
    aws_s3_bucket.s3_bucket
  ]
}
