output "s3_bucket_names" {
  description = "values of the S3 bucket names created"
  value       = [for bucket in aws_s3_bucket.s3_bucket : bucket.bucket]
}

output "s3_bucket_arns" {
  description = "ARNs of the S3 buckets created"
  value       = [for bucket in aws_s3_bucket.s3_bucket : bucket.arn]
}

output "bucket_names_map" {
  value = { for k, b in aws_s3_bucket.s3_bucket : k => b.bucket }
}