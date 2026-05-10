# Hyperledger Fabric — Workflow Analysis

## Workflow Inventory
| File | Category | Trigger | Blocks PR? |
|------|----------|---------|------------|
| broken-link-checker.yml | SCHEDULED | workflow_dispatch, schedule, pull_request | Yes |
| release.yml | RELEASE | workflow_dispatch, push | No |
| scorecard.yml | SCHEDULED | workflow_dispatch, branch_protection_rule, schedule, push | No |
| verify-build.yml | PR_CHECK | push, pull_request, workflow_dispatch | Yes |
| vulnerability-scan.yml | SCHEDULED | workflow_dispatch, schedule | No |

## Workflow Details

### `broken-link-checker.yml` — SCHEDULED
**Triggers:** workflow_dispatch, schedule, pull_request
**Branches/Paths:** workflow_dispatch: default | schedule: {'cron': '50 1 * * *'} | pull_request: paths=.github/workflows/broken-link-checker.yml
**Contributor visible:** Yes

#### Jobs
1. **broken-link-checker** — Workflow-specific automation
   - Step: Check Broken Links with Muffet
2. **broken-link-checker-25** — Release or publishing automation
   - Step: Check Broken Links with Muffet

**Secrets required:** none
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** Yes

### `release.yml` — RELEASE
**Triggers:** workflow_dispatch, push
**Branches/Paths:** workflow_dispatch: default | push: tags=v2.*, v3.*
**Contributor visible:** No

#### Jobs
1. **build-binaries** — Build or packaging validation
   - Step: Checkout Fabric Code
   - Step: Install Go
   - Step: Compile Binary and Create Tarball
   - Step: Publish Release Artifact
2. **build-and-push-native-docker-images** — Build or packaging validation
   - Step: Checkout
   - Step: Set GO_VER environment variable from go.mod
   - Step: Login to the ${{ matrix.registry }} Container Registry
   - Step: Set up Docker Buildx
   - Step: Docker meta
   - Step: Build and push ${{ matrix.component.name }} Image
   - Step: Export digest
   - Step: Upload digest
3. **merge-and-push-multi-arch-image** — Build or packaging validation
   - Step: Download digests
   - Step: Login to the ${{ matrix.registry }} Container Registry
   - Step: Set up Docker Buildx
   - Step: Docker meta
   - Step: Create manifest list and push
   - Step: Inspect image
4. **create-release** — Release or publishing automation
   - Step: Checkout Fabric Code
   - Step: Download Artifacts
   - Step: Release Fabric Version

**Secrets required:** secret:DOCKERHUB_TOKEN, secret:DOCKERHUB_USERNAME, secret:GITHUB_TOKEN, env:FABRIC_VER, env:GO_VER, env:UBUNTU_VER
**Estimated run time:** ~45+ minutes
**Blocks PR merge:** No

### `scorecard.yml` — SCHEDULED
**Triggers:** workflow_dispatch, branch_protection_rule, schedule, push
**Branches/Paths:** workflow_dispatch: default | branch_protection_rule: default | schedule: {'cron': '17 21 * * 3'} | push: branches=main
**Contributor visible:** No

#### Jobs
1. **analysis** — Security scorecard analysis
   - Step: Checkout code
   - Step: Run analysis
   - Step: Upload artifact
   - Step: Upload to code-scanning

**Secrets required:** secret:SCORECARD_TOKEN
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** No

### `verify-build.yml` — PR_CHECK
**Triggers:** push, pull_request, workflow_dispatch
**Branches/Paths:** push: branches=** | pull_request: branches=** | workflow_dispatch: default
**Contributor visible:** Yes

#### Jobs
1. **basic-checks** — Workflow-specific automation
   - Step: Checkout Fabric Code
   - Step: Install Go
   - Step: check go.mod
   - Step: check vendor
   - Step: Run Basic Checks
2. **unit-tests** — Automated test execution
   - Step: Checkout Fabric Code
   - Step: Install Go
   - Step: Install SoftHSM
   - Step: Run Unit Tests
3. **integration-tests** — Automated test execution
   - Step: Checkout Fabric Code
   - Step: Install Go
   - Step: Install SoftHSM
   - Step: Run Integration Tests

**Secrets required:** none
**Estimated run time:** ~45+ minutes
**Blocks PR merge:** Yes

### `vulnerability-scan.yml` — SCHEDULED
**Triggers:** workflow_dispatch, schedule
**Branches/Paths:** workflow_dispatch: default | schedule: {'cron': '50 1 * * *'}
**Contributor visible:** No

#### Jobs
1. **latest** — Automated test execution
   - Step: No explicit steps in this job body
2. **get-latest-releases** — Automated test execution
   - Step: Checkout ${{ matrix.ref.branch }} branch
   - Step: Get latest release
3. **release** — Release or publishing automation
   - Step: No explicit steps in this job body

**Secrets required:** none
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** No

## Contributor Summary

New contributors should expect these workflows to matter most on their pull requests: broken-link-checker.yml, verify-build.yml. Workflows that are mainly for maintainers or release automation include release.yml. To stay ahead of CI, contributors should at minimum run tests, verify builds. Release, publishing, scheduled maintenance, scorecard, and documentation deployment workflows are usually not something a first-time contributor needs to optimize for unless their change touches that surface. If a PR-visible workflow fails, the quickest path is to compare the failing job steps with the local equivalent command and then re-run only after reproducing or understanding the issue. The contributor experience in this repository is fairly compact because the workflow files themselves expose most of the automation contract.

## Red Flags / Observations

- Potentially complex for newcomers: release.yml, verify-build.yml.
- Some workflows need more in-file explanation because job intent is not obvious from names alone: broken-link-checker.yml, verify-build.yml.
- Good patterns Cacti can replicate: clearly separated PR checks such as verify-build.yml.
