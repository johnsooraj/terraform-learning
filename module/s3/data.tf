# ? Behaviour of the existing S3 Bucket, if the create_new_bucket is set to false
# Getting the existing S3 bucket details as data source
data "aws_s3_bucket" "existing_s3_bucket" {
  count  = var.create_new_bucket ? 0 : length(var.s3_bucket_names)
  bucket = var.s3_bucket_names[count.index]
}
