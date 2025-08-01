#FOR LINUX USE THIS AMI = "ami-0e0e417dfa2028266"
#FOR UBUNTU SERVER 22.04 USE THIS AMI = "ami-09b0a86a2c84101e1"
#FOR WINDOWS USE THIS AMI = "ami-0c0d49e8adba807ec"

aws_region     = "ap-south-1"

# VPC configurations
vpcs = {
  "DEV" = {
    vpc_name           = "zarthi-dev-vpc"
    vpc_cidr_block     = "10.100.0.0/16"
    public_subnets     = ["10.100.0.0/20"]
    private_subnets    = ["10.100.32.0/20"]
    create_nat_gateway = true
    enable_flow_logs = true
    flow_log_bucket = "zarthi-dev-vpc-flow-logs"
  }
}

availability_zones = ["ap-south-1a", "ap-south-1b"]

# VPC Flow logs bucket
flow_log_bucket = [
  "zarthi-dev-vpc-flow-logs"
]

# keypair
#key_name = "rwin-prod"

# EC2 servers list
instances = [
  {
    vpc_key             = "DEV"
    ami_id              = "ami-09b0a86a2c84101e1"
    instance_type       = "t3.micro"
    subnet_index        = 0
    name                = "API-Gateway"
    subnet_type         = "public"
    ebs_volume_type     = "gp3"
    ebs_volume_size     = 250
    security_group_name = "zarthi-dev-apigw-sg"
    associate_eip       = true
    os_type             = "linux"
    key_name            = "API-Gateway-key"
    #secondary_ebs_volume_type  = "gp3"
    #secondary_ebs_volume_size  = "1"
  },
  {
    vpc_key             = "DEV"
    ami_id              = "ami-05b85154f69f6bcb3"
    instance_type       = "t3.micro"
    subnet_index        = 0
    name                = "windows-server"
    subnet_type         = "public"
    ebs_volume_type     = "gp3"
    ebs_volume_size     = 250
    security_group_name = "zarthi-dev-win-sg"
    associate_eip       = true
    os_type             = "windows"
    key_name            = "windows-server-key"
    #secondary_ebs_volume_type  = "gp3"
    #secondary_ebs_volume_size  = "1"
  }
]

# Security group configurations (combined)
# SG FOR API-Gateway server
security_groups_ids = [
  {
    name    = "zarthi-dev-apigw-sg"
    vpc_key = "DEV"
    ingress_rules = [
      {
        description = "Allow SSH Centilytics"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "Allow HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
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
    name          = "zarthi-dev-win-sg"
    vpc_key       = "DEV"
    ingress_rules = [
      {
        description = "Allow RDP access for centilytics IPs"
        from_port   = 3389
        to_port     = 3389
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "Allow RDP access for Dhanush IPs"
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
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
  "zarthi-dev-vpc-flow-logs" = {
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
