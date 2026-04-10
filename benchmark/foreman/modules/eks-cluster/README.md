# eks-cluster

Terraform module that provisions a production-grade Amazon EKS cluster with security hardening, managed node groups, and full control plane logging.

## Features

- Private EKS API endpoint
- KMS encryption for Kubernetes secrets (envelope encryption)
- IMDSv2 enforced on node groups
- IRSA (IAM Roles for Service Accounts) via OIDC provider
- Managed node groups with launch templates
- Full control plane logging (api, audit, authenticator, controllerManager, scheduler)
- CIS Kubernetes Benchmark aligned
- Least-privilege IAM roles
- EKS addons: vpc-cni, coredns, kube-proxy

## Usage

```hcl
module "eks" {
  source = "./modules/eks-cluster"

  cluster_name    = "my-cluster"
  cluster_version = "1.29"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids

  node_instance_types = ["m6i.large"]
  node_desired_size   = 3
  node_min_size       = 1
  node_max_size       = 5

  tags = {
    Environment = "production"
    Team        = "platform"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| Terraform | >= 1.5 |
| AWS provider | ~> 5.0 |
| TLS provider | ~> 4.0 |
| Kubernetes provider | ~> 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| cluster_name | Name of the EKS cluster | `string` | — | yes |
| cluster_version | Kubernetes version | `string` | `"1.29"` | no |
| vpc_id | VPC ID for the cluster | `string` | — | yes |
| subnet_ids | Subnets for the cluster and node groups | `list(string)` | — | yes |
| node_instance_types | EC2 instance types for the managed node group | `list(string)` | `["m6i.large"]` | no |
| node_desired_size | Desired number of nodes | `number` | `2` | no |
| node_min_size | Minimum number of nodes | `number` | `1` | no |
| node_max_size | Maximum number of nodes | `number` | `4` | no |
| endpoint_private_access | Enable private API endpoint | `bool` | `true` | no |
| endpoint_public_access | Enable public API endpoint | `bool` | `false` | no |
| service_ipv4_cidr | CIDR block for Kubernetes service IPs | `string` | `"172.20.0.0/16"` | no |
| tags | Tags applied to all resources | `map(string)` | `{}` | no |
| kms_key_deletion_window | Days before KMS key deletion | `number` | `30` | no |

## Outputs

| Name | Description | Sensitive |
|------|-------------|-----------|
| cluster_id | EKS cluster ID | no |
| cluster_endpoint | EKS cluster API endpoint | yes |
| cluster_certificate_authority_data | Base64-encoded cluster CA certificate | yes |
| cluster_security_group_id | Security group ID attached to the cluster | no |
| cluster_iam_role_arn | IAM role ARN used by the cluster | no |
| oidc_provider_arn | ARN of the OIDC provider for IRSA | no |
| oidc_provider_url | URL of the OIDC provider | no |
| node_group_id | Managed node group ID | no |
| node_group_role_arn | IAM role ARN used by the node group | no |
| kms_key_arn | ARN of the KMS key for secrets encryption | no |
| kms_key_id | ID of the KMS key | no |

## Security

This module aligns with the CIS Kubernetes Benchmark. Key controls:

- API endpoint is private by default; public access is disabled.
- Kubernetes secrets are encrypted at rest using a dedicated KMS key (envelope encryption).
- IMDSv2 is required on all node group instances (hop limit 1).
- IRSA via OIDC eliminates the need for static credentials in pods.
- IAM roles follow least-privilege principles with scoped policies.

## License

Apache 2.0
