# EKS Hardened Module

Production-ready EKS module aligned with CIS EKS Benchmark v1.4.

## Security Controls

| Control | Implementation |
|---|---|
| Private endpoint only | `endpoint_public_access = false` |
| Secrets encryption | Dedicated KMS key with envelope encryption |
| EBS encryption | Dedicated KMS key, separate from secrets key |
| IMDSv2 enforced | `http_tokens = required`, hop limit 1 |
| Least-privilege IAM | Only EKSWorkerNodePolicy, EKS_CNI_Policy, ECR ReadOnly |
| Control plane logging | All 5 log types enabled |
| IRSA | OIDC provider with scoped trust policy |
| Network hardening | Ports 443 and 10250 only, no ephemeral ranges |

## Usage

```hcl
module "eks" {
  source = "./path-to-module"

  cluster_name = "my-cluster"
  vpc_id       = "vpc-abc123"
  subnet_ids   = ["subnet-1", "subnet-2", "subnet-3"]

  node_desired_size = 3
  node_min_size     = 2
  node_max_size     = 5
  node_disk_size_gb = 100

  tags = {
    Environment = "production"
  }
}
```

## IRSA Workload Example

Annotate your Kubernetes service account:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: app
  namespace: default
  annotations:
    eks.amazonaws.com/role-arn: <irsa_app_role_arn output>
```

## Inputs

| Name | Type | Default | Required |
|---|---|---|---|
| cluster_name | string | — | yes |
| vpc_id | string | — | yes |
| subnet_ids | list(string) | — | yes |
| node_desired_size | number | 2 | no |
| node_min_size | number | 1 | no |
| node_max_size | number | 4 | no |
| node_disk_size_gb | number | 50 | no |
| tags | map(string) | {} | no |

## Outputs

| Name | Sensitive |
|---|---|
| cluster_name | no |
| cluster_endpoint | yes |
| cluster_certificate_authority | yes |
| cluster_security_group_id | no |
| node_security_group_id | no |
| oidc_provider_arn | no |
| oidc_provider_url | no |
| node_role_arn | no |
| irsa_app_role_arn | no |
| kms_secrets_key_arn | yes |
| kms_ebs_key_arn | yes |
