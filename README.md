# terraform-modules

This repository is intended to hold reusable Terraform modules that can be consumed by downstream repositories such as terraform-infra.

## CI workflow

GitHub Actions will run on pushes and pull requests to validate Terraform modules with:
- terraform fmt -check
- terraform init + terraform validate
- tflint
- checkov

The workflow is defined in [.github/workflows/terraform-ci.yml](.github/workflows/terraform-ci.yml).

## Release workflow

Create a tag like v1.2.3 to publish a GitHub release automatically. The release workflow is defined in [.github/workflows/release.yml](.github/workflows/release.yml).

## Suggested structure

The repository currently contains AWS-focused example modules:

- modules/vpc
- modules/ec2

Each module includes a simple example input file:

- modules/vpc/example.yaml
- modules/ec2/example.yaml

These can be used as a starting point for wiring the modules into downstream infrastructure repositories.