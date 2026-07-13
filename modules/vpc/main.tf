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
  description = "Name tag for the VPC"
  type        = string
  nullable    = false
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
  description = "Whether DNS hostnames should be enabled in the VPC"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags to attach to the VPC"
  type        = map(string)
  default     = {}
}

resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.this.id

  ingress = []
  egress  = []

  tags = merge(
    {
      Name = "${var.name}-default-sg"
    },
    var.tags
  )
}

resource "aws_flow_log" "example" {
  iam_role_arn    = "arn:aws:iam::123456789012:role/VPCFlowLogsRole"
  log_destination = "arn:aws:logs:ap-south-1:123456789012:log-group:flowlogs"
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.this.id
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}
