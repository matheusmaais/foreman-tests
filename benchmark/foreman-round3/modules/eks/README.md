# EKS Hardened Module

Opinionated, security-hardened EKS module aligned with CIS benchmarks.

## Security Features

- KMS encryption for Kubernetes secrets and EBS volumes
- Private API endpoint (public access disabled by default)
- IMDSv2 enforced on all nodes (hop limit 1)
- IRSA via OIDC provider (no static credentials)
- Least-privilege IAM roles for cluster and nodes
- All control plane log types enabled
- Dedicated security group with deny-all ingress baseline

## Usage

```hcl
module "eks" {
  source = "./modules/eks"

  cluster_name    = "my-cluster"
  cluster_version = "1.30"
  vpc_id          = "vpc-0123456789abcdef0"
  subnet_ids      = ["subnet-aaa", "subnet-bbb"]

  node_groups = {
    default = {
      instance_types = ["m6i.large"]
      desired_size   = 2
      min_size       = 1
      max_size       = 5
    }
  }

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

## IRSA Example

Create a service account role using the OIDC provider output:

```hcl
resource "aws_iam_role" "app" {
  name = "my-app-irsa"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = module.eks.oidc_provider_arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${module.eks.oidc_provider_url}:sub" = "system:serviceaccount:default:my-app"
          "${module.eks.oidc_provider_url}:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| aws | >= 5.46.0, < 6.0.0 |
| tls | >= 4.0.0, < 5.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| cluster_name | Name of the EKS cluster | `string` | — | yes |
| cluster_version | Kubernetes version | `string` | `"1.30"` | no |
| vpc_id | VPC ID for the cluster | `string` | — | yes |
| subnet_ids | Subnet IDs (min 2 AZs) | `list(string)` | — | yes |
| endpoint_public_access | Enable public API endpoint | `bool` | `false` | no |
| public_access_cidrs | CIDRs for public endpoint | `list(string)` | `[]` | no |
| log_retention_days | CloudWatch log retention | `number` | `90` | no |
| node_groups | Node group configurations | `map(object)` | — | yes |
| tags | Tags for all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description | Sensitive |
|------|-------------|-----------|
| cluster_name | EKS cluster name | no |
| cluster_endpoint | API server endpoint | no |
| cluster_certificate_authority_data | CA cert for auth | yes |
| cluster_security_group_id | Cluster SG ID | no |
| cluster_arn | Cluster ARN | no |
| cluster_version | Running K8s version | no |
| oidc_provider_arn | OIDC provider ARN (for IRSA) | no |
| oidc_provider_url | OIDC issuer URL | no |
| node_role_arn | Node IAM role ARN | no |
| cluster_role_arn | Cluster IAM role ARN | no |
| kms_key_arn_eks | KMS key ARN for secrets | no |
| kms_key_arn_ebs | KMS key ARN for EBS | no |
| node_group_names | Node group name → status map | no |
