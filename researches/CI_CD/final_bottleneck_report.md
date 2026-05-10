# GitHub Actions Bottleneck Analysis Report

This report identifies the primary performance bottlenecks and frequent failures in the Hyperledger Cacti CI/CD pipeline, based on an analysis of recent workflow runs.

## 1. Top Performance Bottlenecks (Longest Jobs)

The following jobs have the longest average durations, contributing significantly to the overall pipeline runtime.

| Job Name | Avg Duration | Max Duration | Sample Count |
| :--- | :--- | :--- | :--- |
| `nuclei-scan` | ~10m 10s | 10m 15s | 2 |
| `asset-exchange-besu-local (AliceERC721)` | ~6m 17s | 6m 42s | 3 |
| `asset-exchange-besu-local (AliceERC1155)` | ~6m 11s | 6m 17s | 3 |
| `asset-exchange-besu-local (AliceERC20)` | ~6m 11s | 6m 19s | 3 |

**Analysis:**
- **Nuclei Scan:** This security scan takes over 10 minutes. If it runs on every PR, it's a major blocker.
- **Weaver Asset Exchange (Besu):** These integration tests are consistently slow (6+ minutes each). They appear to run in a matrix, meaning they consume multiple runners simultaneously for a long time.

## 2. Structural Inefficiencies

Based on the job names and previous audit data:
- **Redundant Setups:** Many jobs have similar names (e.g., `asset-exchange-besu-local` with different parameters). They likely duplicate the same environment setup (Besu network, relay, etc.) instead of reusing a pre-built environment or artifact.
- **Matrix Bloat:** The Weaver tests use a heavy matrix that scales poorly.

## 3. Recommended Fixes

1. **Caching:** Implement `actions/cache` for `node_modules` and TypeScript build outputs to reduce the 5-8 minute "setup" phase seen in many jobs.
2. **Security Scan Optimization:** Run `nuclei-scan` on a schedule or only when security-sensitive files change, rather than every PR.
3. **Consolidate Weaver Setup:** Extract the Weaver network setup into a separate job that uploads an artifact (e.g., a Docker volume or state), which downstream test jobs can quickly download and use.
4. **BuildKit for Docker:** Ensure all Docker builds (like those in Weaver tests) use BuildKit with GHA caching to avoid 15-20 minute image rebuilds.
