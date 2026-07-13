terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "name" {
  description = "Name tag for the EC2 instance"
  type        = string
  nullable    = false
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance should be launched"
  type        = string
}

variable "tags" {
  description = "Additional tags to attach to the EC2 instance"
  type        = map(string)
  default     = {}
}
variable "iam_instance_profile" {
  description = "IAM Instance Profile"
  type        = string
  default     = null
}
resource "aws_security_group" "this" {
  name   = "${var.name}-sg"
  description = "Security group for ${var.name}"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    description = "Allow HTTPS outbound"
  
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}
resource "aws_instance" "this" {
  ami                  = var.ami
  instance_type        = var.instance_type
  subnet_id            = var.subnet_id
  ebs_optimized        = true
  monitoring           = true
  iam_instance_profile = var.iam_instance_profile
  vpc_security_group_ids = [
    aws_security_group.this.id
  ]

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted   = true
    volume_type = "gp3"
    volume_size = 20
  }

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.this.public_ip
}
