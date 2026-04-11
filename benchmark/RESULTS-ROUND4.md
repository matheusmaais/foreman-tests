# Benchmark Results — Round 4 (Fair Comparison)

## Setup
- **Same model**: Sonnet 4.6 for everything (implement, review, raw)
- **Same prompt**: `create a hardened EKS terraform module`
- **Clean start**: empty git repo, no cache, no prior config
- **No --agent flag**: foreman auto-routes from prompt text

## Round 4 Results

| Metric | Foreman | Sonnet Raw |
|--------|---------|------------|
| Total time | 159s | 148s |
| Implement time | 91s | 148s |
| Review time | 67s | — |
| Lint + Test | 65ms ✅ | not run |
| Files created | 5 | 4 |
| Lines of code | 413 | 225 |
| Auto-routing | terraform → infra ✅ | N/A |
| Patterns injected | 10 | 0 |
| Review | APPROVED ✅ | none |
| First pass success | ✅ | ✅ |

## Analysis

**Time**: Foreman is 11s slower (159s vs 148s) — the review stage (67s) adds overhead. But the implement stage itself was faster (91s vs 148s) because the injected patterns + specialist agent prompt guided the model to produce code more efficiently.

**Output**: Foreman produced 83% more code (413 vs 225 lines) and an extra file (locals.tf). More code isn't always better, but the foreman output includes variable validation blocks, descriptions, and structured locals that the raw output lacks.

**Validation**: Foreman's output is validated (terraform fmt clean, terraform validate clean, code review approved). Sonnet raw's output has no validation — could have syntax errors, security issues, or missing best practices.

**Trade-off**: 11 seconds of overhead buys you: lint, test, code review, pattern injection, and auto-routing. For production use, that's a clear win.

## Foreman Evolution (Rounds 1-4)

| Metric | R1 (no review) | R2 (Sonnet raw) | R3 (with review) | R4 (fair, auto-route) |
|--------|----------------|-----------------|-------------------|----------------------|
| Score (Opus eval) | 5.7/10 | 7.7/10 | 8.2/10 | TBD |
| Duration | 257s | 213s | 270s | 159s |
| Review | none | none | Opus review | Sonnet review |
| Patterns | 317 | 0 | 317 | 10 (relevant) |
| Auto-routing | ❌ manual | N/A | ❌ manual | ✅ auto |
| First pass | ✅ | ✅ | ✅ | ✅ |
| Pipeline | implement only | implement only | implement+review | full (lint+test+review) |

### Key improvements R1 → R4:
1. **R1→R3**: Added review cycle — score jumped from 5.7 to 8.2
2. **R3→R4**: Auto-routing, builtin agents, provider-agnostic, full pipeline
3. **Duration**: 257s → 159s (38% faster) despite adding more stages
4. **Patterns**: 317 (all) → 10 (relevant only) — smarter injection
