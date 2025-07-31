output "kms_key_id" {
  description = "The KMS key ID used for encrypting EBS volumes"
  value       = aws_kms_key.ebs_key.id
}
