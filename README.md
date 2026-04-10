# foreman-tests

Benchmark: Foreman vs Sonnet 4.6 raw — same prompt, head-to-head.

## Prompt
> "Create an EKS Terraform module from scratch with hardening techniques"

## Directories
- `benchmark/foreman/` — result using Foreman orchestration
- `benchmark/sonnet-raw/` — result using kiro-cli + Sonnet 4.6 directly (no Foreman)

## Metrics
| Metric | Foreman | Sonnet Raw |
|--------|---------|------------|
| Retries | - | - |
| Duration | - | - |
| Token estimate | - | - |
| Opus review score | - | - |
| Security issues found | - | - |
