variable "s3_buckets" {
  description = "Map of S3 buckets to create with their configurations"
  type = map(object({
    public_access_block = object({
      block_public_acls       = bool
      ignore_public_acls      = bool
      block_public_policy     = bool
      restrict_public_buckets = bool
    })
    versioning   = optional(bool)
    encryption   = optional(bool)
    apply_policy = optional(bool)
    policy       = optional(string) # This line ensures a policy can be provided
  }))
}


# variable "account_id" {
#   description = "The AWS account ID"
#   type        = string
# }
