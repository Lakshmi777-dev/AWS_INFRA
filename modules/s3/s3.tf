# Retrieve the AWS account ID dynamically
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "s3_bucket" {
  for_each = var.s3_buckets
  bucket   = each.key

  force_destroy = true # Allows deletion of non-empty buckets
  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name = each.key
  }
}

resource "aws_s3_bucket_public_access_block" "cloudtrail_bucket_public_access" {
  for_each = var.s3_buckets

  bucket = aws_s3_bucket.s3_bucket[each.key].id

  block_public_acls       = each.value.public_access_block.block_public_acls
  ignore_public_acls      = each.value.public_access_block.ignore_public_acls
  block_public_policy     = each.value.public_access_block.block_public_policy
  restrict_public_buckets = each.value.public_access_block.restrict_public_buckets
}

resource "aws_s3_bucket_versioning" "versioning" {
  for_each = { for name, config in var.s3_buckets : name => config if config.versioning }

  bucket = aws_s3_bucket.s3_bucket[each.key].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  for_each = { for name, config in var.s3_buckets : name => config if config.encryption }

  bucket = aws_s3_bucket.s3_bucket[each.key].id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # Change to "aws:kms" for KMS encryption if needed
    }
  }
}

resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy" {
  bucket = "zarthi-dev-vpc-flow-logs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck20150319"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = "arn:aws:s3:::zarthi-dev-vpc-flow-logs"
      },
      {
        Sid    = "AWSCloudTrailWrite20150319"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "arn:aws:s3:::zarthi-dev-vpc-flow-logs/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
  depends_on = [
    aws_s3_bucket.s3_bucket["zarthi-dev-vpc-flow-logs"]
  ]
}

# resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy1" {
#   bucket = "example-bucket-198000"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "AWSCloudTrailAclCheck20150319"
#         Effect = "Allow"
#         Principal = {
#           Service = "cloudtrail.amazonaws.com"
#         }
#         Action   = "s3:GetBucketAcl"
#         Resource = "arn:aws:s3:::example-bucket-198000"
#       },
#       {
#         Sid    = "AWSCloudTrailWrite20150319"
#         Effect = "Allow"
#         Principal = {
#           Service = "cloudtrail.amazonaws.com"
#         }
#         Action   = "s3:PutObject"
#         Resource = "arn:aws:s3:::example-bucket-198000/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
#         Condition = {
#           StringEquals = {
#             "s3:x-amz-acl" = "bucket-owner-full-control"
#           }
#         }
#       }
#     ]
#   })
# }
