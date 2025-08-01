variable "vpc_ids" {
  description = "Map of VPC IDs to be used for security group association"
  type        = map(string)
}

variable "security_groups" {
  description = "List of security group configurations"
  type = list(object({
    name          = string
    vpc_key       = string
    ingress_rules = list(object({
      description = string
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    egress_rules = list(object({
      description = string
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  }))
}
