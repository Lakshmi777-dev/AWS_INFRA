output "key_name" {
  description = "The name of the SSH key pair"
  value       = aws_key_pair.key_pair.key_name
}

output "public_key" {
  description = "The public key in OpenSSH format"
  value       = tls_private_key.rsa_4096.public_key_openssh
  sensitive   = true # Mark as sensitive to avoid displaying in logs
}

output "private_key_pem" {
  description = "The private key in PEM format"
  value       = tls_private_key.rsa_4096.private_key_pem
  sensitive   = true # Mark as sensitive to avoid displaying in logs
}

output "private_key_file" {
  description = "The local file path where the private key is saved"
  value       = local_file.private_key.filename
}
