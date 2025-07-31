variable "vpcs" {
  description = "Map of VPC configurations"
  type = map(object({
    vpc_name           = string
    vpc_cidr_block     = string
    public_subnets     = list(string)
    private_subnets    = list(string)
    create_nat_gateway = bool
  }))
}



variable "instances" {
  description = "List of EC2 instance configurations"
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

variable "public_subnet_ids" {
  description = "Map of public subnet IDs by VPC key"
  type        = map(list(string))
}

variable "private_subnet_ids" {
  description = "Map of private subnet IDs by VPC key"
  type        = map(list(string))
}

variable "security_groups" {
  description = "Map of security group IDs by security group name"
  type        = map(string)
}

variable "key_name" {
  description = "Name of the SSH key pair"
}

variable "kms_key_id" {
  type        = string
  description = "KMS key ID for encrypting the volume"
  default     = null
}
