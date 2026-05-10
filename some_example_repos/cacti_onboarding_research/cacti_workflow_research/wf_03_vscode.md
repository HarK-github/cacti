# VS Code — Workflow Analysis

## Workflow Inventory
| File | Category | Trigger | Blocks PR? |
|------|----------|---------|------------|
| api-proposal-version-check.yml | PR_CHECK | pull_request, issue_comment | Yes |
| chat-lib-package.yml | PR_CHECK | pull_request, workflow_dispatch | Yes |
| chat-perf.yml | MAINTAINER_ONLY | workflow_dispatch | No |
| component-fixture-tests.yml | PR_CHECK | push, pull_request | Yes |
| copilot-setup-steps.yml | PR_CHECK | workflow_dispatch, push, pull_request | Yes |
| monaco-editor.yml | PR_CHECK | push, pull_request | Yes |
| no-engineering-system-changes.yml | PR_CHECK | pull_request | Yes |
| pr-darwin-test.yml | INFRA | workflow_call | No |
| pr-linux-cli-test.yml | INFRA | workflow_call | No |
| pr-linux-test.yml | INFRA | workflow_call | No |
| pr-node-modules.yml | MERGE_GATE | push | No |
| pr-win32-test.yml | INFRA | workflow_call | No |
| pr.yml | PR_CHECK | pull_request | Yes |
| screenshot-test.yml | PR_CHECK | push, pull_request | Yes |
| sessions-e2e.yml | MAINTAINER_ONLY | workflow_dispatch | No |
| telemetry.yml | PR_CHECK | pull_request | Yes |

## Workflow Details

