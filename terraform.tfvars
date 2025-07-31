#FOR LINUX USE THIS AMI = "ami-0e0e417dfa2028266"
#FOR UBUNTU SERVER 22.04 USE THIS AMI = "ami-09b0a86a2c84101e1"
#FOR WINDOWS USE THIS AMI = "ami-0c0d49e8adba807ec"

aws_region     = "ap-south-1"

# VPC configurations
vpcs = {
  "prod" = {
    vpc_name           = "Rabiesevin-prod-vpc"
    vpc_cidr_block     = "10.100.0.0/16"
    public_subnets     = ["10.100.0.0/20"]
    private_subnets    = ["10.100.32.0/20"]
    create_nat_gateway = true
    enable_flow_logs = true
    flow_log_bucket = "rabiesevin-prod-vpc-flow-logs"
  }
}

availability_zones = ["ap-south-1a", "ap-south-1b"]

# VPC Flow logs bucket
flow_log_bucket = [
  "rabiesevin-prod-vpc-flow-logs"
]

# keypair
key_name = "rwin-prod"

# EC2 servers list
instances = [
  {
    vpc_key             = "prod"
    ami_id              = "ami-09b0a86a2c84101e1" # Linux AMI ID
    instance_type       = "m5.xlarge"
    subnet_index        = 0
    name                = "API-Gateway"
    subnet_type         = "public"
    ebs_volume_type     = "gp3"
    ebs_volume_size     = 250
    security_group_name = "rwinprod-apigw-sg"
    associate_eip       = true
    os_type             = "linux"
    #secondary_ebs_volume_type  = "gp3"
    #secondary_ebs_volume_size  = "1"
  },
  { 
    vpc_key         = "prod"
    ami_id          = "ami-0c0d49e8adba807ec" # Windows AMI ID
    instance_type   = "m5.xlarge"
    subnet_index    = 0
    name            = "windows-server"
    subnet_type     = "public"
    ebs_volume_type = "gp3"
    ebs_volume_size = 250
    security_group_name = "rwinprod-win-sg"
    associate_eip       = true
    os_type             = "windows"
    #secondary_ebs_volume_type  = "gp3"
    #secondary_ebs_volume_size  = "1"
  }
]

# Security group configurations (combined)
# SG FOR API-Gateway server
security_groups_ids = [
  {
    name    = "rwinprod-apigw-sg"
    vpc_key = "prod"
    ingress_rules = [
      {
        description = "Allow SSH Centilytics"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["106.51.116.241/32"]
      },
      {
        description = "SSH pashuevin-nonprod appsever"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["13.233.69.76/32"]
      },
      {
        description = "Dhanush-office-1"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["202.53.95.194/32"]
      },
      {
        description = "Dhanush-office-2"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["202.153.37.82/32"]
      },
      {
        description = "Allow HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "Allow HTTPS"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "Grafana access-Centilytics"
        from_port   = 3000
        to_port     = 3000
        protocol    = "tcp"
        cidr_blocks = ["106.51.116.241/32"]
      },
      {
        description = "Grafana access-Dhanush-office-1"
        from_port   = 3000
        to_port     = 3000
        protocol    = "tcp"
        cidr_blocks = ["202.53.95.194/32"]
      },
      {
        description = "Grafana access-Dhanush-office-2"
        from_port   = 3000
        to_port     = 3000
        protocol    = "tcp"
        cidr_blocks = ["202.153.37.82/32"]
      }
    ]
    egress_rules = [
      {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  },
# SG FOR windows server
  {
    name          = "rwinprod-win-sg"
    vpc_key       = "prod"
    ingress_rules = [
      {
        description = "Allow RDP access for centilytics IPs"
        from_port   = 3389
        to_port     = 3389
        protocol    = "tcp"
        cidr_blocks = ["223.182.209.226/32"]
      },
      {
        description = "Allow RDP access for Dhanush IPs"
        from_port   = 3389
        to_port     = 3389
        protocol    = "tcp"
        cidr_blocks = ["202.53.95.194/32", "202.153.37.82/32"]
      }
    ]
    egress_rules = [
      {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
]

# S3 bucket configs
s3_buckets = {
  "rabies-prod-cloudtrail-logs" = {
    public_access_block = {
      block_public_acls       = true
      ignore_public_acls      = true
      block_public_policy     = true
      restrict_public_buckets = true
    }
    versioning   = true
    encryption   = true
    apply_policy = true
  },
  "rabiesevin-prod-vpc-flow-logs" = {
    public_access_block = {
      block_public_acls       = true
      ignore_public_acls      = true
      block_public_policy     = true
      restrict_public_buckets = true
    }
    versioning   = true
    encryption   = true
    apply_policy = false
    bucket_logging      = false
  }
}
