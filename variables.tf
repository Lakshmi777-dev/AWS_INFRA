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

variable "key_name" {
  description = "Name of the SSH key pair"

}

variable "trails" {
  type = list(object({
    name      = string
    s3_bucket = string
  }))
  description = "A list of CloudTrail configurations with their respective S3 bucket names."
}

variable "log_group_name" {
  type = string
  description = "name of log-group"
}


variable "retention_in_days" {
  type        = number
  description = "Number of retention days for the logs (0 means keep indefinitely)"
  default     = null
}

# Variables for metric filters in cloudwatch log-group
variable "metric_filters" {
  description = "Map of metric filters for CloudWatch Logs"
  type = map(object({
    log_group_key    = string
    filter_pattern   = string
    metric_name      = string
    metric_namespace = string
    metric_value     = string
  }))
}

# Variables for CloudWatch alarms for Infra Changes
variable "metric_alarms" {
  description = "A map of metric alarms to be created"
  type = map(object({
    metric_name         = string
    metric_namespace    = string
    alarm_name          = string
    comparison_operator = string
    evaluation_periods  = number
    period              = number
    statistic           = string
    threshold           = number
    description         = string
    sns_topic           = string
    treat_missing_data  = string
  }))
}

# Variable for EC2 CPU alarm configuration
variable "ec2_cpu_alarm_config" {
  description = "Configuration for EC2 CPU Utilization alarms"
  type = map(object({
    alert_level           = string
    # instance_id           = string
    comparison_operator   = string
    evaluation_periods    = number
    metric_name           = string
    namespace             = string
    period                = number
    statistic             = string
    threshold             = number
    actions_enabled       = bool
    sns_topic            = string
    description = string
    ok_actions = string
  }))
  default = {}
}

variable "ec2_status_check_alarm_config" {
  description = "Configuration for EC2 Instance and System Status Check Failure alarms"
  type = map(object({
    alert_level           = string
    comparison_operator   = string
    evaluation_periods    = number
    metric_name           = string
    namespace             = string
    period                = number
    status_check_statistic             = string
    threshold             = number
    actions_enabled       = bool
    sns_topic             = string
    description           = string
    ok_actions            = string
  }))
  default = {}
}

variable "sns_topic_arns" {
  description = "Map of SNS topic names to their ARNs"
  type        = map(string)
}

variable "sns_topics" {
  description = "A map of SNS topics to be created, with the topic name as the key and a map of tags as the value"
  type = map(object({
    tags = map(string)
  }))
}

variable "sns_subscriptions" {
  description = "A map of SNS subscriptions to be created, grouped by topic name"
  type = map(map(object({
    protocol = string
    endpoint = string
  })))
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

variable "backup_vaults" {
  description = "A map of backup vaults to create"
  type = map(object({
    name = string
    tags = map(string)
  }))
}

variable "backup_plans" {
  description = "A map of backup plans to create"
  type = map(object({
    name               = string
    rule_name          = string
    target_vault_name  = string
    schedule           = string
    completion_window  = number
    cold_storage_after = number
    delete_after       = number
  }))
}

variable "backup_selections" {
  description = "A map of backup selections to create"
  type = map(object({
    iam_role_arn  = string
    name          = string
    plan_name     = string
    resources     = list(string)
  }))
}
