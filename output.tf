
// Terraform propaget the output from S3 bucket module to the main module
// Then only root can access and print value in console
output "s3_bucket_names" {
  description = "The names of the S3 buckets created."
  value       = module.s3bucket.s3_bucket_names
}

output "s3_bucket_arns" {
  description = "values of the S3 bucket ARNs created"
  value       = module.s3bucket.s3_bucket_arns
}
