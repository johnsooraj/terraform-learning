# ? Behaviour of the existing S3 Bucket, if the create_new_bucket is set to false
# Getting the existing S3 bucket details as data source
data "aws_s3_bucket" "existing_s3_bucket" {
  count  = var.create_new_bucket ? 0 : length(var.s3_bucket_names)
  bucket = var.s3_bucket_names[count.index]
}

# filter_archive_buckets
locals {
  data_buckets = [
    for bucket in var.s3_bucket_names : bucket
    if can(regex(".*data.*", bucket))
  ]
 
  archive_buckets = [
    for bucket in var.s3_bucket_names : bucket
    if !can(regex(".*data.*", bucket))
  ]

  all_buckets = tolist(concat(local.archive_buckets))
}

data "aws_iam_policy_document" "s3_bucket_policy" {
  count = var.create_new_bucket ? length(local.all_buckets) : 0

  statement {
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "${aws_s3_bucket.s3_bucket[count.index].arn}/*",
      aws_s3_bucket.s3_bucket[count.index].arn
    ]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}
