data "aws_caller_identity" "current" {}

resource "aws_kms_key" "ebs_key" {
  description = "KMS key for EBS volume encryption"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })
  
  enable_key_rotation = true
  deletion_window_in_days = 30
}
