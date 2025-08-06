variable "name" {
  description = "Base name for resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the ALB"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

variable "domain_name" {
  description = "Domain name for ACM certificate"
  type        = string
}

variable "route53_zone_id" {
  description = "Route 53 Hosted Zone ID"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "ec2_instance_ids" {
  description = "List of EC2 instance IDs to register with with the ALB"
  type        = list(string)
}


