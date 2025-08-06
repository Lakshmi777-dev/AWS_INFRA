output "security_group_ids" {
  description = "Map of SG names to their IDs"
  value       = module.security_groups.security_group_ids
}

output "jenkins_sg_id" {
  description = "ID of Jenkins security group"
  value       = module.security_groups.security_group_ids["zarthi-dev-jenkins-sg"]
}


output "jenkins_public_ip" {
  description = "Public IP of Jenkins EC2 instance"
  value       = module.ec2.instance_public_ips["jenkins-server"]
}

output "elasticsearch_public_ip" {
  value = try(module.ec2["elasticsearch-server"].public_ip, "not found")
}

output "elasticsearch_url" {
  value = "http://${try(module.ec2["elasticsearch-server"].public_ip, "0.0.0.0")}:9200"
}


output "redis_public_ip" {
  description = "Public IP of Redis EC2 instance"
  value       = try(module.ec2.instance_public_ips["redis-server"], "not found")
}

output "redis_url" {
  description = "Redis connection URL"
  value       = "${try(module.ec2.instance_public_ips["redis-server"], "0.0.0.0")}:6379"
}

output "mongodb_public_ip" {
  description = "Public IP of MongoDB EC2 instance"
  value       = try(module.ec2.instance_public_ips["mongodb-server"], "not found")
}

output "mongodb_url" {
  description = "MongoDB connection URL"
  value       = "mongodb://${try(module.ec2.instance_public_ips["mongodb-server"], "0.0.0.0")}:27017"
} 

# Pritunl VPN Server Outputs

output "pritunl_public_ip" {
  description = "Public IP of Pritunl EC2 instance"
  value       = try(module.ec2.instance_public_ips["pritunl-server"], "not found")
}

output "pritunl_url" {
  description = "URL to access the Pritunl web interface"
  value       = "https://${try(module.ec2.instance_public_ips["pritunl-server"], "0.0.0.0")}"
}

output "pritunl_ssh_command" {
  description = "SSH command to connect to the Pritunl server"
  value       = "ssh -i pritunl-server-key.pem ubuntu@${try(module.ec2.instance_public_ips["pritunl-server"], "0.0.0.0")}"
}

output "pritunl_initial_setup_instructions" {
  description = "Initial setup steps for accessing and configuring the Pritunl server"
  value = <<EOF
Access the Pritunl Web UI at:
https://${try(module.ec2.instance_public_ips["pritunl-server"], "SERVER_IP")}

Run the following to get the setup key:
ssh -i pritunl-server-key.pem ubuntu@${try(module.ec2.instance_public_ips["pritunl-server"], "SERVER_IP")} "sudo pritunl setup-key"

Get the default admin password:
ssh -i pritunl-server-key.pem ubuntu@${try(module.ec2.instance_public_ips["pritunl-server"], "SERVER_IP")} "sudo pritunl default-password"

⚠️ Important: Change the default admin password on first login.
EOF
}

output "pritunl_sg_id" {
  description = "Security Group ID of the Pritunl EC2 instance"
  value       = module.security_groups.security_group_ids["zarthi-dev-pritunl-sg"]
}
output "pritunl_alb_dns" {
  value = module.alb.alb_dns_name
}

