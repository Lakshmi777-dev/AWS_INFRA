output "bucket_names" {
  value       = { for bucket_key, bucket in aws_s3_bucket.s3_bucket : bucket_key => bucket.bucket }
  description = "Map of S3 bucket names by bucket key"
}
