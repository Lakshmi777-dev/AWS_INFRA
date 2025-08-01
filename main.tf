module "vpc" {
  source = "./modules/vpc"

  for_each = var.vpcs

  vpc_name           = each.value.vpc_name
  cidr_block         = each.value.vpc_cidr_block
  public_subnets     = each.value.public_subnets
  private_subnets    = each.value.private_subnets
  azs                = var.availability_zones
  create_nat_gateway = each.value.create_nat_gateway
  enable_flow_logs   = each.value.enable_flow_logs
  flow_log_bucket    = var.flow_log_bucket
}

module "ec2" {
  source    = "./modules/ec2"
  instances = var.instances
  vpcs      = var.vpcs
  # Map of key names per instance
  key_names = { for name, kp in module.key_pair : name => kp.key_name }

  # Pass subnet IDs grouped by VPC keys
  public_subnet_ids  = { for vpc_key, vpc in module.vpc : vpc_key => vpc.public_subnet_ids }
  private_subnet_ids = { for vpc_key, vpc in module.vpc : vpc_key => vpc.private_subnet_ids }

  # Pass the security group IDs from the security_groups module
  security_groups = module.security_groups.security_group_ids
}

module "key_pair" {
  source   = "./modules/key_pair"

  for_each = { for instance in var.instances : instance.name => instance }

  key_name = "${each.value.name}-key"
}

module "security_groups" {
  source = "./modules/security_groups"

  vpc_ids         = { for vpc_key, vpc_module in module.vpc : vpc_key => vpc_module.vpc_id }
  security_groups = var.security_groups_ids
}

module "s3_buckets" {
  source     = "./modules/s3"
  s3_buckets = var.s3_buckets
}




