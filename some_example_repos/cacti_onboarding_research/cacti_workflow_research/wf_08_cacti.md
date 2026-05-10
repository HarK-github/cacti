# Hyperledger Cacti — Workflow Analysis

## Workflow Inventory
| File | Category | Trigger | Blocks PR? |
|------|----------|---------|------------|
| .dast-nuclei-cmd-api-server.yaml | PR_CHECK | push, pull_request | Yes |
| actionlint.yaml | INFRA | workflow_call | No |
| ai-config-lint.yaml | PR_CHECK | pull_request | Yes |
| all-nodejs-packages-publish.yaml | RELEASE | push, workflow_dispatch | No |
| besu-all-in-one-publish.yaml | RELEASE | push | No |
| cacti-dev-container-vscode-publish.yaml | RELEASE | push | No |
| checks-and-build.yaml | INFRA | workflow_call | No |
| ci.yaml | SCHEDULED | pull_request, workflow_dispatch, schedule | Yes |
| ci_weaver.yaml | SCHEDULED | workflow_dispatch, push, pull_request, schedule | Yes |
| cmd-api-server-publish.yaml | RELEASE | push | No |
| code-quality-checks.yaml | INFRA | workflow_call | No |
| codeql-analysis.yml | SCHEDULED | push, pull_request, schedule | Yes |
| commitlint-pull-request.yaml | INFRA | pull_request | Yes |
| connector-besu-publish.yaml | RELEASE | push | No |
| connector-corda-server-publish.yaml | RELEASE | push | No |
| connector-fabric-cli-publish-dev.yaml | RELEASE | workflow_call, workflow_dispatch | No |
| connector-fabric-cli-publish.yaml | RELEASE | push | No |
| connector-fabric-publish.yaml | RELEASE | push | No |
| connector-packages-workflow.yaml | DOCS | workflow_call | No |
| core-packages-workflow.yaml | DOCS | workflow_call | No |
| coverage_ts.yaml | INFRA | workflow_run | No |
| daml-all-in-one-publish.yaml | RELEASE | push | No |
| deploy_docs.yml | DOCS | push, workflow_dispatch | No |
| dev-container-vscode-publish.yaml | RELEASE | push | No |
| example-carbon-accounting-publish.yaml | RELEASE | push | No |
| example-supply-chain-app-publish.yaml | RELEASE | push | No |
| examples-workflow.yaml | INFRA | workflow_call | No |
| fabric2-all-in-one-publish.yaml | RELEASE | push | No |
| geth-all-in-one-publish.yaml | RELEASE | push | No |
| gg-shield-action.yaml | PR_CHECK | push, pull_request | Yes |
| ghcr-workflow.yaml | INFRA | workflow_call | No |
| ghpkg-all-kotlin-api-clients-publish.yaml | RELEASE | push | No |
| htlc-packages-workflow.yaml | INFRA | workflow_call | No |
| iroha2-all-in-one-publish.yaml | RELEASE | push | No |
| keychain-packages-workflow.yaml | INFRA | workflow_call | No |
| keychain-vault-server-publish.yaml | RELEASE | push | No |
| other-packages-workflow.yaml | INFRA | workflow_call | No |
| packages-workflow.yaml | INFRA | workflow_call | No |
| publish-npm.yaml | RELEASE | workflow_dispatch | No |
| satp-hermes-build.yaml | INFRA | workflow_call | No |
| satp-hermes-codegen.yaml | INFRA | workflow_call | No |
| satp-hermes-docs.yaml | DOCS | workflow_call, workflow_dispatch | No |
| satp-hermes-ghcr-gateway-sdk.yaml | INFRA | workflow_call | No |
| satp-hermes-lint.yaml | INFRA | workflow_call | No |
| satp-hermes-npmjs-gateway-sdk.yaml | MERGE_GATE | push, workflow_dispatch, workflow_call | No |
| satp-hermes-publish.yaml | RELEASE | workflow_call | No |
| satp-hermes-release.yaml | RELEASE | workflow_call, workflow_dispatch | No |
| satp-hermes-workflow.yaml | INFRA | workflow_call | No |
| sawtooth-all-in-one-publish.yaml | RELEASE | push | No |
| scorecard.yml | SCHEDULED | branch_protection_rule, schedule, push | No |
| semantic-pull-request.yaml | INFRA | pull_request | Yes |
| test_weaver-asset-exchange-besu.yaml | INFRA | workflow_call | No |
| test_weaver-asset-exchange-corda.yaml | INFRA | workflow_call | No |
| test_weaver-asset-exchange-fabric.yaml | INFRA | workflow_call | No |
| test_weaver-asset-transfer.yaml | INFRA | workflow_call | No |
| test_weaver-corda-interop-app.yaml | INFRA | workflow_call | No |
| test_weaver-data-sharing.yaml | INFRA | workflow_call | No |
| test_weaver-docker-build.yaml | INFRA | workflow_call | No |
| test_weaver-fabric-fabric-satp.yaml | INFRA | workflow_call | No |
| test_weaver-go.yaml | INFRA | workflow_call | No |
| test_weaver-node-pkgs.yaml | INFRA | workflow_call | No |
| test_weaver-pre-release.yaml | RELEASE | workflow_call | No |
| test_weaver-relay.yaml | INFRA | workflow_call | No |
| weaver_deploy_corda-pkgs.yml | MERGE_GATE | push, workflow_dispatch | No |
| weaver_deploy_go-pkgs.yml | MERGE_GATE | push, workflow_dispatch | No |
| weaver_deploy_node-pkgs.yml | MERGE_GATE | push, workflow_dispatch | No |
| weaver_deploy_relay-server.yml | MERGE_GATE | push, workflow_dispatch | No |
| workflow-copm.yaml | INFRA | workflow_call | No |

## Workflow Details

### `.dast-nuclei-cmd-api-server.yaml` — PR_CHECK
**Triggers:** push, pull_request
**Branches/Paths:** push: branches=main, dev | pull_request: branches=main, dev
**Contributor visible:** Yes

#### Jobs
1. **nuclei-scan** — Workflow-specific automation
   - Step: Set up NodeJS ${{ env.NODEJS_VERSION }}
   - Step: Install jq
   - Step: Verify jq
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: CI environment clean-up
   - Step: Use actions/setup-go@4d34df0c2316fe8122ab82dc22947d607c0c91f9
   - Step: Run `go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@v3.3.5`
   - Step: Run `nuclei --version`

**Secrets required:** env:NODEJS_VERSION, env:audience, env:dast_jwt, env:issuer
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** Yes

### `actionlint.yaml` — INFRA
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: default
**Contributor visible:** No

#### Jobs
1. **Lint_GitHub_Actions** — Linting and style validation
   - Step: git_clone
   - Step: wipe_non_yaml_sources
   - Step: wipe_files_with_false_positives
   - Step: Set env.CACTI_ACTIONLINT_FILES_TO_LINT
   - Step: Print env.CACTI_ACTIONLINT_FILES_TO_LINT
   - Step: Print Line-byLine env.CACTI_ACTIONLINT_FILES_TO_LINT
   - Step: actionlint
   - Step: actionlint_summary

**Secrets required:** env:CACTI_ACTIONLINT_FILES_TO_LINT
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** No

