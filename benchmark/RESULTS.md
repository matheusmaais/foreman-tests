# Benchmark Results — EKS Module

## Prompt
> Create an EKS Terraform module from scratch with hardening techniques. The module should include: node groups with Graviton ARM64, IRSA for pod-level IAM, encryption at rest for secrets, private endpoint only, security groups with least privilege, cluster logging enabled, managed node groups with launch templates, and proper tagging. Follow AWS security best practices and CIS EKS benchmark recommendations.

## Metrics

| Metric | Foreman | Sonnet Raw |
|--------|---------|------------|
| Duration | 257s | 242s |
| Files created | 6 | 7 |
| Lines of code | 481 | 374 |
| Retries | 0 | 0 |
| Mode classified | critical | N/A |
| Patterns injected | 317 | 0 |
| **Opus score** | **8.3/10** | **7.6/10** |
| **Winner** | **✅ Foreman** | |

## Score Breakdown (Opus 4.5 review)

| Category | Foreman | Sonnet Raw |
|----------|---------|------------|
| Security hardening | 7/10 | 7/10 |
| Graviton ARM64 | 9/10 | 8/10 |
| IRSA completeness | 9/10 | 6/10 |
| KMS encryption | 8/10 | 8/10 |
| Private endpoint | 10/10 | 10/10 |
| Security groups | 6/10 | 8/10 |
| Code quality/docs | 9/10 | 6/10 |
| Feature coverage | 8/10 | 8/10 |

## Key Findings

**Foreman wins on:**
- IRSA completeness (full trust policy example vs OIDC-only)
- Module usability (variable validation, README, output descriptions, sensitive marking)
- KMS-encrypted EBS volumes
- Consistent tagging strategy

**Sonnet Raw wins on:**
- Security group precision (kubelet-scoped vs 1025-65535 ephemeral range)
- Modern Terraform SG rule resources
- SSM access for nodes
- Detailed monitoring + update_config

## Conclusion

Foreman produced a **shippable module** — documented, validated, with working IRSA example.
Sonnet Raw produced **correct infrastructure code** — tighter security groups but undocumented and missing validation.

The 317 injected patterns helped Foreman produce better module structure (TF_MODULE_STANDARD_FILES, TF_VAR_VALIDATION_BLOCKS, TF_VAR_DESCRIPTION_REQUIRED, TF_SEC_SENSITIVE_OUTPUTS).
