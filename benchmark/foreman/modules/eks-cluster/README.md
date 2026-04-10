# eks-cluster

Hardened EKS module aligned with CIS Amazon EKS Benchmark recommendations.

## Usage

```hcl
module "eks" {
  source = "./modules/eks-cluster"

  cluster_name   = "my-cluster"
  cluster_version = "1.29"
  vpc_id         = "vpc-0123456789abcdef0"
  subnet_ids     = ["subnet-aaa", "subnet-bbb"]
  environment    = "production"
  instance_types = ["t4g.medium"]
  node_disk_size = 50

  tags = {
    Project = "my-project"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| cluster_name | Name of the EKS cluster | string | — | yes |
| cluster_version | Kubernetes version | string | `"1.29"` | no |
| vpc_id | VPC ID | string | — | yes |
| subnet_ids | Subnet IDs (min 2) | list(string) | — | yes |
| environment | Environment name | string | — | yes |
| instance_types | Graviton ARM64 instance types | list(string) | `["t4g.medium"]` | no |
| node_desired_size | Desired node count | number | `2` | no |
| node_min_size | Minimum node count | number | `1` | no |
| node_max_size | Maximum node count | number | `4` | no |
| node_disk_size | Disk size in GiB | number | `50` | no |
| tags | Additional tags | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster_endpoint | EKS cluster API endpoint |
| cluster_certificate_authority | Base64 encoded CA data (sensitive) |
| oidc_provider_arn | OIDC provider ARN for IRSA |
| oidc_provider_url | OIDC provider URL |
| node_group_name | Managed node group name |
| cluster_security_group_id | Cluster security group ID |
| node_security_group_id | Node security group ID |
| cluster_name | EKS cluster name |
| kms_key_arn | KMS key ARN for secrets encryption |

## Security Features

- **Private endpoint only** — public API endpoint disabled
- **Secrets encryption** — envelope encryption via dedicated KMS key with rotation enabled
- **IMDSv2 required** — `http_tokens = required`, hop limit 1
- **Encrypted EBS** — node volumes encrypted with KMS
- **Least-privilege SGs** — separate cluster/node security groups, no `0.0.0.0/0` ingress
- **All control plane logs** — api, audit, authenticator, controllerManager, scheduler
- **IRSA** — OIDC provider for pod-level IAM via `sts:AssumeRoleWithWebIdentity`
- **Graviton ARM64** — `AL2_ARM_64` AMI type with t4g/m7g instance families
- **Consistent tagging** — Name, Environment, ManagedBy=terraform on all resources
