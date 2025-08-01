variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "vpcs" {
  description = "Map of VPC configurations"
  type = map(object({
    vpc_name           = string
    vpc_cidr_block     = string
    public_subnets     = list(string)
    private_subnets    = list(string)
    create_nat_gateway = bool
    enable_flow_logs   = bool
    # flow_log_bucket = list(string)
  }))
}

# variable "enable_flow_logs" {
#   description = "Whether to enable VPC flow logs"
#   type        = bool
#   default     = false  # Default value
# }

variable "flow_log_bucket" {
  description = "The name of the S3 bucket to store VPC flow logs"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "instances" {
  description = "List of configurations for each EC2 instance (Linux or Windows)"
  type = list(object({
    vpc_key                   = string
    ami_id                    = string
    instance_type             = string
    subnet_index              = number
    name                      = string
    subnet_type               = string
    ebs_volume_type           = string
    ebs_volume_size           = number
    security_group_name       = string
    key_name              = string 
    secondary_ebs_volume_type = optional(string)
    secondary_ebs_volume_size = optional(number)
    os_type                   = string
    associate_eip             = optional(bool)
  }))
}

variable "security_groups_ids" {
  description = "List of security group configurations."
  type = list(object({
    name    = string
    vpc_key = string
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


variable "selected_vpc" {
  description = "The VPC environment to create resources in (prod/dev)."
  type        = string
  default     = "" # Change this to "dev" as needed
}



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
