# Credo TS — Workflow Analysis

## Workflow Inventory
| File | Category | Trigger | Blocks PR? |
|------|----------|---------|------------|
| cleanup-cache.yml | SCHEDULED | schedule, workflow_dispatch | No |
| continuous-integration.yml | PR_CHECK | pull_request, push, pull_request_review | Yes |
| lint-pr.yml | MAINTAINER_ONLY | pull_request_target | Yes |
| release.yml | RELEASE | push, pull_request | Yes |
| repolinter.yml | INFRA | workflow_dispatch | No |
| scorecard.yml | SCHEDULED | schedule | No |

## Workflow Details

### `cleanup-cache.yml` — SCHEDULED
**Triggers:** schedule, workflow_dispatch
**Branches/Paths:** schedule: {'cron': '0 0 * * 0/3'} | workflow_dispatch: default
**Contributor visible:** No

#### Jobs
1. **delete-caches** — Workflow-specific automation
   - Step: Wipe Github Actions cache

**Secrets required:** none
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** No

### `continuous-integration.yml` — PR_CHECK
**Triggers:** pull_request, push, pull_request_review
**Branches/Paths:** pull_request: branches=main | push: branches=main | pull_request_review: default
**Contributor visible:** Partial (runs on PRs, but secret-backed steps are limited on forks)

#### Jobs
1. **validate** — Linting and style validation
   - Step: Use actions/checkout@v6.0.2
   - Step: Use pnpm/action-setup@v5
   - Step: Setup NodeJS
   - Step: Install dependencies
   - Step: Linting and Formatting
   - Step: Check Types
   - Step: Build
2. **unit-tests** — Automated test execution
   - Step: Use actions/checkout@v6.0.2
   - Step: Use pnpm/action-setup@v5
   - Step: Setup NodeJS
   - Step: pnpm cache path
   - Step: pnpm cache
   - Step: Install dependencies
   - Step: Run tests
   - Step: Run `mv coverage/coverage-final.json coverage/${{ matrix.shard }}.json`
3. **e2e-tests** — Automated test execution
   - Step: Use actions/checkout@v6.0.2
   - Step: Setup services
   - Step: Setup NodeJS
   - Step: Use pnpm/action-setup@v5
   - Step: pnpm cache path
   - Step: pnpm cache
   - Step: Install dependencies
   - Step: Run tests
4. **drizzle-tests** — Automated test execution
   - Step: Use actions/checkout@v6.0.2
   - Step: Setup services
   - Step: Setup NodeJS
   - Step: Use pnpm/action-setup@v5
   - Step: pnpm cache path
   - Step: pnpm cache
   - Step: Install dependencies
   - Step: Build drizzle package
5. **report-coverage** — Coverage collection and reporting
   - Step: Use actions/download-artifact@v8
   - Step: Use codecov/codecov-action@v5

**Secrets required:** secret:CODECOV_TOKEN
**Estimated run time:** ~45+ minutes
**Blocks PR merge:** Yes

### `lint-pr.yml` — MAINTAINER_ONLY
**Triggers:** pull_request_target
**Branches/Paths:** pull_request_target: types=opened, edited, synchronize
**Contributor visible:** Partial (PR context with elevated maintainer-owned workflow)

#### Jobs
1. **main** — Workflow-specific automation
   - Step: Use amannn/action-semantic-pull-request@48f256284bd46cdaab1048c3721360e808335d50

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** Yes

### `release.yml` — RELEASE
**Triggers:** push, pull_request
**Branches/Paths:** push: branches=main | pull_request: branches=main; types=opened, synchronize, reopened, labeled
**Contributor visible:** Partial (runs on PRs, but secret-backed steps are limited on forks)

#### Jobs
1. **release** — Release or publishing automation
   - Step: Use actions/checkout@v6.0.2
   - Step: Use pnpm/action-setup@v5
   - Step: Setup Node.js
   - Step: Update npm
   - Step: Install Dependencies
   - Step: Create Release Pull Request or Publish to npm
   - Step: Get current package version
   - Step: Create Github Release
2. **release-unstable** — Release or publishing automation
   - Step: Use snnaplab/get-labels-action@v1
   - Step: Check if should run
   - Step: Use actions/checkout@v6.0.2
   - Step: Use pnpm/action-setup@v5
   - Step: Setup Node.js
   - Step: Update npm
   - Step: Install Dependencies
   - Step: Create unstable release

**Secrets required:** secret:GITHUB_TOKEN, secret:NPM_PUBLISH, env:CURRENT_PACKAGE_VERSION, env:TAG
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** Yes

### `repolinter.yml` — INFRA
**Triggers:** workflow_dispatch
**Branches/Paths:** workflow_dispatch: default
**Contributor visible:** No

#### Jobs
1. **lint** — Linting and style validation
   - Step: Checkout Code
   - Step: Lint Repo

**Secrets required:** none
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** No

### `scorecard.yml` — SCHEDULED
**Triggers:** schedule
**Branches/Paths:** schedule: {'cron': '00 08 * * 5'}
**Contributor visible:** No

#### Jobs
1. **analysis** — Security scorecard analysis
   - Step: Checkout code
   - Step: Run analysis
   - Step: Upload artifact
   - Step: Upload to code-scanning

**Secrets required:** none
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** No

## Contributor Summary

New contributors should expect these workflows to matter most on their pull requests: continuous-integration.yml, lint-pr.yml, release.yml. Workflows that are mainly for maintainers or release automation include lint-pr.yml, release.yml. To stay ahead of CI, contributors should at minimum run lint, run tests. Release, publishing, scheduled maintenance, scorecard, and documentation deployment workflows are usually not something a first-time contributor needs to optimize for unless their change touches that surface. If a PR-visible workflow fails, the quickest path is to compare the failing job steps with the local equivalent command and then re-run only after reproducing or understanding the issue. The contributor experience in this repository is fairly compact because the workflow files themselves expose most of the automation contract.

## Red Flags / Observations

- Potentially complex for newcomers: continuous-integration.yml.
- Some workflows need more in-file explanation because job intent is not obvious from names alone: cleanup-cache.yml, lint-pr.yml.
- These may confuse fork-based contributors because they mix PR execution with restricted secrets or elevated contexts: continuous-integration.yml, lint-pr.yml, release.yml.
- Good patterns Cacti can replicate: clearly separated PR checks such as continuous-integration.yml.
