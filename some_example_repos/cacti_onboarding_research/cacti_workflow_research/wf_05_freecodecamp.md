# freeCodeCamp — Workflow Analysis

## Workflow Inventory
| File | Category | Trigger | Blocks PR? |
|------|----------|---------|------------|
| crowdin-download.client-ui.yml | SCHEDULED | workflow_dispatch, schedule | No |
| crowdin-upload.client-ui.yml | SCHEDULED | workflow_dispatch, schedule | No |
| crowdin-upload.curriculum.yml | SCHEDULED | workflow_dispatch, schedule | No |
| curriculum-i18n-submodule.yml | MERGE_GATE | push, workflow_dispatch | No |
| deploy-api.yml | MAINTAINER_ONLY | workflow_dispatch | No |
| deploy-client.yml | MAINTAINER_ONLY | workflow_dispatch | No |
| devcontainer-ci.yml | PR_CHECK | pull_request, workflow_dispatch | Yes |
| docker-docr-cleanup.yml | SCHEDULED | workflow_dispatch, schedule | No |
| docker-docr.yml | MAINTAINER_ONLY | workflow_dispatch, workflow_call | No |
| docker-ghcr.yml | MERGE_GATE | workflow_dispatch, push | No |
| e2e-playwright.yml | PR_CHECK | workflow_dispatch, pull_request | Yes |
| e2e-third-party.yml | MERGE_GATE | workflow_dispatch, push | No |
| github-autoclose.yml | INFRA | pull_request_target | Yes |
| github-labeler.yaml | INFRA | pull_request_target | Yes |
| github-lock-closed-prs.yml | MAINTAINER_ONLY | pull_request_target | Yes |
| github-no-i18n-via-prs.yml | MAINTAINER_ONLY | pull_request_target | Yes |
| github-pr-guidelines.yml | MAINTAINER_ONLY | pull_request_target | Yes |
| github-spam.yml | INFRA | pull_request_target | Yes |
| i18n-validate-builds.yml | MERGE_GATE | push | No |
| i18n-validate-prs.yml | PR_CHECK | pull_request | Yes |
| node.js-tests.yml | PR_CHECK | push, pull_request | Yes |

## Workflow Details

### `crowdin-download.client-ui.yml` — SCHEDULED
**Triggers:** workflow_dispatch, schedule
**Branches/Paths:** workflow_dispatch: default | schedule: {'cron': '15 12 * * 1,3'}
**Contributor visible:** No

#### Jobs
1. **i18n-download-client-ui-translations** — Translation or localization maintenance
   - Step: Checkout Source Files
   - Step: Generate Crowdin Config
   - Step: Crowdin Download Chinese Translations
   - Step: Convert Chinese
   - Step: Crowdin Download Espanol Translations
   - Step: Crowdin Download Italian Translations
   - Step: Crowdin Download Portuguese (Brazilian) Translations
   - Step: Crowdin Download Ukrainian Translations

**Secrets required:** secret:ACTIONS_CAMPERBOT_EMAIL, secret:CROWDIN_BASE_URL_FCC, secret:CROWDIN_CAMPERBOT_PAT, secret:CROWDIN_CAMPERBOT_SERVICE_TOKEN, secret:CROWDIN_PROJECT_ID_CLIENT
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** No

### `crowdin-upload.client-ui.yml` — SCHEDULED
**Triggers:** workflow_dispatch, schedule
**Branches/Paths:** workflow_dispatch: default | schedule: {'cron': '15 7 * * 1-5'}
**Contributor visible:** No

#### Jobs
1. **i18n-upload-client-ui-files** — Translation or localization maintenance
   - Step: Checkout Source Files
   - Step: Generate Crowdin Config
   - Step: Crowdin Upload

**Secrets required:** secret:CROWDIN_BASE_URL_FCC, secret:CROWDIN_CAMPERBOT_SERVICE_TOKEN, secret:CROWDIN_PROJECT_ID_ClIENT, secret:GITHUB_TOKEN
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** No

### `crowdin-upload.curriculum.yml` — SCHEDULED
**Triggers:** workflow_dispatch, schedule
**Branches/Paths:** workflow_dispatch: default | schedule: {'cron': '30 7 * * 1-5'}
**Contributor visible:** No

#### Jobs
1. **i18n-upload-curriculum-files** — Translation or localization maintenance
   - Step: Checkout Source Files
   - Step: Generate Crowdin Config
   - Step: Crowdin Upload
   - Step: Remove deleted files
   - Step: Hide Non-Translated Strings
   - Step: Hide a String
   - Step: Unhide Title of Use && For a More Concise Conditional

