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

resource "aws_instance" "this" {
  ami                  = var.ami
  instance_type        = var.instance_type
  subnet_id            = var.subnet_id
  ebs_optimized        = true
  monitoring           = true
  iam_instance_profile = var.iam_instance_profile

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
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
