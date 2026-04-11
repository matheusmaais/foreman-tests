# Benchmark Results — Round 3 (Full Comparison)

## Setup
- Same prompt, same base model (Sonnet 4.6) for all implementations
- Foreman uses Opus 4.5 as reviewer

## Versions Compared
| Version | Description | Duration |
|---------|-------------|----------|
| A — Foreman R1 | No review, single pass | 257s |
| B — Sonnet Raw R2 | No orchestration, no review | 213s |
| C — Foreman R3 | With Opus review, approved after 1 cycle | 270s |

## Opus Scores

| Category | A (Foreman R1) | B (Sonnet Raw) | C (Foreman R3) |
|----------|---------------|----------------|----------------|
| Security Hardening | 6 | 8 | **9** |
| IRSA Completeness | 7 | 7 | **8** |
| KMS Correctness | 5 | 8 | **9** |
| SG Precision | 3 | **9** | 5 |
| Code Quality/Docs | 7 | 7 | **9** |
| Feature Coverage | 6 | 7 | **9** |
| **Overall** | **5.7/10** | **7.7/10** | **8.2/10** |

## Winner: Foreman R3 (8.2/10)

## Key Improvements A → C (what the Opus review cycle added)
1. KMS: 1 key → 2 keys with correct principals (AutoScaling SLR for EBS)
2. Node groups: hardcoded single → for_each map (multi-group support)
3. EBS encryption: absent → dedicated KMS key
4. CloudWatch: implicit → explicit log group with retention (no cost bomb)
5. Variable rigor: nullable=false, cluster version regex, scaling invariant checks
6. Lifecycle: ignore_changes on desired_size (prevents autoscaler fights)
7. Public access: bool → conditional CIDR restriction
8. SSM access: absent → AmazonSSMManagedInstanceCore on node role
9. IRSA output: raw URL → pre-stripped https:// for direct use in trust policies

## Where Sonnet Raw Still Wins
- SG precision: B has explicit kubelet (10250) + HTTPS (443) rules. C regressed to single SG with egress-only.
- If B's SG rules were merged into C: near-perfect module.

## Conclusion
Foreman R3 > Sonnet Raw on 5/6 categories.
Sonnet Raw wins only on SG precision — a gap the Opus review flagged but the rework didn't fix (would need another cycle).