**Secrets required:** secret:CROWDIN_BASE_URL_FCC, secret:CROWDIN_CAMPERBOT_SERVICE_TOKEN, secret:CROWDIN_PROJECT_ID_CURRICULUM, secret:GITHUB_TOKEN
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** No

### `curriculum-i18n-submodule.yml` — MERGE_GATE
**Triggers:** push, workflow_dispatch
**Branches/Paths:** push: branches=chore/update-i18n-curriculum-submodule | workflow_dispatch: default
**Contributor visible:** No

#### Jobs
1. **test-curriculum** — Automated test execution
   - Step: Checkout
   - Step: Use Node.js ${{ matrix.node-version }}
   - Step: Install pnpm
   - Step: Setup Turbo Cache
   - Step: Set Environment variables
   - Step: Install node_modules
   - Step: Build Client in ${{ matrix.locale }}
   - Step: Install Chrome for Puppeteer

**Secrets required:** secret:TURBO_REMOTE_CACHE_SIGNATURE_KEY, secret:TURBO_TOKEN
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** No

### `deploy-api.yml` — MAINTAINER_ONLY
**Triggers:** workflow_dispatch
**Branches/Paths:** workflow_dispatch: custom filters
**Contributor visible:** No

#### Jobs
1. **setup-jobs** — Workflow-specific automation
   - Step: Setup
2. **build** — Build or packaging validation
   - Step: No explicit steps in this job body
3. **deploy** — Deployment automation
   - Step: Setup and connect to Tailscale network
   - Step: Wait for Tailscale Network Readiness
   - Step: Configure SSH & Check Connection
   - Step: Deploy with Docker Stack

**Secrets required:** secret:AGE_ENCRYPTED_ASC_SECRETS, secret:AGE_SECRET_KEY, secret:DIGITALOCEAN_ACCESS_TOKEN, secret:DOCR_NAME, secret:TS_MACHINE_NAME, secret:TS_OAUTH_CLIENT_ID, secret:TS_OAUTH_SECRET, secret:TS_USERNAME, secret:age
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** No

### `deploy-client.yml` — MAINTAINER_ONLY
**Triggers:** workflow_dispatch
**Branches/Paths:** workflow_dispatch: custom filters
**Contributor visible:** No

#### Jobs
1. **setup-jobs** — Workflow-specific automation
   - Step: Setup
2. **setup-matrix** — Workflow-specific automation
   - Step: Setup Matrix
3. **client** — Build or packaging validation
   - Step: Checkout
   - Step: Use Node.js ${{ matrix.node-version }}
   - Step: Install pnpm
   - Step: Language specific ENV - [${{ matrix.lang-name-full }}]
   - Step: Create deployment version
   - Step: Install and Build
   - Step: Tar Files
   - Step: Setup and connect to Tailscale network

**Secrets required:** secret:ALGOLIA_API_KEY, secret:ALGOLIA_APP_ID, secret:GROWTHBOOK_URI, secret:PATREON_CLIENT_ID, secret:PAYPAL_CLIENT_ID, secret:STRIPE_PUBLIC_KEY, secret:TS_MACHINE_NAME_PREFIX, secret:TS_OAUTH_CLIENT_ID, secret:TS_OAUTH_SECRET, secret:TS_USERNAME
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** No

