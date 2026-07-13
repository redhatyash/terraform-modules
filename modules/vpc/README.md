# VPC Terraform module

This folder contains a reusable Terraform module for creating an AWS VPC.

## What this module does

The module creates:
- one AWS VPC
- optional DNS hostnames support
- basic tags for resource identification

## Usage

```hcl
module "vpc" {
  source = "./modules/vpc"

  name          = "demo-vpc"
  cidr_block    = "10.10.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Environment = "dev"
    Team        = "platform"
  }
}
```

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| name | Name tag for the VPC | string | n/a |
| cidr_block | CIDR block for the VPC | string | 10.0.0.0/16 |
| enable_dns_hostnames | Enable DNS hostnames in the VPC | bool | true |
| tags | Additional tags to apply to the VPC | map(string) | {} |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the created VPC |
| cidr_block | The CIDR block of the created VPC |

## Example input file

A sample input file is available at [example.yaml](example.yaml).