### `ai-config-lint.yaml` — PR_CHECK
**Triggers:** pull_request
**Branches/Paths:** pull_request: paths=.github/agents/**, .github/skills/**, .github/instructions/**, tools/ai-config-lint.mjs
**Contributor visible:** Yes

#### Jobs
1. **lint-ai-config** — Linting and style validation
   - Step: Checkout
   - Step: Setup Node.js
   - Step: Run AI config linter

**Secrets required:** none
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** Yes

### `all-nodejs-packages-publish.yaml` — RELEASE
**Triggers:** push, workflow_dispatch
**Branches/Paths:** push: tags=v* | workflow_dispatch: custom filters
**Contributor visible:** No

#### Jobs
1. **build-and-publish-packages** — Build or packaging validation
   - Step: Check Version Format in Tag
   - Step: Fail if version is invalid
   - Step: Print Workflow inputs.GIT_TAG_TO_PUBLISH
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Run `git fetch --unshallow --prune`
   - Step: Run `git status --long --verbose`
   - Step: Use actions/setup-node@1e60f620b9541d16bece96c5465dc8ee9832be0b
   - Step: Run `cat /home/runner/work/_temp/.npmrc`

**Secrets required:** secret:GITHUB_TOKEN, secret:NPM_TOKEN, env:NODEJS_VERSION
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** No

### `besu-all-in-one-publish.yaml` — RELEASE
**Triggers:** push
**Branches/Paths:** push: tags=v*
**Contributor visible:** No

#### Jobs
1. **build-tag-push-container** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Build image
   - Step: Log in to registry
   - Step: Push image

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** No

### `cacti-dev-container-vscode-publish.yaml` — RELEASE
**Triggers:** push
**Branches/Paths:** push: tags=v*
**Contributor visible:** No

#### Jobs
1. **build-tag-push-container** — Build or packaging validation
   - Step: Use Node.js ${{ env.NODEJS_VERSION }}
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: npm_install_@devcontainers/cli@0.44.0
   - Step: npx_yes_devcontainers_cli_build
   - Step: Log in to registry
   - Step: Push image

**Secrets required:** secret:GITHUB_TOKEN, env:NODEJS_VERSION
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** No

### `checks-and-build.yaml` — INFRA
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **ActionLint** — Linting and style validation
   - Step: No explicit steps in this job body
2. **DCI-Lint** — Linting and style validation
   - Step: Lint Git Repo
   - Step: Get the output response
3. **check-coverage** — Coverage collection and reporting
   - Step: Use actions/checkout@v5
   - Step: Set output
4. **build-dev** — Build or packaging validation
   - Step: Use actions/checkout@v5
   - Step: build
5. **compute-changed-packages** — Workflow-specific automation
   - Step: Use actions/checkout@v5
   - Step: Set up Node.js
   - Step: Compute Affected Packages

**Secrets required:** env:RUN_CODE_COVERAGE
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** No

### `ci.yaml` — SCHEDULED
**Triggers:** pull_request, workflow_dispatch, schedule
**Branches/Paths:** pull_request: branches=main, dev | workflow_dispatch: default | schedule: {'cron': '0 8 * * 1,4'}
**Contributor visible:** Yes

#### Jobs
1. **env-setup** — Coverage collection and reporting
   - Step: Set Node Version Output
   - Step: Set Run Code Coverage Output
   - Step: Set Run Trivy Scan Output
2. **checks-and-build** — Build or packaging validation
   - Step: No explicit steps in this job body
3. **code-quality-checks** — Workflow-specific automation
   - Step: No explicit steps in this job body
4. **packages-workflow** — Workflow-specific automation
   - Step: No explicit steps in this job body
5. **examples-workflow** — Workflow-specific automation
   - Step: No explicit steps in this job body
6. **ghcr-workflow** — Workflow-specific automation
   - Step: No explicit steps in this job body

**Secrets required:** env:NODEJS_VERSION, env:RUN_CODE_COVERAGE, env:RUN_TRIVY_SCAN
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** Yes

### `ci_weaver.yaml` — SCHEDULED
**Triggers:** workflow_dispatch, push, pull_request, schedule
**Branches/Paths:** workflow_dispatch: default | push: branches=main | pull_request: branches=main | schedule: {'cron': '0 1 1 * *'}
**Contributor visible:** Yes

#### Jobs
1. **fabric-fabric-satp** — Workflow-specific automation
   - Step: No explicit steps in this job body
2. **asset-exchange-corda** — Workflow-specific automation
   - Step: No explicit steps in this job body
3. **asset-transfer** — Workflow-specific automation
   - Step: No explicit steps in this job body
4. **relay** — Workflow-specific automation
   - Step: No explicit steps in this job body
5. **corda-interop-app** — Workflow-specific automation
   - Step: No explicit steps in this job body
6. **pre-release** — Release or publishing automation
   - Step: No explicit steps in this job body
7. **asset-exchange-fabric** — Workflow-specific automation
   - Step: No explicit steps in this job body
8. **data-sharing** — Workflow-specific automation
   - Step: No explicit steps in this job body
9. **node-pkgs** — Workflow-specific automation
   - Step: No explicit steps in this job body
10. **docker-build** — Build or packaging validation
   - Step: No explicit steps in this job body
11. **asset-exchange-besu** — Workflow-specific automation
   - Step: No explicit steps in this job body
12. **go** — Workflow-specific automation
   - Step: No explicit steps in this job body

**Secrets required:** none
**Estimated run time:** ~45+ minutes
**Blocks PR merge:** Yes

### `cmd-api-server-publish.yaml` — RELEASE
**Triggers:** push
**Branches/Paths:** push: tags=v*
**Contributor visible:** No

#### Jobs
1. **build-tag-push-container** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Build image
   - Step: Log in to registry
   - Step: Push image

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** No

### `code-quality-checks.yaml` — INFRA
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **yarn_lint** — Linting and style validation
   - Step: Use actions/checkout@v5
   - Step: build
   - Step: Run `git status --porcelain`
   - Step: Run `git status --porcelain | wc -l`
   - Step: Run `yarn lint`
   - Step: Run `git status --porcelain`
   - Step: Run `git status --porcelain | wc -l`
   - Step: Set env.GIT_INDEX_FILE_COUNT
2. **yarn_codegen** — Build or packaging validation
   - Step: Use actions/checkout@v5
   - Step: CI environment clean-up
   - Step: Install Foundry
   - Step: build
   - Step: Run `git status --porcelain`
   - Step: Run `git status --porcelain | wc -l`
   - Step: Cache OpenAPI Generator JAR
   - Step: Install protoc
3. **yarn_custom_checks** — Build or packaging validation
   - Step: Use actions/checkout@v5
   - Step: build
   - Step: Run Custom Checks
4. **yarn_tools_validate_bundle_names** — Build or packaging validation
   - Step: Use actions/checkout@v5
   - Step: build
   - Step: Run Bundle Names Validation

**Secrets required:** env:GIT_INDEX_FILE_COUNT
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** No

### `codeql-analysis.yml` — SCHEDULED
**Triggers:** push, pull_request, schedule
**Branches/Paths:** push: branches=main | pull_request: branches=main | schedule: {'cron': '0 11 * * 1'}
**Contributor visible:** Yes

#### Jobs
1. **analyze** — Build or packaging validation
   - Step: Checkout repository
   - Step: Run `git checkout HEAD^2`
   - Step: Initialize CodeQL
   - Step: Autobuild
   - Step: Perform CodeQL Analysis

**Secrets required:** none
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** Yes

### `commitlint-pull-request.yaml` — INFRA
**Triggers:** pull_request
**Branches/Paths:** default event settings
**Contributor visible:** Yes

#### Jobs
1. **commitlint** — Linting and style validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Display commit messages with line details
   - Step: Use wagoid/commitlint-github-action@b948419dd99f3fd78a6548d48f94e3df7f6bf3ed

**Secrets required:** none
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** Yes

### `connector-besu-publish.yaml` — RELEASE
**Triggers:** push
**Branches/Paths:** push: tags=v*
**Contributor visible:** No

#### Jobs
1. **build-tag-push-container** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Build image
   - Step: Log in to registry
   - Step: Push image

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** No

### `connector-corda-server-publish.yaml` — RELEASE
**Triggers:** push
**Branches/Paths:** push: tags=v*
**Contributor visible:** No

#### Jobs
1. **build-tag-push-container** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Build image
   - Step: Log in to registry
   - Step: Push image

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** No

### `connector-fabric-cli-publish-dev.yaml` — RELEASE
**Triggers:** workflow_call, workflow_dispatch
**Branches/Paths:** workflow_call: custom filters | workflow_dispatch: default
**Contributor visible:** No

#### Jobs
1. **pr-build-container** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Build image (PR)
   - Step: Log in to registry
   - Step: Push image

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** No

### `connector-fabric-cli-publish.yaml` — RELEASE
**Triggers:** push
**Branches/Paths:** push: tags=v*
**Contributor visible:** No

#### Jobs
1. **build-tag-push-container** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Build image
   - Step: Log in to registry
   - Step: Push image

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** No

### `connector-fabric-publish.yaml` — RELEASE
**Triggers:** push
**Branches/Paths:** push: tags=v*
**Contributor visible:** No

#### Jobs
1. **build-tag-push-container** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Build image
   - Step: Log in to registry
   - Step: Push image

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** No

### `connector-packages-workflow.yaml` — DOCS
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **cpl-connector-besu** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: CI environment clean-up
   - Step: Use ./.github/actions/docker-pull/
   - Step: Use ./.github/actions/docker-pull/
   - Step: build
   - Step: Run Jest Tests
   - Step: Run Tape Tests
   - Step: Upload coverage reports as artifacts
2. **cpl-connector-polkadot** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
3. **cpl-connector-corda** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Run Tape Tests
   - Step: Upload coverage reports as artifacts
   - Step: build cacti-connector-corda-server-dev.jar
   - Step: Run Trivy vulnerability scan for cactus-connector-corda-server
4. **cpl-connector-fabric** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: CI environment clean-up
   - Step: Use ./.github/actions/docker-pull/
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
5. **cpl-connector-iroha2** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
6. **cpl-connector-ethereum** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
7. **cpl-connector-sawtooth** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
8. **cpl-connector-xdai** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Run Tape Tests
   - Step: Upload coverage reports as artifacts
9. **ctp-ledger-connector-besu** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: CI environment clean-up
   - Step: Use ./.github/actions/docker-pull/
   - Step: Use ./.github/actions/docker-pull/
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
10. **ctp-ledger-connector-ethereum** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
11. **cactus-verifier-client** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
12. **cpl-connector-aries** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
13. **cpl-connector-stellar** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts

**Secrets required:** secret:GITHUB_TOKEN, env:JEST_TEST_COVERAGE_PATH, env:JEST_TEST_PATTERN, env:TAPE_TEST_PATTERN
**Estimated run time:** ~45+ minutes
**Blocks PR merge:** No

### `core-packages-workflow.yaml` — DOCS
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **cactus-api-client** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
2. **cactus-cmd-api-server** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: CI environment clean-up
   - Step: build
   - Step: Run Jest Tests
   - Step: Run Tape Tests
   - Step: Upload coverage reports as artifacts
   - Step: build_ncc_bundle
   - Step: ghcr.io/hyperledger/cactus-cmd-api-server
3. **cactus-common** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
4. **cactus-core-api** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
5. **cactus-core** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
6. **ct-api-client** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
7. **ct-cmd-api-server** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
8. **cactus-test-tooling** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: CI environment clean-up
   - Step: Use ./.github/actions/docker-pull/
   - Step: Use ./.github/actions/docker-pull/
   - Step: build
   - Step: Run Jest Tests
   - Step: Run Tape Tests
   - Step: Upload coverage reports as artifacts

**Secrets required:** secret:GITHUB_TOKEN, env:JEST_TEST_COVERAGE_PATH, env:JEST_TEST_PATTERN, env:TAPE_TEST_PATTERN
**Estimated run time:** ~45+ minutes
**Blocks PR merge:** No

### `coverage_ts.yaml` — INFRA
**Triggers:** workflow_run
**Branches/Paths:** workflow_run: types=completed
**Contributor visible:** No

#### Jobs
1. **generate_coverage_report** — Coverage collection and reporting
   - Step: Check out repository
   - Step: Set up Node.js
   - Step: Restore Yarn Cache
   - Step: Install dependencies and istanbul-merge
   - Step: Download coverage reports
   - Step: Merge and generate coverage reports
   - Step: Upload coverage reports to Codecov

**Secrets required:** secret:CODECOV_TOKEN, secret:GITHUB_TOKEN, env:NODEJS_VERSION
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** No

### `daml-all-in-one-publish.yaml` — RELEASE
**Triggers:** push
**Branches/Paths:** push: tags=v*
**Contributor visible:** No

#### Jobs
1. **build-tag-push-container** — Build or packaging validation
   - Step: Use actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11
   - Step: Build image
   - Step: Log in to registry
   - Step: Push image

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** No

### `deploy_docs.yml` — DOCS
**Triggers:** push, workflow_dispatch
**Branches/Paths:** push: branches=main; paths=docs/**, packages/cactus-plugin-satp-hermes/docs/** | workflow_dispatch: default
**Contributor visible:** No

#### Jobs
1. **deploy-docs** — Build or packaging validation
   - Step: Use Node.js ${{ env.NODEJS_VERSION }}
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Use Python 3.x
   - Step: Install dependencies
   - Step: Install system dependencies for Mermaid diagrams
   - Step: Build packages
   - Step: Build SATP Hermes diagrams
   - Step: Copy SATP Hermes docs to mkdocs

**Secrets required:** secret:GITHUB_TOKEN, env:NODEJS_VERSION
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** No

### `dev-container-vscode-publish.yaml` — RELEASE
**Triggers:** push
**Branches/Paths:** push: tags=v*
**Contributor visible:** No

#### Jobs
1. **build-tag-push-container** — Build or packaging validation
   - Step: Use Node.js ${{ env.NODEJS_VERSION }}
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: npm_install_@devcontainers/cli@0.44.0
   - Step: npx_yes_devcontainers_cli_build
   - Step: Log in to registry
   - Step: Push image

**Secrets required:** secret:GITHUB_TOKEN, env:NODEJS_VERSION
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** No

### `example-carbon-accounting-publish.yaml` — RELEASE
**Triggers:** push
**Branches/Paths:** push: tags=v*
**Contributor visible:** No

#### Jobs
1. **build-tag-push-container** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Build image
   - Step: Log in to registry
   - Step: Push image

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** No

### `example-supply-chain-app-publish.yaml` — RELEASE
**Triggers:** push
**Branches/Paths:** push: tags=v*
**Contributor visible:** No

#### Jobs
1. **build-tag-push-container** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Build image
   - Step: Log in to registry
   - Step: Push image

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** No

### `examples-workflow.yaml` — INFRA
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **ce-carbon-accounting-backend** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Run Tape Tests
   - Step: Upload coverage reports as artifacts
2. **cactus-common-example-server** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
3. **ce-carbon-accounting-business-logic-plugin** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
4. **ce-carbon-accounting-frontend** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Upload coverage reports as artifacts
5. **ce-supply-chain-backend** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: CI environment clean-up
   - Step: Use ./.github/actions/docker-pull/
   - Step: build
   - Step: Run Jest Tests
   - Step: Run Tape Tests
   - Step: Upload coverage reports as artifacts
6. **ce-supply-chain-business-logic-plugin** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
7. **ce-supply-chain-frontend** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Upload coverage reports as artifacts
8. **ce-cbdc-bridging** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: CI environment clean-up
   - Step: Use ./.github/actions/docker-pull/
   - Step: Use ./.github/actions/docker-pull/
   - Step: Use ./.github/actions/docker-pull/
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts

**Secrets required:** secret:GITHUB_TOKEN, env:JEST_TEST_COVERAGE_PATH, env:JEST_TEST_PATTERN, env:TAPE_TEST_PATTERN
**Estimated run time:** ~45+ minutes
**Blocks PR merge:** No

### `fabric2-all-in-one-publish.yaml` — RELEASE
**Triggers:** push
**Branches/Paths:** push: tags=v*
**Contributor visible:** No

#### Jobs
1. **build-tag-push-container** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Build image
   - Step: Log in to registry
   - Step: Push image

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** No

### `geth-all-in-one-publish.yaml` — RELEASE
**Triggers:** push
**Branches/Paths:** push: tags=v*
**Contributor visible:** No

#### Jobs
1. **build-tag-push-container** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Build image
   - Step: Log in to registry
   - Step: Push image

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** No

### `gg-shield-action.yaml` — PR_CHECK
**Triggers:** push, pull_request
**Branches/Paths:** push: branches=main; tags=v* | pull_request: branches=main
**Contributor visible:** Partial (runs on PRs, but secret-backed steps are limited on forks)

#### Jobs
1. **scanning** — Workflow-specific automation
   - Step: Checkout
   - Step: GitGuardian scan

**Secrets required:** secret:GITGUARDIAN_API_KEY, secret:GITHUB_TOKEN
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** Yes

### `ghcr-workflow.yaml` — INFRA
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **ghcr-besu-all-in-one** — Workflow-specific automation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Run `git fetch origin ${{ github.base_ref }}`
   - Step: ghcr.io/hyperledger/cactus-besu-all-in-one
2. **ghcr-connector-corda-server** — Workflow-specific automation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: ghcr.io/hyperledger/cactus-connector-corda-server
3. **ghcr-corda-all-in-one-flowdb** — Workflow-specific automation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Run `git fetch origin ${{ github.base_ref }}`
   - Step: ghcr.io/hyperledger/cactus-corda-all-in-one-flowdb
4. **ghcr-dev-container-vscode** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Run `git fetch origin ${{ github.base_ref }}`
   - Step: Use Node.js ${{ inputs.node_version }}
   - Step: npm_install_@devcontainers/cli@0.44.0
   - Step: npx_yes_devcontainers_cli_build
5. **ghcr-example-supply-chain-app** — Workflow-specific automation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: ghcr.io/hyperledger/cactus-example-supply-chain-app
6. **ghcr-fabric2-all-in-one** — Workflow-specific automation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Run `git fetch origin ${{ github.base_ref }}`
   - Step: ghcr.io/hyperledger/cactus-fabric2-all-in-one
7. **ghcr-daml-all-in-one** — Workflow-specific automation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Run `git fetch origin ${{ github.base_ref }}`
   - Step: ghcr.io/hyperledger/daml-all-in-one
8. **ghcr-keychain-vault-server** — Workflow-specific automation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: ghcr.io/hyperledger/cactus-keychain-vault-server
   - Step: Run Trivy vulnerability scan for cactus-keychain-vault-server

**Secrets required:** none
**Estimated run time:** ~45+ minutes
**Blocks PR merge:** No

### `ghpkg-all-kotlin-api-clients-publish.yaml` — RELEASE
**Triggers:** push
**Branches/Paths:** push: tags=v*
**Contributor visible:** No

#### Jobs
1. **publish** — Automated test execution
   - Step: Install Indy SDK
   - Step: Checkout
   - Step: Get the latest release version
   - Step: Use actions/setup-java@5ffc13f4174014e2d4d4572b3d74c3fa61aeb2c2
   - Step: Set up NodeJS ${{ env.NODEJS_VERSION }}
   - Step: Run `npm run configure`
   - Step: build-cactus-plugin-ledger-connector-corda-kotlin-client
   - Step: publish-cactus-plugin-ledger-connector-corda-kotlin-client

**Secrets required:** env:GITVERSION, env:NODEJS_VERSION
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** No

### `htlc-packages-workflow.yaml` — INFRA
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **cp-htlc-coordinator-besu** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Run Tape Tests
   - Step: Upload coverage reports as artifacts
2. **cp-htlc-eth-besu** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
3. **cp-htlc-eth-besu-erc20** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
4. **ctp-htlc-eth-besu** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Run Tape Tests
   - Step: Upload coverage reports as artifacts
   - Step: Install Foundry
   - Step: Run solidity tests
5. **ctp-htlc-eth-besu-erc20** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts

**Secrets required:** secret:ETHERSCAN_KEY, secret:GITHUB_TOKEN, env:JEST_TEST_COVERAGE_PATH, env:JEST_TEST_PATTERN, env:TAPE_TEST_PATTERN
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** No

### `iroha2-all-in-one-publish.yaml` — RELEASE
**Triggers:** push
**Branches/Paths:** push: tags=v*
**Contributor visible:** No

#### Jobs
1. **build-tag-push-container** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Build image
   - Step: Log in to registry
   - Step: Push image

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** No

### `keychain-packages-workflow.yaml` — INFRA
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **cpk-google-sm** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
2. **cpk-memory** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
3. **cpk-memory-wasm** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
4. **cpk-vault** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Run Tape Tests
   - Step: Upload coverage reports as artifacts
5. **cpk-aws-sm** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Run Tape Tests
   - Step: Upload coverage reports as artifacts
6. **cpk-azure-kv** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Run Tape Tests
   - Step: Upload coverage reports as artifacts

**Secrets required:** secret:GITHUB_TOKEN, env:JEST_TEST_COVERAGE_PATH, env:JEST_TEST_PATTERN, env:TAPE_TEST_PATTERN
**Estimated run time:** ~45+ minutes
**Blocks PR merge:** No

### `keychain-vault-server-publish.yaml` — RELEASE
**Triggers:** push
**Branches/Paths:** push: tags=v*
**Contributor visible:** No

#### Jobs
1. **build-tag-push-container** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Build image
   - Step: Log in to registry
   - Step: Push image

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** No

### `other-packages-workflow.yaml` — INFRA
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **cp-copm** — Workflow-specific automation
   - Step: No explicit steps in this job body
2. **cp-consortium-manual** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
3. **cp-persistent-ethereum** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Use ./.github/actions/docker-pull/
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
4. **cp-persistent-fabric** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: CI environment clean-up
   - Step: Use ./.github/actions/docker-pull/
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
5. **cp-object-store-ipfs** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Run Tape Tests
   - Step: Upload coverage reports as artifacts
6. **cp-bungee-hermes** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: CI environment clean-up
   - Step: Use ./.github/actions/docker-pull/
   - Step: Use ./.github/actions/docker-pull/
   - Step: Use ./.github/actions/docker-pull/
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
7. **ct-geth-ledger** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
8. **ctp-consortium-manual** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Run Tape Tests
   - Step: Upload coverage reports as artifacts
9. **cp-consortium-static** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts

**Secrets required:** secret:GITHUB_TOKEN, env:JEST_TEST_COVERAGE_PATH, env:JEST_TEST_PATTERN, env:TAPE_TEST_PATTERN
**Estimated run time:** ~45+ minutes
**Blocks PR merge:** No

### `packages-workflow.yaml` — INFRA
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **core-packages** — Workflow-specific automation
   - Step: No explicit steps in this job body
2. **connector-packages** — Workflow-specific automation
   - Step: No explicit steps in this job body
3. **keychain-packages** — Workflow-specific automation
   - Step: No explicit steps in this job body
4. **other-packages** — Workflow-specific automation
   - Step: No explicit steps in this job body
5. **satp-hermes-workflow** — Workflow-specific automation
   - Step: No explicit steps in this job body

**Secrets required:** none
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** No

### `publish-npm.yaml` — RELEASE
**Triggers:** workflow_dispatch
**Branches/Paths:** workflow_dispatch: custom filters
**Contributor visible:** No

#### Jobs
1. **build-and-publish-packages** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Run `git fetch --unshallow --prune`
   - Step: Use actions/setup-node@1e60f620b9541d16bece96c5465dc8ee9832be0b
   - Step: ./tools/ci.sh
   - Step: lerna-publish

**Secrets required:** secret:NPM_TOKEN, env:NODEJS_VERSION
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** No

### `satp-hermes-build.yaml` — INFRA
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **build-satp** — Build or packaging validation
   - Step: Use Node.js
   - Step: Use actions/checkout@v4
   - Step: Initialize Yarn Cache
   - Step: Set working directory
   - Step: Install Foundry
   - Step: Install dependencies
   - Step: Configure
   - Step: Build bundle

**Secrets required:** none
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** No

### `satp-hermes-codegen.yaml` — INFRA
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **codegen-satp** — Build or packaging validation
   - Step: Use actions/checkout@v4
   - Step: Use Node.js
   - Step: Download SATP build artifacts
   - Step: Install dependencies
   - Step: Set working directory
   - Step: Install Foundry
   - Step: Generate protobuf files
   - Step: Generate OpenAPI SDKs

**Secrets required:** none
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** No

### `satp-hermes-docs.yaml` — DOCS
**Triggers:** workflow_call, workflow_dispatch
**Branches/Paths:** workflow_call: custom filters | workflow_dispatch: custom filters
**Contributor visible:** No

#### Jobs
1. **build-docs** — Build or packaging validation
   - Step: Checkout code
   - Step: Setup Node.js
   - Step: Install system dependencies for Puppeteer
   - Step: Install dependencies
   - Step: Generate TypeDoc documentation
   - Step: Verify documentation build
   - Step: Prepare documentation structure for GitHub Pages
   - Step: Create documentation metadata
2. **deploy-docs** — Deployment automation
   - Step: Deploy to GitHub Pages
   - Step: Post deployment summary

**Secrets required:** none
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** No

### `satp-hermes-ghcr-gateway-sdk.yaml` — INFRA
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **set-ghcr-tags** — Build or packaging validation
   - Step: Use actions/checkout@v4.1.7
   - Step: Set image tags
   - Step: Debug Build Info
2. **build-satp-hermes-ghcr-image** — Build or packaging validation
   - Step: Use actions/checkout@v4.1.7
   - Step: Setup Node.js
   - Step: Initialize Yarn Cache
   - Step: Set working directory
   - Step: Install Foundry
   - Step: Install dependencies
   - Step: Configure
   - Step: Build bundle
3. **publish-satp-hermes-ghcr-image** — Build or packaging validation
   - Step: Use actions/checkout@v4.1.7
   - Step: Setup Node.js
   - Step: Install dependencies
   - Step: Configure
   - Step: Build bundle
   - Step: Set up Docker Buildx
   - Step: Login to GitHub Container Registry
   - Step: Build and push to GHCR (Release)

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** No

### `satp-hermes-lint.yaml` — INFRA
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **lint-satp** — Linting and style validation
   - Step: Use actions/checkout@v4
   - Step: Use Node.js
   - Step: Download SATP build artifacts
   - Step: Install dependencies
   - Step: Set working directory
   - Step: Run `git status --porcelain`
   - Step: Run `git status --porcelain | wc -l`
   - Step: yarn lint (SATP-specific)

**Secrets required:** env:GIT_INDEX_FILE_COUNT
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** No

### `satp-hermes-npmjs-gateway-sdk.yaml` — MERGE_GATE
**Triggers:** push, workflow_dispatch, workflow_call
**Branches/Paths:** push: branches=main, satp-dev, satp-stg; paths=packages/cactus-plugin-satp-hermes/**, .github/workflows/satp-hermes-npmjs-gateway-sdk.yaml | workflow_dispatch: custom filters | workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **set-npm-tags** — Build or packaging validation
   - Step: Use actions/checkout@v4.1.7
   - Step: Set package tags
   - Step: Debug Build Info
2. **build-satp-hermes-npm-package** — Build or packaging validation
   - Step: Use actions/checkout@v4.1.7
   - Step: Setup Node.js
   - Step: Initialize Yarn Cache
   - Step: Set working directory
   - Step: Install Foundry
   - Step: Install dependencies
   - Step: Configure
   - Step: Build package
3. **publish-satp-hermes-npm-package-npmjs** — Build or packaging validation
   - Step: Use actions/checkout@v4.1.7
   - Step: Setup Node.js
   - Step: Download build artifacts
   - Step: Configure git user
   - Step: Update package version for development build
   - Step: Update package version for release build
   - Step: Verify package contents
   - Step: Publish to npmjs.org (Development)
4. **publish-satp-hermes-npm-package-ghcr** — Build or packaging validation
   - Step: Use actions/checkout@v4.1.7
   - Step: Setup Node.js
   - Step: Download build artifacts
   - Step: Configure git user
   - Step: Update package version for development build
   - Step: Update package version for release build
   - Step: Publish to GitHub Package Registry (Development)
   - Step: Publish to GitHub Package Registry (Release)

**Secrets required:** secret:GITHUB_TOKEN, secret:NPM_TOKEN
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** No

### `satp-hermes-publish.yaml` — RELEASE
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **set-docker-tags** — Build or packaging validation
   - Step: Use actions/checkout@v4.1.7
   - Step: Set image tags
   - Step: Debug Build Info
2. **build-satp-docker** — Build or packaging validation
   - Step: Use actions/checkout@v4.1.7
   - Step: Setup Node.js
   - Step: Initialize Yarn Cache
   - Step: Set working directory
   - Step: Install Foundry
   - Step: Install dependencies
   - Step: Configure
   - Step: Build bundle
3. **publish-satp-image-ghcr** — Build or packaging validation
   - Step: Use actions/checkout@v4.1.7
   - Step: Setup Node.js
   - Step: Install dependencies
   - Step: Configure
   - Step: Build bundle
   - Step: Set up Docker Buildx
   - Step: Login to GitHub Container Registry
   - Step: Build and push to GHCR (Release)
4. **publish-satp-image-dockerhub** — Build or packaging validation
   - Step: Use actions/checkout@v4.1.7
   - Step: Setup Node.js
   - Step: Install dependencies
   - Step: Configure
   - Step: Build bundle
   - Step: Set up Docker Buildx
   - Step: Login to Docker Hub
   - Step: Build and push to Docker Hub (Release)

**Secrets required:** secret:DOCKERHUB_PAT, secret:DOCKERHUB_USERNAME, secret:GITHUB_TOKEN
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** No

### `satp-hermes-release.yaml` — RELEASE
**Triggers:** workflow_call, workflow_dispatch
**Branches/Paths:** workflow_call: custom filters | workflow_dispatch: custom filters
**Contributor visible:** No

#### Jobs
1. **create-github-release** — Release or publishing automation
   - Step: Use actions/checkout@v4.1.7
   - Step: Validate version format
   - Step: Create Release

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** No

### `satp-hermes-workflow.yaml` — INFRA
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **run-satp-tests-unit** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Use ./.github/actions/docker-pull/
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
2. **run-satp-tests-integration-bridge** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: CI environment clean-up
   - Step: Use ./.github/actions/docker-pull/
   - Step: Use ./.github/actions/docker-pull/
   - Step: Use ./.github/actions/docker-pull/
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
3. **run-satp-tests-integration-oracle** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: CI environment clean-up
   - Step: Use ./.github/actions/docker-pull/
   - Step: Use ./.github/actions/docker-pull/
   - Step: Use ./.github/actions/docker-pull/
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
4. **run-satp-tests-integration-gateway** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: CI environment clean-up
   - Step: Use ./.github/actions/docker-pull/
   - Step: Use ./.github/actions/docker-pull/
   - Step: Use ./.github/actions/docker-pull/
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
5. **run-satp-tests-integration-docker** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: CI environment clean-up
   - Step: Use ./.github/actions/docker-pull/
   - Step: Use ./.github/actions/docker-pull/
   - Step: Use ./.github/actions/docker-pull/
   - Step: Use ./.github/actions/docker-pull/
   - Step: Use ./.github/actions/docker-pull/
   - Step: build
6. **run-satp-tests-on-chain** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: build
   - Step: Install Foundry
   - Step: Build Foundry contracts
   - Step: Run Foundry tests
   - Step: Upload SATP foundry test reports
7. **run-satp-tests-recovery** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: CI environment clean-up
   - Step: Use ./.github/actions/docker-pull/
   - Step: Use ./.github/actions/docker-pull/
   - Step: Use ./.github/actions/docker-pull/
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
8. **run-satp-tests-rollback** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: CI environment clean-up
   - Step: Use ./.github/actions/docker-pull/
   - Step: Use ./.github/actions/docker-pull/
   - Step: Use ./.github/actions/docker-pull/
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts

**Secrets required:** secret:GITHUB_TOKEN, env:JEST_TEST_COVERAGE_PATH, env:JEST_TEST_PATTERN
**Estimated run time:** ~45+ minutes
**Blocks PR merge:** No

### `sawtooth-all-in-one-publish.yaml` — RELEASE
**Triggers:** push
**Branches/Paths:** push: tags=v*
**Contributor visible:** No

#### Jobs
1. **build-tag-push-container** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Build image
   - Step: Log in to registry
   - Step: Push image

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** No

### `scorecard.yml` — SCHEDULED
**Triggers:** branch_protection_rule, schedule, push
**Branches/Paths:** branch_protection_rule: default | schedule: {'cron': '30 2 * * 6'} | push: branches=main
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

### `semantic-pull-request.yaml` — INFRA
**Triggers:** pull_request
**Branches/Paths:** pull_request: types=opened, edited, synchronize
**Contributor visible:** Partial (runs on PRs, but secret-backed steps are limited on forks)

#### Jobs
1. **main** — Workflow-specific automation
   - Step: Use amannn/action-semantic-pull-request@01d5fd8a8ebb9aafe902c40c53f0f4744f7381eb

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** Yes

### `test_weaver-asset-exchange-besu.yaml` — INFRA
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **check_code_changed** — Workflow-specific automation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Use dorny/paths-filter@4512585405083f25c027a35db413c2b3b9006d50
2. **asset-exchange-besu** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up JDK 11
   - Step: Use Node.js ${{ env.NODEJS_VERSION }}
   - Step: Use Protoc 3.15
   - Step: Build Solidity Protos
   - Step: Start Besu Network
   - Step: Deploy contracts
   - Step: Setup BESU CLI .npmrc
3. **asset-exchange-besu-local** — Build or packaging validation
   - Step: Print  needs.check_code_changed.outputs.status
   - Step: Print  needs.check_code_changed.outputs.status != true
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up JDK 11
   - Step: Use Node.js ${{ env.NODEJS_VERSION }}
   - Step: Use Protoc 3.15
   - Step: Build JS Protos
   - Step: Build Solidity Protos

**Secrets required:** secret:GITHUB_TOKEN, env:NODEJS_VERSION
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** No

### `test_weaver-asset-exchange-corda.yaml` — INFRA
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **check_code_changed** — Workflow-specific automation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Use dorny/paths-filter@4512585405083f25c027a35db413c2b3b9006d50
2. **asset-exchange-corda** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up JDK 17
   - Step: Generate github.properties
   - Step: Start Corda Network
   - Step: Setup Corda CLI init
   - Step: Asset Exchange Corda CLI Tests
3. **asset-exchange-corda-local** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up JDK 17
   - Step: Build Java Protos
   - Step: Build Corda Interop App
   - Step: Build Corda Interop SDK
   - Step: Build Corda SimpleApplication
   - Step: Start Corda Network
   - Step: Setup Corda CLI init
4. **house-token-exchange-corda** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Use dorny/paths-filter@4512585405083f25c027a35db413c2b3b9006d50
   - Step: Set up JDK 17
   - Step: Generate github.properties
   - Step: Start Corda Network
   - Step: Build CLI
   - Step: Setup Corda CLI init
   - Step: House Token Exchange Corda CLI Tests

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** No

### `test_weaver-asset-exchange-fabric.yaml` — INFRA
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **check_code_changed** — Workflow-specific automation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Use dorny/paths-filter@4512585405083f25c027a35db413c2b3b9006d50
2. **asset-exchange-fabric** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up Go
   - Step: Use Node.js ${{ env.NODEJS_VERSION }}
   - Step: Start Fabric Network
   - Step: Setup Fabric CLI .npmrc
   - Step: Build Fabric CLI
   - Step: Setup Fabric CLI Config
   - Step: Setup Fabric CLI ENV
3. **asset-exchange-fabric-local** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up Go
   - Step: Use Node.js ${{ env.NODEJS_VERSION }}
   - Step: Use Protoc 3.15
   - Step: Build JS Protos
   - Step: Build Fabric Interop SDK
   - Step: Build Fabric CLI
   - Step: Start Fabric Network

**Secrets required:** secret:GITHUB_TOKEN, env:NODEJS_VERSION
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** No

### `test_weaver-asset-transfer.yaml` — INFRA
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **check_code_changed** — Workflow-specific automation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Use dorny/paths-filter@4512585405083f25c027a35db413c2b3b9006d50
2. **asset-transfer** — Workflow-specific automation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up JDK 17
   - Step: Set up Go
   - Step: Use Node.js ${{ env.NODEJS_VERSION }}
   - Step: Generate github.properties
   - Step: Start Corda Network
   - Step: Start Fabric Network
   - Step: Corda Network logs
3. **asset-transfer-local** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up JDK 17
   - Step: Set up Go
   - Step: Use Node.js ${{ env.NODEJS_VERSION }}
   - Step: Install RUST Toolchain minimal stable with clippy and rustfmt
   - Step: Get Latest Relay Dependencies
   - Step: Use Protoc 3.15
   - Step: Build GO Protos

**Secrets required:** secret:GITHUB_TOKEN, env:CF_PID, env:FC_PID, env:NODEJS_VERSION
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** No

### `test_weaver-corda-interop-app.yaml` — INFRA
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **check_code_changed** — Workflow-specific automation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Use dorny/paths-filter@4512585405083f25c027a35db413c2b3b9006d50
2. **unit_test_interop_cordapp** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up JDK 17
   - Step: Build Protos (Local)
   - Step: Build Corda Interop App (Local)
   - Step: Run Tests (Local)

**Secrets required:** none
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** No

### `test_weaver-data-sharing.yaml` — INFRA
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **check_code_changed** — Workflow-specific automation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Use dorny/paths-filter@4512585405083f25c027a35db413c2b3b9006d50
2. **data-sharing** — Workflow-specific automation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up JDK 17
   - Step: Set up Go
   - Step: Use Node.js ${{ env.NODEJS_VERSION }}
   - Step: Generate github.properties
   - Step: Start Corda Network
   - Step: Start Fabric Network
   - Step: Corda Network logs
3. **data-sharing-docker-local** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Use dorny/paths-filter@4512585405083f25c027a35db413c2b3b9006d50
   - Step: Set up JDK 17
   - Step: Set up Go
   - Step: Use Node.js ${{ env.NODEJS_VERSION }}
   - Step: Use Protoc 3.15
   - Step: CI script for cleanup
   - Step: Build GO Protos
4. **data-sharing-local** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Use dorny/paths-filter@4512585405083f25c027a35db413c2b3b9006d50
   - Step: Set up JDK 17
   - Step: Set up Go
   - Step: Use Node.js ${{ env.NODEJS_VERSION }}
   - Step: Install RUST Toolchain minimal stable with clippy and rustfmt
   - Step: Get Latest Relay Dependencies
   - Step: Use Protoc 3.15

**Secrets required:** secret:GITHUB_TOKEN, env:NODEJS_VERSION
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** No

### `test_weaver-docker-build.yaml` — INFRA
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **check_code_changed** — Workflow-specific automation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Use dorny/paths-filter@4512585405083f25c027a35db413c2b3b9006d50
2. **build_docker_relay** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Build Image
3. **build_docker_fabric_driver_local** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Use Node.js ${{ env.NODEJS_VERSION }}
   - Step: Use Protoc 3.15
   - Step: Build JS Protos (Local)
   - Step: Build Fabric Interop Node SDK (Local)
   - Step: Build Image (Local)
4. **build_docker_fabric_driver_packages** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Setup .npmrc
   - Step: Build Image
5. **build_docker_corda_driver_local** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up JDK 17
   - Step: Build Protos (Local)
   - Step: Build Corda Interop App (Local)
   - Step: Build Corda Interop SDK (Local)
   - Step: Build Image (Local)
6. **build_docker_corda_driver_packages** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Generate github.properties
   - Step: Build Image
7. **build_docker_iin_agent_local** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Use Node.js ${{ env.NODEJS_VERSION }}
   - Step: Use Protoc 3.15
   - Step: Build JS Protos (Local)
   - Step: Build Fabric Interop Node SDK (Local)
   - Step: Build Image

**Secrets required:** secret:GITHUB_TOKEN, env:NODEJS_VERSION
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** No

### `test_weaver-fabric-fabric-satp.yaml` — INFRA
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **check_code_changed** — Workflow-specific automation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Use dorny/paths-filter@4512585405083f25c027a35db413c2b3b9006d50
2. **fabric-fabric-satp-local** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up Go
   - Step: Use Node.js 18.x
   - Step: Install RUST Toolchain minimal stable with clippy and rustfmt
   - Step: Get Latest Relay Dependencies
   - Step: Use Protoc 3.15
   - Step: Build GO Protos
   - Step: Build JS Protos

**Secrets required:** none
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** No

### `test_weaver-go.yaml` — INFRA
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **debug_event_type** — Workflow-specific automation
   - Step: Run `echo "${{ github.event_name }}"`
2. **check_code_changed** — Workflow-specific automation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Use dorny/paths-filter@4512585405083f25c027a35db413c2b3b9006d50
3. **unit_test_interopcc** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up Go
   - Step: Vendor
   - Step: Build
   - Step: Test
4. **unit_test_assetmgmt** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up Go
   - Step: Vendor
   - Step: Build
   - Step: Test
5. **build_test_libs_utils** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up Go
   - Step: Vendor
   - Step: Build
6. **build_test_libs_assetexchange** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up Go
   - Step: Vendor
   - Step: Build
7. **unit_test_sdk** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up Go
   - Step: Vendor
   - Step: Build
   - Step: Test
8. **build_test_cli** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up Go
   - Step: Vendor
   - Step: Build
9. **unit_test_simplestate** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up Go
   - Step: Vendor
   - Step: Build
   - Step: Test
10. **unit_test_satpsimpleasset** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up Go
   - Step: Vendor
   - Step: Build
   - Step: Test
11. **unit_test_simpleasset** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up Go
   - Step: Vendor
   - Step: Build
   - Step: Test
12. **unit_test_simpleassetandinterop** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up Go
   - Step: Vendor
   - Step: Build
   - Step: Test
13. **unit_test_simpleassettransfer** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up Go
   - Step: Vendor
   - Step: Build
   - Step: Test
14. **unit_test_sdk_membership** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up Go
   - Step: Start Fabric Network
   - Step: Vendor
   - Step: Build
   - Step: Test

**Secrets required:** none
**Estimated run time:** ~45+ minutes
**Blocks PR merge:** No

### `test_weaver-node-pkgs.yaml` — INFRA
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **check_code_changed** — Workflow-specific automation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Use dorny/paths-filter@4512585405083f25c027a35db413c2b3b9006d50
2. **unit_test_weaver_node_sdk_local** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Use Node.js ${{ matrix.node-version }}
   - Step: Use Protoc 3.15
   - Step: Build JS Protos
   - Step: Build
   - Step: Tests
3. **unit_test_iin_agent_local** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Use Node.js ${{ matrix.node-version }}
   - Step: Use Protoc 3.15
   - Step: Build JS Protos
   - Step: Build
   - Step: Build IIN Agent
   - Step: Tests
4. **build-docs** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Use Python 3.x
   - Step: Install dependencies
   - Step: Build

**Secrets required:** none
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** No

### `test_weaver-pre-release.yaml` — RELEASE
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **check_release** — Release or publishing automation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Ignore if not a release PR
2. **test_weaver_pre-release** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Get release verison from PR title
   - Step: check weaver/common/protos-java-kt/gradle.properties
   - Step: check weaver/core/network/corda-interop-app/gradle.properties
   - Step: check weaver/sdks/corda/gradle.properties
   - Step: check weaver/core/drivers/corda-driver/gradle.properties
   - Step: check weaver/common/protos-js/package.json
   - Step: check weaver/sdks/fabric/interoperation-node-sdk/package.json
3. **test_weaver_go_pre-release** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Get release verison from PR title
   - Step: Update GO Checksum
   - Step: Check if changes are committed

**Secrets required:** none
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** No

### `test_weaver-relay.yaml` — INFRA
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **check_code_changed** — Workflow-specific automation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Use dorny/paths-filter@4512585405083f25c027a35db413c2b3b9006d50
2. **unit_test_relay_local** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Install RUST Toolchain minimal stable with clippy and rustfmt
   - Step: Use Protoc 3.15
   - Step: Build Protos RS
   - Step: Get Latest Relay Dependencies
   - Step: Build Image
   - Step: Run Dummy Relay
   - Step: Run Dummy Driver
3. **unit_test_relay_tls_local** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Install RUST Toolchain minimal stable with clippy and rustfmt
   - Step: Use Protoc 3.15
   - Step: Build Protos RS
   - Step: Get Latest Relay Dependencies
   - Step: Build Image
   - Step: Run Dummy Relay
   - Step: Run Dummy Driver
4. **unit_test_relay** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Install RUST Toolchain minimal stable with clippy and rustfmt
   - Step: Get Latest Relay Dependencies
   - Step: Build Image
   - Step: Run Dummy Relay
   - Step: Run Dummy Driver
   - Step: Mock Client Test
5. **unit_test_relay_tls** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Install RUST Toolchain minimal stable with clippy and rustfmt
   - Step: Get Latest Relay Dependencies
   - Step: Build Image
   - Step: Run Dummy Relay
   - Step: Run Dummy Driver
   - Step: Mock Client Test

**Secrets required:** none
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** No

### `weaver_deploy_corda-pkgs.yml` — MERGE_GATE
**Triggers:** push, workflow_dispatch
**Branches/Paths:** push: tags=v* | workflow_dispatch: default
**Contributor visible:** No

#### Jobs
1. **publish-protos-java-kt** — Artifact publishing
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up JDK 17
   - Step: Generate github.properties
   - Step: Publish
2. **publish-interop-app** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up JDK 17
   - Step: Generate github.properties
   - Step: Build
   - Step: Publish
3. **publish-sdk** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up JDK 17
   - Step: Generate github.properties
   - Step: Build
   - Step: Publish
4. **publish-driver-image** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Login to GitHub Container Registry
   - Step: Generate github.properties
   - Step: Check if package already exists
   - Step: Build and Push
   - Step: Push latest tag

**Secrets required:** secret:GITHUB_TOKEN
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** No

### `weaver_deploy_go-pkgs.yml` — MERGE_GATE
**Triggers:** push, workflow_dispatch
**Branches/Paths:** push: tags=v* | workflow_dispatch: default
**Contributor visible:** No

#### Jobs
1. **publish-protos-go** — Release or publishing automation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set current date as env
   - Step: Set module tag and description
   - Step: Update version
   - Step: Set module version
   - Step: Check if release already exists
   - Step: Create Release
   - Step: Wait for release to be reflected
2. **publish-lib-utils** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up Go
   - Step: Set current date as env
   - Step: Set module tag and description
   - Step: Update version
   - Step: Set module version
   - Step: Build test
   - Step: Check if release already exists
3. **publish-lib-asset-exchange** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up Go
   - Step: Set current date as env
   - Step: Set module tag and description
   - Step: Update version
   - Step: Set module version
   - Step: Build test
   - Step: Check if release already exists
4. **publish-interface-asset-mgmt** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up Go
   - Step: Set current date as env
   - Step: Set module tag and description
   - Step: Update version
   - Step: Set module version
   - Step: Build test
   - Step: Check if release already exists
5. **publish-interop-cc** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up Go
   - Step: Set current date as env
   - Step: Set module tag and description
   - Step: Update version
   - Step: Set module version
   - Step: Build test
   - Step: Check if release already exists
6. **publish-go-sdk** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Set up Go
   - Step: Set current date as env
   - Step: Set module tag and description
   - Step: Update version
   - Step: Set module version
   - Step: Build test
   - Step: Check if release already exists
7. **publish-weaver-fabric-cc-image** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Login to GitHub Container Registry
   - Step: Check if package already exists
   - Step: Build and Push
   - Step: Push latest tag

**Secrets required:** secret:GITHUB_TOKEN, env:MODULE_DESC, env:MODULE_TAG, env:RELEASE_DATE, env:VERSION
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** No

### `weaver_deploy_node-pkgs.yml` — MERGE_GATE
**Triggers:** push, workflow_dispatch
**Branches/Paths:** push: tags=v* | workflow_dispatch: default
**Contributor visible:** No

#### Jobs
1. **publish-protos-js** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Use Node.js ${{ env.NODEJS_VERSION }}
   - Step: Use Protoc 3.15
   - Step: Generate .npmrc
   - Step: Build
   - Step: Check if package already exists
   - Step: Publish
2. **publish-fabric-sdk** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Use Node.js ${{ env.NODEJS_VERSION }}
   - Step: Generate .npmrc
   - Step: Build
   - Step: Check if package already exists
   - Step: Publish
3. **publish-besu-sdk** — Build or packaging validation
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Use Node.js ${{ env.NODEJS_VERSION }}
   - Step: Generate .npmrc
   - Step: Build
   - Step: Check if package already exists
   - Step: Publish
4. **publish-driver-image** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Login to GitHub Container Registry
   - Step: Generate .npmrc
   - Step: Check if package already exists
   - Step: Build and Push
   - Step: Push latest tag
5. **publish-iin-agent-image** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Login to GitHub Container Registry
   - Step: Generate .npmrc
   - Step: Check if package already exists
   - Step: Build and Push
   - Step: Push latest tag

**Secrets required:** secret:GITHUB_TOKEN, env:NODEJS_VERSION
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** No

### `weaver_deploy_relay-server.yml` — MERGE_GATE
**Triggers:** push, workflow_dispatch
**Branches/Paths:** push: tags=v* | workflow_dispatch: default
**Contributor visible:** No

#### Jobs
1. **publish-protos-rs** — Artifact publishing
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Install RUST Toolchain minimal stable with clippy and rustfmt
   - Step: Publish
2. **publish-relay-image** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Login to GitHub Container Registry
   - Step: Update version
   - Step: Check if package already exists
   - Step: Build and Push
   - Step: Push latest tag

**Secrets required:** secret:CARGO_CRATES_IO_TOKEN, secret:GITHUB_TOKEN
**Estimated run time:** ~10-20 minutes
**Blocks PR merge:** No

### `workflow-copm.yaml` — INFRA
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **matrix-pledge-and-getview** — Automated test execution
   - Step: Use actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332
   - Step: Use ./.github/actions/copm_test/
   - Step: Make the ${{matrix.net1}} network
   - Step: Make the ${{matrix.net2}} network
   - Step: show the running network
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts
2. **matrix-lock** — Automated test execution
   - Step: Use actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11
   - Step: Use ./.github/actions/copm_test/
   - Step: Make the ${{matrix.net1}} network
   - Step: show the running network
   - Step: build
   - Step: Run Jest Tests
   - Step: Upload coverage reports as artifacts

**Secrets required:** secret:GITHUB_TOKEN, env:JEST_TEST_COVERAGE_PATH, env:JEST_TEST_PATTERN
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** No

## Contributor Summary

New contributors should expect these workflows to matter most on their pull requests: .dast-nuclei-cmd-api-server.yaml, ai-config-lint.yaml, ci.yaml, ci_weaver.yaml, codeql-analysis.yml, commitlint-pull-request.yaml, gg-shield-action.yaml, semantic-pull-request.yaml. Workflows that are mainly for maintainers or release automation include all-nodejs-packages-publish.yaml, besu-all-in-one-publish.yaml, cacti-dev-container-vscode-publish.yaml, cmd-api-server-publish.yaml, connector-besu-publish.yaml, connector-corda-server-publish.yaml, connector-fabric-cli-publish-dev.yaml, connector-fabric-cli-publish.yaml, connector-fabric-publish.yaml, connector-packages-workflow.yaml. To stay ahead of CI, contributors should at minimum run lint, run tests, verify builds. Release, publishing, scheduled maintenance, scorecard, and documentation deployment workflows are usually not something a first-time contributor needs to optimize for unless their change touches that surface. If a PR-visible workflow fails, the quickest path is to compare the failing job steps with the local equivalent command and then re-run only after reproducing or understanding the issue. The contributor experience in this repository is broad and explicit because the workflow files themselves expose most of the automation contract.

## Red Flags / Observations

- Potentially complex for newcomers: ci.yaml, ci_weaver.yaml, connector-packages-workflow.yaml, core-packages-workflow.yaml, examples-workflow.yaml, ghcr-workflow.yaml.
- Some workflows need more in-file explanation because job intent is not obvious from names alone: .dast-nuclei-cmd-api-server.yaml, checks-and-build.yaml, ci.yaml, ci_weaver.yaml, gg-shield-action.yaml, ghcr-workflow.yaml.
- These may confuse fork-based contributors because they mix PR execution with restricted secrets or elevated contexts: gg-shield-action.yaml, semantic-pull-request.yaml.
- Good patterns Cacti can replicate: clearly separated PR checks such as .dast-nuclei-cmd-api-server.yaml, ai-config-lint.yaml, gg-shield-action.yaml.
