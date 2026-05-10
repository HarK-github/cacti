# Detailed Analysis of Weaver CI (`ci_weaver.yaml`)

This document provides a deep dive into the architecture, execution patterns, bottlenecks, and optimization strategies for the Hyperledger Cacti Weaver CI pipeline.

---

## 1. Workflow Architecture

The `ci_weaver.yaml` workflow acts as a **top-level orchestrator**. It does not perform any tests itself but delegates to 12 specialized sub-workflows.

### Triggers
- **Pull Requests/Pushes** to `main`.
- **Scheduled (Cron)**: Monthly run on the 1st of every month.
- **Manual**: `workflow_dispatch`.

### Job Orchestration
It triggers the following 12 reusable workflows in parallel:
1.  `test_weaver-fabric-fabric-satp.yaml`
2.  `test_weaver-asset-exchange-corda.yaml`
3.  `test_weaver-asset-transfer.yaml`
4.  `test_weaver-relay.yaml`
5.  `test_weaver-corda-interop-app.yaml`
6.  `test_weaver-pre-release.yaml`
7.  `test_weaver-asset-exchange-fabric.yaml`
8.  `test_weaver-data-sharing.yaml`
9.  `test_weaver-node-pkgs.yaml`
10. `test_weaver-docker-build.yaml`
11. `test_weaver-asset-exchange-besu.yaml`
12. `test_weaver-go.yaml`

---

## 2. What It Checks (Job Anatomy)

Each sub-workflow typically follows this pattern (analyzed from `test_weaver-asset-exchange-besu.yaml` and `test_weaver-data-sharing.yaml`):

### A. Change Detection (`check_code_changed`)
Uses `dorny/paths-filter` to see if files in `./weaver/**` or the workflow file itself have changed. If no changes are detected, downstream jobs are skipped (though the runner is still spun up).

### B. Environment Setup
Every job independently installs:
- **JDK** (11 or 17)
- **Node.js**
- **Go** (for some jobs)
- **Rust** (for Relay jobs)
- **Protoc** (manually downloaded via `curl` and `unzip`)

### C. Network Bootstrapping
Jobs start local DLT networks:
- **Besu**: Downloads binaries (~100MB), starts network, and **sleeps for 100 seconds**.
- **Fabric**: Uses `make start-interop` (Docker-based).
- **Corda**: Uses `make start-local` (Heavy JVM process).

### D. Component Building
Repeatedly builds Weaver components from source:
- Protos (JS, Go, Solidity, Java)
- SDKs (Besu, Fabric, Corda)
- Drivers (Fabric, Corda)
- Relays (Rust-based)
- IIN Agents
- CLIs

### E. Integration Testing
Executes end-to-end scenarios using CLIs (e.g., `besu-cli`, `fabric-cli`) to perform asset locking, claiming, and data sharing across networks.

---

## 3. Why It Takes 14+ Minutes (Bottlenecks)

| Bottleneck | Description | Estimated Impact |
| :--- | :--- | :--- |
| **Idle Wait Times** | Hardcoded `sleep 100` and `sleep 30` commands waste minutes while waiting for networks to "warm up". | 2-3 minutes per job |
| **Zero Caching** | Re-downloading Besu binaries, Protoc, and re-installing Node/Rust/Go dependencies on every run. | 3-4 minutes per job |
| **Redundant Builds** | Components like the **Relay** and **Drivers** are built from scratch in every single sub-workflow instead of being built once. | 4-5 minutes per job |
| **Dead Code execution** | Many jobs have `if: ${{ false }}` but still cause GitHub to process the YAML and potentially spin up resources. | Complexity bloat |
| **Linear Setup** | In `test_weaver-data-sharing.yaml`, it starts Corda, then Fabric, then Relay, then Drivers sequentially. | Cumulative delay |

---

## 4. Optimization Strategies

### 1. Eliminate Idle Time (Health Checks)
Replace `sleep 100` with a retry loop that pings the network's RPC or health endpoint.
```bash
# Example instead of sleep 100
until curl -s http://localhost:8545; do sleep 5; done
```

### 2. Implement Global Caching
Use `actions/cache` for:
- `~/.cargo` (Rust Relay builds)
- `node_modules` (SDKs and CLIs)
- `~/.gradle` (Corda builds)
- Downloaded binaries (Besu, Protoc)

### 3. Build Once, Run Many (Artifacts)
Create a `weaver-build` job that compiles the Relay, Drivers, and CLIs, and uploads them as GitHub Action Artifacts. Sub-workflows can then download these pre-built binaries in seconds.

### 4. Shared "Setup" Action
The setup logic for Protoc and DLT binaries is duplicated across 12 files. Moving this to a **Composite Action** in `.github/actions/weaver-setup/` would make maintenance 10x easier.

### 5. Docker Layer Caching
For jobs like `test_weaver-docker-build.yaml`, ensure `cache-from: type=gha` is used to avoid rebuilding identical layers.

### 6. Consolidate Matrix
Instead of 12 workflow files, use a single `weaver-integration-tests.yaml` with a matrix for the protocol (Besu, Fabric, Corda). This reduces the overhead of managing 12 separate "change detection" jobs.
