# Detailed Analysis of Cacti CI (`ci.yaml`)

This document provides a deep dive into the architecture, execution patterns, bottlenecks, and optimization strategies for the primary Hyperledger Cacti CI pipeline.

---

## 1. Workflow Architecture

The `ci.yaml` workflow is the **central orchestrator** for the Cacti repository. It is a modular pipeline that delegates work to specialized sub-workflows.

### Triggers
- **Pull Requests**: Targeting `main` or `dev`.
- **Scheduled (Cron)**: Mondays and Thursdays at 8:00 AM UTC.
- **Manual**: `workflow_dispatch`.

### Pipeline Stages (The Call Chain)
The pipeline is strictly hierarchical, creating significant linear dependencies:
1.  **`env-setup`**: Trivial job that sets output variables (Node version, coverage flags).
2.  **`checks-and-build`** (depends on `env-setup`): 
    - Runs `actionlint` and inclusive naming checks (`DCI-Lint`).
    - Executes the **full monorepo build** (`yarn configure`) via the `configure-repo` action.
    - Computes a list of **affected packages** based on the git diff.
3.  **`code-quality-checks`** (depends on `checks-and-build`):
    - Runs `yarn lint`, `yarn codegen`, and custom validation scripts.
4.  **`packages-workflow`** (depends on `code-quality-checks`):
    - Triggers parallel test suites for `core`, `connector`, `keychain`, and `satp-hermes` plugins.
5.  **`examples-workflow`** (depends on `code-quality-checks`):
    - Runs tests for example applications.
6.  **`ghcr-workflow`** (depends on `checks-and-build`):
    - Builds various Docker "All-in-One" images for validation.

---

## 2. What It Checks

- **Code Integrity**: Ensures the project compiles from scratch (`yarn configure`).
- **Quality**: Enforces ESLint, Prettier, and OpenAPI spec validity.
- **CodeGen Validity**: Checks if `yarn codegen` produces any unstaged changes (meaning the dev forgot to run it).
- **Security**: Runs Trivy scans on Docker images (on schedule).
- **Functionality**: Runs unit and integration tests across all affected packages.
- **Docker Hygiene**: Validates that all `Dockerfiles` in the repo actually build.

---

## 3. Why It Takes 1h 40m (Bottlenecks)

| Bottleneck | Description | Impact |
| :--- | :--- | :--- |
| **Strict Serial Chain** | `packages-workflow` waits for `code-quality-checks`, which waits for `checks-and-build`. Tests cannot start until linting is 100% finished. | ~15-20m delay |
| **Redundant Setup** | Every sub-workflow (and almost every job) calls `configure-repo`, which runs `yarn install`. Even with global caching, linking files in a large monorepo takes 2-4 minutes per job. | ~30m cumulative waste |
| **No Build Caching** | The result of `yarn configure` (TS compilation) is not cached. Every job re-compiles the entire project even if only one package changed. | ~10m per job |
| **Docker Build Zero-Cache** | `ghcr-workflow` builds massive images (like Fabric AIO) from scratch every time. No layer caching means it pulls and installs OS packages repeatedly. | ~25m of the total time |
| **Inclusive Naming Latency** | `DCI-Lint` clones the entire repo and scans it. This is a serial step in the foundation of the pipeline. | ~3-5m delay |

---

## 4. Optimization Strategies

### 1. Decouple Linting from Tests
Modify `ci.yaml` so that `packages-workflow` only depends on `checks-and-build`, not `code-quality-checks`. This allows tests and linting to run in parallel.

### 2. Implement "Install-Once" Strategy
Use a dedicated `install-dependencies` job that caches the entire `.yarn/cache` and `node_modules` folder using a key based on `yarn.lock`. Subsequent jobs should only restore this cache instead of running `yarn install`.

### 3. Cache TypeScript Outputs
Implement caching for `.tsbuildinfo` and `dist` folders.
- **Key**: `os-node-tsbuild-${{ hashFiles('**/tsconfig.json', 'yarn.lock') }}`
- This will allow `yarn configure` to perform incremental builds, reducing build time from 8 minutes to <1 minute.

### 4. Enable Docker Layer Caching (GHA)
Update `ghcr-workflow.yaml` to use `docker/build-push-action@v5` with:
```yaml
cache-from: type=gha
cache-to: type=gha,mode=max
```
This will allow Docker builds to reuse layers across different PRs and runs, potentially saving 20+ minutes on image-heavy runs.

### 5. Smart Execution for "All Affected"
Currently, changes to `.github/workflows/` trigger a full rebuild of every Docker image. Refine this logic to only trigger relevant images or use a matrix for Docker builds to better parallelize the work.

### 6. Optimize `ActionLint` and `DCI-Lint`
These are currently serial jobs in `checks-and-build`. Move them to `code-quality-checks` so they don't block the critical "Compute Affected Packages" logic.