### `devcontainer-ci.yml` — PR_CHECK
**Triggers:** pull_request, workflow_dispatch
**Branches/Paths:** pull_request: paths=.devcontainer/**, docker/devcontainer/** | workflow_dispatch: default
**Contributor visible:** Partial (runs on PRs, but secret-backed steps are limited on forks)

#### Jobs
1. **validate** — Build or packaging validation
   - Step: Checkout
   - Step: Login to GHCR
   - Step: Install devcontainer CLI
   - Step: Build devcontainer
   - Step: Start devcontainer
   - Step: Validate required tools
   - Step: Validate MongoDB replica set

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** Yes

### `docker-docr-cleanup.yml` — SCHEDULED
**Triggers:** workflow_dispatch, schedule
**Branches/Paths:** workflow_dispatch: default | schedule: {'cron': '5 0 * * 3,6'}
**Contributor visible:** No

#### Jobs
1. **remove** — Workflow-specific automation
   - Step: Install doctl
   - Step: Log in to DigitalOcean Container Registry with short-lived credentials
   - Step: Delete Images

**Secrets required:** secret:DIGITALOCEAN_ACCESS_TOKEN
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** No

### `docker-docr.yml` — MAINTAINER_ONLY
**Triggers:** workflow_dispatch, workflow_call
**Branches/Paths:** workflow_dispatch: custom filters | workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **build** — Build or packaging validation
   - Step: Checkout Source Files
   - Step: Create a tagname
   - Step: Set up Docker Buildx
   - Step: Install doctl
   - Step: Log in to DigitalOcean Container Registry with short-lived credentials
   - Step: Build & Push Image

**Secrets required:** secret:DIGITALOCEAN_ACCESS_TOKEN, secret:DOCR_NAME, env:tagname
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** No

### `docker-ghcr.yml` — MERGE_GATE
**Triggers:** workflow_dispatch, push
**Branches/Paths:** workflow_dispatch: default | push: branches=main; paths=pnpm-lock.yaml, docker/devcontainer/**, .github/workflows/docker-ghcr.yml
**Contributor visible:** No

#### Jobs
1. **build-and-push** — Build or packaging validation
   - Step: Checkout
   - Step: Set up QEMU
   - Step: Set up Docker Buildx
   - Step: Log in to GHCR
   - Step: Build and push images

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** No

### `e2e-playwright.yml` — PR_CHECK
**Triggers:** workflow_dispatch, pull_request
**Branches/Paths:** workflow_dispatch: default | pull_request: branches=main, temp-**
**Contributor visible:** Partial (runs on PRs, but secret-backed steps are limited on forks)

#### Jobs
1. **build-client** — Build or packaging validation
   - Step: Checkout
   - Step: Use Node.js ${{ matrix.node-version }}
   - Step: Install pnpm
   - Step: Setup Turbo Cache
   - Step: Checkout client-config
   - Step: Set freeCodeCamp Environment Variables
   - Step: Install and Build
   - Step: Move serve.json to Public Folder
2. **build-api** — Build or packaging validation
   - Step: Checkout Source Files
   - Step: Create Image
   - Step: Save Image
   - Step: Upload API Artifact
3. **playwright-run** — Automated test execution
   - Step: Set Action Environment Variables
   - Step: Checkout Source Files
   - Step: Download Client Artifact
   - Step: Download Api Artifact
   - Step: Load API Image
   - Step: Use Node.js ${{ matrix.node-version }}
   - Step: Install pnpm
   - Step: Install Dependencies

**Secrets required:** secret:GITHUB_TOKEN, secret:TURBO_REMOTE_CACHE_SIGNATURE_KEY, secret:TURBO_TOKEN
**Estimated run time:** ~45+ minutes
**Blocks PR merge:** Yes

### `e2e-third-party.yml` — MERGE_GATE
**Triggers:** workflow_dispatch, push
**Branches/Paths:** workflow_dispatch: default | push: branches=prod-**
**Contributor visible:** No

#### Jobs
1. **build-client** — Build or packaging validation
   - Step: Checkout Source Files
   - Step: Checkout client-config
   - Step: Setup pnpm
   - Step: Use Node.js ${{ matrix.node-version }}
   - Step: Set freeCodeCamp Environment Variables
   - Step: Install and Build
   - Step: Move serve.json to Public Folder
   - Step: Tar Files
2. **build-api** — Build or packaging validation
   - Step: Checkout Source Files
   - Step: Create Image
   - Step: Save Image
   - Step: Upload API Artifact
3. **playwright-run-api** — Automated test execution
   - Step: Set Action Environment Variables
   - Step: Checkout Source Files
   - Step: Use actions/download-artifact@3e5f45b2cfb9172054b4087a40e8e0b5a5461e7c
   - Step: Unpack Client Artifact
   - Step: Load API Image
   - Step: Setup pnpm
   - Step: Use Node.js ${{ matrix.node-version }}
   - Step: Install Dependencies

**Secrets required:** secret:GITHUB_TOKEN, secret:PATREON_CLIENT_ID, secret:PAYPAL_CLIENT_ID, secret:STRIPE_PUBLIC_KEY
**Estimated run time:** ~45+ minutes
**Blocks PR merge:** No

### `github-autoclose.yml` — INFRA
**Triggers:** pull_request_target
**Branches/Paths:** pull_request_target: branches=main; paths=.gitignore
**Contributor visible:** Partial (PR context with elevated maintainer-owned workflow)

#### Jobs
1. **autoclose** — Workflow-specific automation
   - Step: Use actions/github-script@3a2844b7e9c422d3c10d287c895573f7108da1b3

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** Yes

### `github-labeler.yaml` — INFRA
**Triggers:** pull_request_target
**Branches/Paths:** default event settings
**Contributor visible:** Partial (PR context with elevated maintainer-owned workflow)

#### Jobs
1. **triage** — Repository automation or labeling
   - Step: Use actions/labeler@634933edcd8ababfe52f92936142cc22ac488b1b

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** Yes

### `github-lock-closed-prs.yml` — MAINTAINER_ONLY
**Triggers:** pull_request_target
**Branches/Paths:** pull_request_target: types=closed
**Contributor visible:** Partial (PR context with elevated maintainer-owned workflow)

#### Jobs
1. **lock** — Workflow-specific automation
   - Step: Use actions/github-script@3a2844b7e9c422d3c10d287c895573f7108da1b3

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** Yes

### `github-no-i18n-via-prs.yml` — MAINTAINER_ONLY
**Triggers:** pull_request_target
**Branches/Paths:** pull_request_target: branches=main; paths=client/i18n/locales/**/intro.json, client/i18n/locales/**/translations.json, !client/i18n/locales/english/**
**Contributor visible:** Partial (PR context with elevated maintainer-owned workflow)

#### Jobs
1. **has-translation** — Workflow-specific automation
   - Step: Use actions/github-script@3a2844b7e9c422d3c10d287c895573f7108da1b3

**Secrets required:** secret:CAMPERBOT_NO_TRANSLATE
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** Yes

### `github-pr-guidelines.yml` — MAINTAINER_ONLY
**Triggers:** pull_request_target
**Branches/Paths:** pull_request_target: types=opened, reopened, edited
**Contributor visible:** Partial (PR context with elevated maintainer-owned workflow)

#### Jobs
1. **no-web-commits** — Repository automation or labeling
   - Step: Use actions/checkout@de0fac2e4500dabe0009e67214ff5f5447ce83dd
   - Step: Check if PR author is allow-listed
   - Step: Check if commits are made on GitHub Web UI
   - Step: Add comment on PR if commits are made on GitHub Web UI
   - Step: Add deprioritized label
2. **fix-pr-title** — Workflow-specific automation
   - Step: Use actions/checkout@de0fac2e4500dabe0009e67214ff5f5447ce83dd
   - Step: Use actions/github-script@3a2844b7e9c422d3c10d287c895573f7108da1b3
3. **check-pr-template** — Workflow-specific automation
   - Step: Use actions/checkout@de0fac2e4500dabe0009e67214ff5f5447ce83dd
   - Step: Use actions/github-script@3a2844b7e9c422d3c10d287c895573f7108da1b3
4. **check-linked-issue** — Workflow-specific automation
   - Step: Use actions/checkout@de0fac2e4500dabe0009e67214ff5f5447ce83dd
   - Step: Use actions/github-script@3a2844b7e9c422d3c10d287c895573f7108da1b3
5. **report** — Workflow-specific automation
   - Step: Use actions/checkout@de0fac2e4500dabe0009e67214ff5f5447ce83dd
   - Step: Use actions/github-script@3a2844b7e9c422d3c10d287c895573f7108da1b3

**Secrets required:** secret:CAMPERBOT_NO_TRANSLATE, secret:GITHUB_TOKEN
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** Yes

### `github-spam.yml` — INFRA
**Triggers:** pull_request_target
**Branches/Paths:** pull_request_target: types=labeled
**Contributor visible:** Partial (PR context with elevated maintainer-owned workflow)

#### Jobs
1. **is-spam** — Workflow-specific automation
   - Step: Use actions/github-script@3a2844b7e9c422d3c10d287c895573f7108da1b3

**Secrets required:** secret:CAMPERBOT_NO_TRANSLATE
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** Yes

### `i18n-validate-builds.yml` — MERGE_GATE
**Triggers:** push
**Branches/Paths:** push: branches=main
**Contributor visible:** No

#### Jobs
1. **ci** — Build or packaging validation
   - Step: Checkout
   - Step: Use Node.js ${{ matrix.node-version }}
   - Step: Install pnpm
   - Step: Setup Turbo Cache
   - Step: Set freeCodeCamp Environment Variables
   - Step: Install Dependencies
   - Step: Validate Challenge Files

**Secrets required:** secret:TURBO_REMOTE_CACHE_SIGNATURE_KEY, secret:TURBO_TOKEN
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** No

### `i18n-validate-prs.yml` — PR_CHECK
**Triggers:** pull_request
**Branches/Paths:** pull_request: branches=main
**Contributor visible:** Partial (runs on PRs, but secret-backed steps are limited on forks)

#### Jobs
1. **ci** — Build or packaging validation
   - Step: Checkout
   - Step: Use Node.js ${{ matrix.node-version }}
   - Step: Install pnpm
   - Step: Set freeCodeCamp Environment Variables
   - Step: Install Dependencies
   - Step: Validate Challenge Files
   - Step: Create Comment

**Secrets required:** secret:CAMPERBOT_NO_TRANSLATE
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** Yes

### `node.js-tests.yml` — PR_CHECK
**Triggers:** push, pull_request
**Branches/Paths:** push: branches=main, prod-**, renovate/**, hotfix-**, temp-** | pull_request: branches=main, temp-**
**Contributor visible:** Partial (runs on PRs, but secret-backed steps are limited on forks)

#### Jobs
1. **lint** — Linting and style validation
   - Step: Checkout
   - Step: Check number of lockfiles
   - Step: Check format of sample.env
   - Step: Use Node.js ${{ matrix.node-version }}
   - Step: Install pnpm
   - Step: Setup Turbo Cache
   - Step: Set Environment variables
   - Step: Install node_modules
2. **build** — Build or packaging validation
   - Step: Checkout
   - Step: Use Node.js ${{ matrix.node-version }}
   - Step: Install pnpm
   - Step: Setup Turbo Cache
   - Step: Set freeCodeCamp Environment Variables
   - Step: Install and Build
3. **test** — Automated test execution
   - Step: Checkout
   - Step: Use Node.js ${{ matrix.node-version }}
   - Step: Install pnpm
   - Step: Setup Turbo Cache
   - Step: Set Environment variables
   - Step: Start MongoDB
   - Step: Install Dependencies
   - Step: Install Chrome for Puppeteer
4. **test-upcoming** — Automated test execution
   - Step: Checkout
   - Step: Use Node.js ${{ matrix.node-version }}
   - Step: Install pnpm
   - Step: Setup Turbo Cache
   - Step: Set Environment variables
   - Step: Start MongoDB
   - Step: Install Dependencies
   - Step: Install Chrome for Puppeteer
5. **test-localization** — Automated test execution
   - Step: Checkout
   - Step: Use Node.js ${{ matrix.node-version }}
   - Step: Install pnpm
   - Step: Setup Turbo Cache
   - Step: Set Environment variables
   - Step: Start MongoDB
   - Step: Install Dependencies
   - Step: Build Client in ${{ matrix.locale }}

**Secrets required:** secret:TURBO_REMOTE_CACHE_SIGNATURE_KEY, secret:TURBO_TOKEN
**Estimated run time:** ~45+ minutes
**Blocks PR merge:** Yes

## Contributor Summary

New contributors should expect these workflows to matter most on their pull requests: devcontainer-ci.yml, e2e-playwright.yml, github-autoclose.yml, github-labeler.yaml, github-lock-closed-prs.yml, github-no-i18n-via-prs.yml, github-pr-guidelines.yml, github-spam.yml, i18n-validate-prs.yml, node.js-tests.yml. Workflows that are mainly for maintainers or release automation include deploy-api.yml, deploy-client.yml, docker-docr.yml, github-lock-closed-prs.yml, github-no-i18n-via-prs.yml, github-pr-guidelines.yml. To stay ahead of CI, contributors should at minimum run lint, run tests, verify builds. Release, publishing, scheduled maintenance, scorecard, and documentation deployment workflows are usually not something a first-time contributor needs to optimize for unless their change touches that surface. If a PR-visible workflow fails, the quickest path is to compare the failing job steps with the local equivalent command and then re-run only after reproducing or understanding the issue. The contributor experience in this repository is broad and explicit because the workflow files themselves expose most of the automation contract.

## Red Flags / Observations

- Potentially complex for newcomers: e2e-playwright.yml, e2e-third-party.yml, node.js-tests.yml.
- Some workflows need more in-file explanation because job intent is not obvious from names alone: deploy-api.yml, deploy-client.yml, docker-docr-cleanup.yml, github-autoclose.yml, github-lock-closed-prs.yml, github-no-i18n-via-prs.yml.
- These may confuse fork-based contributors because they mix PR execution with restricted secrets or elevated contexts: devcontainer-ci.yml, e2e-playwright.yml, github-autoclose.yml, github-labeler.yaml, github-lock-closed-prs.yml, github-no-i18n-via-prs.yml.
- Good patterns Cacti can replicate: clearly separated PR checks such as devcontainer-ci.yml, e2e-playwright.yml, i18n-validate-prs.yml, node.js-tests.yml.
