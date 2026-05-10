# Rust — Workflow Analysis

## Workflow Inventory
| File | Category | Trigger | Blocks PR? |
|------|----------|---------|------------|
| ci.yml | PR_CHECK | push, pull_request | Yes |
| dependencies.yml | SCHEDULED | schedule, workflow_dispatch | No |
| ghcr.yml | SCHEDULED | workflow_dispatch, schedule | No |
| post-merge.yml | MERGE_GATE | push | No |

## Workflow Details

### `ci.yml` — PR_CHECK
**Triggers:** push, pull_request
**Branches/Paths:** push: branches=automation/bors/auto, automation/bors/try, try-perf | pull_request: branches=**
**Contributor visible:** Partial (runs on PRs, but secret-backed steps are limited on forks)

#### Jobs
1. **calculate_matrix** — Automated test execution
   - Step: Checkout the source code
   - Step: Test citool
   - Step: Calculate the CI job matrix
2. **job** — Build or packaging validation
   - Step: Install cargo in AWS CodeBuild
   - Step: disable git crlf conversion
   - Step: checkout the source code
   - Step: free up disk space
   - Step: print disk usage
   - Step: configure the PR in which the error message will be posted
   - Step: add extra environment variables
   - Step: ensure the channel matches the target branch
3. **outcome** — Artifact publishing
   - Step: checkout the source code
   - Step: publish toolstate

**Secrets required:** secret:ARTIFACTS_AWS_ACCESS_KEY_ID, secret:ARTIFACTS_AWS_SECRET_ACCESS_KEY, secret:CACHES_AWS_ACCESS_KEY_ID, secret:CACHES_AWS_SECRET_ACCESS_KEY, secret:DATADOG_API_KEY, secret:GITHUB_TOKEN, secret:TOOLSTATE_REPO_ACCESS_TOKEN, env:DOC_ARTIFACT_NAME
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** Yes

### `dependencies.yml` — SCHEDULED
**Triggers:** schedule, workflow_dispatch
**Branches/Paths:** schedule: {'cron': '0 0 * * Sun'} | workflow_dispatch: default
**Contributor visible:** No

#### Jobs
1. **not-waiting-on-bors** — Repository automation or labeling
   - Step: Run `# Fetch state and labels of PR`
2. **update** — Workflow-specific automation
   - Step: checkout the source code
   - Step: install the bootstrap toolchain
   - Step: cargo update
   - Step: upload Cargo.lock artifact for use in PR
   - Step: upload cargo-update log artifact for use in PR
3. **pr** — Workflow-specific automation
   - Step: checkout the source code
   - Step: download Cargo.lock from update job
   - Step: download cargo-update log from update job
   - Step: craft PR body and commit message
   - Step: commit
   - Step: push
   - Step: edit existing open pull request
   - Step: open new pull request

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** No

### `ghcr.yml` — SCHEDULED
**Triggers:** workflow_dispatch, schedule
**Branches/Paths:** workflow_dispatch: default | schedule: {'cron': '0 0 * * *'}
**Contributor visible:** No

#### Jobs
1. **mirror** — Container build or image publication
   - Step: Use actions/checkout@v5
   - Step: Log in to registry
   - Step: Download crane
   - Step: Mirror DockerHub

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** No

### `post-merge.yml` — MERGE_GATE
**Triggers:** push
**Branches/Paths:** push: branches=main
**Contributor visible:** No

#### Jobs
1. **analysis** — Performance benchmarking
   - Step: Use actions/checkout@v5
   - Step: Perform analysis and send PR

**Secrets required:** none
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** No

## Contributor Summary

New contributors should expect these workflows to matter most on their pull requests: ci.yml. Workflows that are mainly for maintainers or release automation include very few maintainer-only files. To stay ahead of CI, contributors should at minimum run tests, verify builds. Release, publishing, scheduled maintenance, scorecard, and documentation deployment workflows are usually not something a first-time contributor needs to optimize for unless their change touches that surface. If a PR-visible workflow fails, the quickest path is to compare the failing job steps with the local equivalent command and then re-run only after reproducing or understanding the issue. The contributor experience in this repository is fairly compact because the workflow files themselves expose most of the automation contract.

## Red Flags / Observations

- Some workflows need more in-file explanation because job intent is not obvious from names alone: dependencies.yml.
- These may confuse fork-based contributors because they mix PR execution with restricted secrets or elevated contexts: ci.yml.
- Good patterns Cacti can replicate: clearly separated PR checks such as ci.yml.
