#domain_name = "zarthi-dev.centilytics.com"
#FOR LINUX USE THIS AMI = "ami-0e0e417dfa2028266"
#FOR UBUNTU SERVER 22.04 USE THIS AMI = "ami-09b0a86a2c84101e1"
#FOR WINDOWS USE THIS AMI = "ami-0c0d49e8adba807ec"

aws_region     = "ap-south-1"

# VPC configurations
vpcs = {
  "DEV" = {
    vpc_name           = "zarthi-dev-vpc"
    vpc_cidr_block     = "10.100.0.0/16"
    public_subnets     = ["10.100.0.0/20", "10.100.16.0/20"]
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
  /*{
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
  }*/
  {
  vpc_key             = "DEV"
  ami_id              = "ami-09b0a86a2c84101e1"
  instance_type       = "t3.micro"
  subnet_index        = 0
  name                = "jenkins-server"
  subnet_type         = "public"
  ebs_volume_type     = "gp3"
  ebs_volume_size     = 10
  security_group_name = "zarthi-dev-jenkins-sg"
  associate_eip       = true
  os_type             = "linux"
  key_name            = "jenkins-server-key"
  user_data_path      = "scripts/jenkins-user-data.sh"
},
{
  vpc_key             = "DEV"
  ami_id              = "ami-09b0a86a2c84101e1" # Ubuntu 22.04
  instance_type       = "t3.small"
  subnet_index        = 0
  name                = "elasticsearch-server"
  subnet_type         = "public"
  ebs_volume_type     = "gp3"
  ebs_volume_size     = 10
  security_group_name = "zarthi-dev-elasticsearch-sg"
  associate_eip       = true
  os_type             = "linux"
  key_name            = "elasticsearch-server-key"
  user_data_path      = "scripts/elasticsearch-user-data.sh"
},
{
    vpc_key             = "DEV"
    ami_id              = "ami-09b0a86a2c84101e1" # Ubuntu 22.04
    instance_type       = "t3.micro"
    subnet_index        = 0
    name                = "redis-server"
    subnet_type         = "public"
    ebs_volume_type     = "gp3"
    ebs_volume_size     = 10
    security_group_name = "zarthi-dev-redis-sg"
    associate_eip       = false
    os_type             = "linux"
    key_name            = "redis-server-key"
    user_data_path      = "scripts/redis-user-data.sh"

  },

  {
  vpc_key             = "DEV"
  ami_id              = "ami-09b0a86a2c84101e1" # Ubuntu 22.04
  instance_type       = "t3.micro"
  subnet_index        = 0
  name                = "pritunl-server"
  subnet_type         = "public"
  ebs_volume_type     = "gp3"
  ebs_volume_size     = 10
  security_group_name = "zarthi-dev-pritunl-sg"
  associate_eip       = true
  os_type             = "linux"
  key_name            = "pritunl-server-key"
  user_data_path      = "scripts/pritunl-user-data.sh"
},
  {
    vpc_key             = "DEV"
    ami_id              = "ami-09b0a86a2c84101e1"
    instance_type       = "t3.micro"
    subnet_index        = 0
    name                = "mongodb-server"
    subnet_type         = "public"
    ebs_volume_type     = "gp3"
    ebs_volume_size     = 10  
    security_group_name = "zarthi-dev-mongodb-sg"
    associate_eip       = false
    os_type             = "linux"
    key_name            = "mongodb-server-key"
    user_data_path      = "scripts/mongodb-user-data.sh"
  }
]

# ALB and ACM configuration for Pritunl

# Security groups
security_groups_ids = [
  {
    name    = "zarthi-dev-jenkins-sg"
    vpc_key = "DEV"
    ingress_rules = [
      {
        description = "Allow SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "Allow Jenkins UI"
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
  },
  {
    name    = "zarthi-dev-pritunl-sg"
    vpc_key = "DEV"
    ingress_rules = [
      {
        description = "Allow SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "Allow Pritunl Web UI"
        from_port   = 443
        to_port     = 443
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
  {
    name    = "zarthi-dev-elasticsearch-sg"
    vpc_key = "DEV"
    ingress_rules = [
      {
        description = "Allow SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "Allow Elasticsearch HTTP"
        from_port   = 9200
        to_port     = 9200
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
  {
    name    = "zarthi-dev-redis-sg"
    vpc_key = "DEV"
    ingress_rules = [
      {
        description = "Allow SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "Allow Redis"
        from_port   = 6379
        to_port     = 6379
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
  {
    name    = "zarthi-dev-mongodb-sg"
    vpc_key = "DEV"
    ingress_rules = [
      {
        description = "Allow SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "Allow MongoDB"
        from_port   = 27017
        to_port     = 27017
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



# S3 Bucket for VPC flow logs
s3_buckets = {
  "zarthi-dev-vpc-flow-logs" = {
    public_access_block = {
      block_public_acls       = true
      ignore_public_acls      = true
      block_public_policy     = true
      restrict_public_buckets = true
    }
    versioning     = true
    encryption     = true
    apply_policy   = false
    bucket_logging = false
  }
}

