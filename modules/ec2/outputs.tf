output "ec2_instance_ids" {
  description = "Map of instance IDs created"
  value       = { for idx, instance in aws_instance.ec2_instance : idx => instance.id }
}

output "ec2_instance_public_ips" {
  description = "Map of public IP addresses for instances (if assigned)"
  value       = { for idx, instance in aws_instance.ec2_instance : idx => instance.public_ip }
}

output "ec2_instance_private_ips" {
  description = "Map of private IP addresses for all instances"
  value       = { for idx, instance in aws_instance.ec2_instance : idx => instance.private_ip }
}

output "elastic_ip_addresses" {
  value       = [for ip in aws_eip.elastic_ip : ip.public_ip if ip.public_ip != ""]
  description = "List of Elastic IP addresses associated with instances"
}

output "instance_public_ips" {
  description = "Public IPs of EC2 instances (keyed by instance name)"
  value = {
    for key, instance in aws_instance.ec2_instance :
    var.instances[key].name => instance.public_ip
  }
}
output "pritunl_instance_id" {
  value = values(aws_instance.ec2_instance)[0].id
}