### `api-proposal-version-check.yml` — PR_CHECK
**Triggers:** pull_request, issue_comment
**Branches/Paths:** pull_request: branches=main, release/*; paths=src/vscode-dts/vscode.proposed.*.d.ts | issue_comment: types=created
**Contributor visible:** Yes

#### Jobs
1. **check-version-changes** — Workflow-specific automation
   - Step: Get PR info
   - Step: Check for override comment
   - Step: Re-run failed workflow on override
   - Step: Pass on override comment
   - Step: Checkout repository
   - Step: Check for version changes
   - Step: Post warning comment
   - Step: Fail if version changed without override

**Secrets required:** none
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** Yes

### `chat-lib-package.yml` — PR_CHECK
**Triggers:** pull_request, workflow_dispatch
**Branches/Paths:** pull_request: default | workflow_dispatch: default
**Contributor visible:** Yes

#### Jobs
1. **test** — Automated test execution
   - Step: Checkout
   - Step: Setup Node.js
   - Step: Extract chat-lib
   - Step: Install chat-lib dependencies
   - Step: Build chat-lib
   - Step: Test chat-lib

**Secrets required:** none
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** Yes

### `chat-perf.yml` — MAINTAINER_ONLY
**Triggers:** workflow_dispatch
**Branches/Paths:** workflow_dispatch: custom filters
**Contributor visible:** No

#### Jobs
1. **setup** — Automated test execution
   - Step: Resolve test build type
   - Step: Checkout
   - Step: Setup Node.js
   - Step: Install system dependencies
   - Step: Install dependencies
   - Step: Install build dependencies
   - Step: Transpile source
   - Step: Build copilot extension
2. **chat-perf** — Build or packaging validation
   - Step: Checkout
   - Step: Setup Node.js
   - Step: Install system dependencies
   - Step: Install dependencies
   - Step: Download build output
   - Step: Restore Electron cache
   - Step: Download Electron
   - Step: Restore Playwright cache
3. **leak-check** — Build or packaging validation
   - Step: Checkout
   - Step: Setup Node.js
   - Step: Install system dependencies
   - Step: Install dependencies
   - Step: Download build output
   - Step: Restore Electron cache
   - Step: Download Electron
   - Step: Restore Playwright cache
4. **report** — Performance benchmarking
   - Step: Checkout
   - Step: Setup Node.js
   - Step: Download perf summary data
   - Step: Download leak results
   - Step: Generate unified summary
   - Step: Upload CI summary
   - Step: Fail on regression

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~45+ minutes
**Blocks PR merge:** No

### `component-fixture-tests.yml` — PR_CHECK
**Triggers:** push, pull_request
**Branches/Paths:** push: branches=main | pull_request: branches=main, release/*
**Contributor visible:** Partial (runs on PRs, but secret-backed steps are limited on forks)

#### Jobs
1. **component-fixture-tests** — Automated test execution
   - Step: Checkout
   - Step: Setup Node.js
   - Step: Install dependencies
   - Step: Install build dependencies
   - Step: Install rspack dependencies
   - Step: Transpile source
   - Step: Install Playwright test dependencies
   - Step: Install Playwright Chromium

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** Yes

### `copilot-setup-steps.yml` — PR_CHECK
**Triggers:** workflow_dispatch, push, pull_request
**Branches/Paths:** workflow_dispatch: default | push: paths=.github/workflows/copilot-setup-steps.yml | pull_request: paths=.github/workflows/copilot-setup-steps.yml
**Contributor visible:** Partial (runs on PRs, but secret-backed steps are limited on forks)

#### Jobs
1. **copilot-setup-steps** — Build or packaging validation
   - Step: Checkout microsoft/vscode
   - Step: Setup Node.js
   - Step: Setup system services
   - Step: Prepare node_modules cache key
   - Step: Restore node_modules cache
   - Step: Extract node_modules cache
   - Step: Install build dependencies
   - Step: Install dependencies

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** Yes

### `monaco-editor.yml` — PR_CHECK
**Triggers:** push, pull_request
**Branches/Paths:** push: branches=main, release/* | pull_request: branches=main, release/*
**Contributor visible:** Partial (runs on PRs, but secret-backed steps are limited on forks)

#### Jobs
1. **main** — Workflow-specific automation
   - Step: Use actions/checkout@v6
   - Step: Use actions/setup-node@v6
   - Step: Compute node modules cache key
   - Step: Cache node modules
   - Step: Get npm cache directory path
   - Step: Cache npm directory
   - Step: Install system dependencies
   - Step: Execute npm

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** Yes

### `no-engineering-system-changes.yml` — PR_CHECK
**Triggers:** pull_request
**Branches/Paths:** default event settings
**Contributor visible:** Partial (runs on PRs, but secret-backed steps are limited on forks)

#### Jobs
1. **main** — Workflow-specific automation
   - Step: Get file changes
   - Step: Check if engineering systems were modified
   - Step: Allow automated distro or version field updates
   - Step: Allow cherry-pick bot PRs
   - Step: Determine if engineering system changes are allowed
   - Step: Prevent Copilot from modifying engineering systems
   - Step: Use octokit/request-action@b91aabaa861c777dcdb14e2387e30eddf04619ae
   - Step: Set control output variable

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** Yes

### `pr-darwin-test.yml` — INFRA
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **macOS-test** — Automated test execution
   - Step: Checkout microsoft/vscode
   - Step: Setup Node.js
   - Step: Prepare node_modules cache key
   - Step: Restore node_modules cache
   - Step: Extract node_modules cache
   - Step: Install dependencies
   - Step: Create node_modules archive
   - Step: Create .build folder

**Secrets required:** secret:GITHUB_TOKEN, env:NPM_ARCH, env:VSCODE_ARCH
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** No

### `pr-linux-cli-test.yml` — INFRA
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **linux-cli-test** — Linting and style validation
   - Step: Checkout microsoft/vscode
   - Step: Install Rust
   - Step: Set Rust version
   - Step: Check Rust versions
   - Step: Clippy lint
   - Step: 🧪 Run unit tests

**Secrets required:** none
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** No

### `pr-linux-test.yml` — INFRA
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **linux-test** — Automated test execution
   - Step: Checkout microsoft/vscode
   - Step: Setup Node.js
   - Step: Setup system services
   - Step: Prepare node_modules cache key
   - Step: Restore node_modules cache
   - Step: Extract node_modules cache
   - Step: Install build dependencies
   - Step: Install dependencies

**Secrets required:** secret:GITHUB_TOKEN, env:NPM_ARCH, env:VSCODE_ARCH
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** No

### `pr-node-modules.yml` — MERGE_GATE
**Triggers:** push
**Branches/Paths:** push: branches=main
**Contributor visible:** No

#### Jobs
1. **compile** — Build or packaging validation
   - Step: Checkout microsoft/vscode
   - Step: Setup Node.js
   - Step: Prepare node_modules cache key
   - Step: Restore node_modules cache
   - Step: Extract node_modules cache
   - Step: Install build tools
   - Step: Install dependencies
   - Step: Create node_modules archive
2. **linux** — Build or packaging validation
   - Step: Checkout microsoft/vscode
   - Step: Setup Node.js
   - Step: Prepare node_modules cache key
   - Step: Restore node_modules cache
   - Step: Install build dependencies
   - Step: Install dependencies
   - Step: Create node_modules archive
3. **macOS** — Workflow-specific automation
   - Step: Checkout microsoft/vscode
   - Step: Setup Node.js
   - Step: Prepare node_modules cache key
   - Step: Restore node_modules cache
   - Step: Install dependencies
   - Step: Create node_modules archive
4. **windows** — Workflow-specific automation
   - Step: Checkout microsoft/vscode
   - Step: Setup Node.js
   - Step: Prepare node_modules cache key
   - Step: Restore node_modules cache
   - Step: Install dependencies
   - Step: Create node_modules archive

**Secrets required:** secret:VSCODE_OSS, env:NPM_ARCH, env:VSCODE_ARCH
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** No

### `pr-win32-test.yml` — INFRA
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **windows-test** — Automated test execution
   - Step: Checkout microsoft/vscode
   - Step: Setup Node.js
   - Step: Prepare node_modules cache key
   - Step: Restore node_modules cache
   - Step: Extract node_modules cache
   - Step: Install dependencies
   - Step: Create node_modules archive
   - Step: Create .build folder

**Secrets required:** secret:GITHUB_TOKEN, env:NPM_ARCH, env:VSCODE_ARCH
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** No

### `pr.yml` — PR_CHECK
**Triggers:** pull_request
**Branches/Paths:** pull_request: branches=main, release/*
**Contributor visible:** Partial (runs on PRs, but secret-backed steps are limited on forks)

#### Jobs
1. **compile** — Build or packaging validation
   - Step: Checkout microsoft/vscode
   - Step: Setup Node.js
   - Step: Prepare node_modules cache key
   - Step: Restore node_modules cache
   - Step: Extract node_modules cache
   - Step: Install build tools
   - Step: Install dependencies
   - Step: Create node_modules archive
2. **linux-cli-tests** — Automated test execution
   - Step: No explicit steps in this job body
3. **linux-electron-tests** — Automated test execution
   - Step: No explicit steps in this job body
4. **linux-browser-tests** — Automated test execution
   - Step: No explicit steps in this job body
5. **linux-remote-tests** — Automated test execution
   - Step: No explicit steps in this job body
6. **macos-electron-tests** — Automated test execution
   - Step: No explicit steps in this job body
7. **macos-browser-tests** — Automated test execution
   - Step: No explicit steps in this job body
8. **macos-remote-tests** — Automated test execution
   - Step: No explicit steps in this job body
9. **windows-electron-tests** — Automated test execution
   - Step: No explicit steps in this job body
10. **windows-browser-tests** — Automated test execution
   - Step: No explicit steps in this job body
11. **windows-remote-tests** — Automated test execution
   - Step: No explicit steps in this job body
12. **copilot-check-test-cache** — Automated test execution
   - Step: Checkout code
   - Step: Use actions/setup-node@v6
   - Step: Restore build cache
   - Step: Extract build cache
   - Step: Install dependencies
   - Step: Ensure no duplicate cache keys
   - Step: Ensure no untrusted cache changes
13. **copilot-check-telemetry** — Workflow-specific automation
   - Step: Checkout code
   - Step: Use actions/setup-node@v6
   - Step: Validate telemetry events
14. **copilot-linux-tests** — Automated test execution
   - Step: Checkout repository
   - Step: Setup Node.js
   - Step: Setup Python
   - Step: Setup .NET
   - Step: Install setuptools
   - Step: Install system dependencies
   - Step: Restore build cache
   - Step: Extract build cache
15. **copilot-windows-tests** — Automated test execution
   - Step: Checkout repository
   - Step: Setup Node.js
   - Step: Setup Python
   - Step: Setup .NET
   - Step: Install setuptools
   - Step: Restore build cache
   - Step: Extract build cache
   - Step: Install root dependencies

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~45+ minutes
**Blocks PR merge:** Yes

### `screenshot-test.yml` — PR_CHECK
**Triggers:** push, pull_request
**Branches/Paths:** push: branches=main | pull_request: branches=main, release/*
**Contributor visible:** Partial (runs on PRs, but secret-backed steps are limited on forks)

#### Jobs
1. **screenshots** — Build or packaging validation
   - Step: Checkout
   - Step: Setup Node.js
   - Step: Install dependencies
   - Step: Install build dependencies
   - Step: Install rspack dependencies
   - Step: Copy codicons
   - Step: Transpile source
   - Step: Install Playwright Chromium

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** Yes

### `sessions-e2e.yml` — MAINTAINER_ONLY
**Triggers:** workflow_dispatch
**Branches/Paths:** default event settings
**Contributor visible:** No

#### Jobs
1. **sessions-e2e** — Automated test execution
   - Step: Checkout
   - Step: Setup Node.js
   - Step: Install build tools
   - Step: Install dependencies
   - Step: Install build dependencies
   - Step: Transpile sources
   - Step: Install E2E test dependencies
   - Step: Install Playwright browsers

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** No

### `telemetry.yml` — PR_CHECK
**Triggers:** pull_request
**Branches/Paths:** default event settings
**Contributor visible:** Partial (runs on PRs, but secret-backed steps are limited on forks)

#### Jobs
1. **check-metadata** — Workflow-specific automation
   - Step: Use actions/checkout@v6
   - Step: Use actions/setup-node@v6
   - Step: Run vscode-telemetry-extractor

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** Yes

## Contributor Summary

New contributors should expect these workflows to matter most on their pull requests: api-proposal-version-check.yml, chat-lib-package.yml, component-fixture-tests.yml, copilot-setup-steps.yml, monaco-editor.yml, no-engineering-system-changes.yml, pr.yml, screenshot-test.yml, telemetry.yml. Workflows that are mainly for maintainers or release automation include chat-perf.yml, sessions-e2e.yml. To stay ahead of CI, contributors should at minimum run lint, run tests, verify builds. Release, publishing, scheduled maintenance, scorecard, and documentation deployment workflows are usually not something a first-time contributor needs to optimize for unless their change touches that surface. If a PR-visible workflow fails, the quickest path is to compare the failing job steps with the local equivalent command and then re-run only after reproducing or understanding the issue. The contributor experience in this repository is broad and explicit because the workflow files themselves expose most of the automation contract.

## Red Flags / Observations

- Potentially complex for newcomers: chat-perf.yml, pr.yml.
- Some workflows need more in-file explanation because job intent is not obvious from names alone: api-proposal-version-check.yml, monaco-editor.yml, no-engineering-system-changes.yml, pr-node-modules.yml, pr.yml, telemetry.yml.
- These may confuse fork-based contributors because they mix PR execution with restricted secrets or elevated contexts: component-fixture-tests.yml, copilot-setup-steps.yml, monaco-editor.yml, no-engineering-system-changes.yml, pr.yml, screenshot-test.yml.
- Good patterns Cacti can replicate: clearly separated PR checks such as api-proposal-version-check.yml, chat-lib-package.yml, component-fixture-tests.yml, copilot-setup-steps.yml, monaco-editor.yml, no-engineering-system-changes.yml.
