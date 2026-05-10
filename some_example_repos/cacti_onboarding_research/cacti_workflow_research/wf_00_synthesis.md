# Workflow Synthesis

## Section 1 — Master Workflow Inventory Table

| Repo | File | Category | Trigger | Blocks PR | Contributor Visible |
|------|------|----------|---------|-----------|---------------------|
| Hyperledger Fabric | broken-link-checker.yml | SCHEDULED | workflow_dispatch, schedule, pull_request | Yes | Yes |
| Hyperledger Fabric | release.yml | RELEASE | workflow_dispatch, push | No | No |
| Hyperledger Fabric | scorecard.yml | SCHEDULED | workflow_dispatch, branch_protection_rule, schedule, push | No | No |
| Hyperledger Fabric | verify-build.yml | PR_CHECK | push, pull_request, workflow_dispatch | Yes | Yes |
| Hyperledger Fabric | vulnerability-scan.yml | SCHEDULED | workflow_dispatch, schedule | No | No |
| VS Code | api-proposal-version-check.yml | PR_CHECK | pull_request, issue_comment | Yes | Yes |
| VS Code | chat-lib-package.yml | PR_CHECK | pull_request, workflow_dispatch | Yes | Yes |
| VS Code | chat-perf.yml | MAINTAINER_ONLY | workflow_dispatch | No | No |
| VS Code | component-fixture-tests.yml | PR_CHECK | push, pull_request | Yes | Partial (runs on PRs, but secret-backed steps are limited on forks) |
| VS Code | copilot-setup-steps.yml | PR_CHECK | workflow_dispatch, push, pull_request | Yes | Partial (runs on PRs, but secret-backed steps are limited on forks) |
| VS Code | monaco-editor.yml | PR_CHECK | push, pull_request | Yes | Partial (runs on PRs, but secret-backed steps are limited on forks) |
| VS Code | no-engineering-system-changes.yml | PR_CHECK | pull_request | Yes | Partial (runs on PRs, but secret-backed steps are limited on forks) |
| VS Code | pr-darwin-test.yml | INFRA | workflow_call | No | No |
| VS Code | pr-linux-cli-test.yml | INFRA | workflow_call | No | No |
| VS Code | pr-linux-test.yml | INFRA | workflow_call | No | No |
| VS Code | pr-node-modules.yml | MERGE_GATE | push | No | No |
| VS Code | pr-win32-test.yml | INFRA | workflow_call | No | No |
| VS Code | pr.yml | PR_CHECK | pull_request | Yes | Partial (runs on PRs, but secret-backed steps are limited on forks) |
| VS Code | screenshot-test.yml | PR_CHECK | push, pull_request | Yes | Partial (runs on PRs, but secret-backed steps are limited on forks) |
| VS Code | sessions-e2e.yml | MAINTAINER_ONLY | workflow_dispatch | No | No |
| VS Code | telemetry.yml | PR_CHECK | pull_request | Yes | Partial (runs on PRs, but secret-backed steps are limited on forks) |
| Rust | ci.yml | PR_CHECK | push, pull_request | Yes | Partial (runs on PRs, but secret-backed steps are limited on forks) |
| Rust | dependencies.yml | SCHEDULED | schedule, workflow_dispatch | No | No |
| Rust | ghcr.yml | SCHEDULED | workflow_dispatch, schedule | No | No |
| Rust | post-merge.yml | MERGE_GATE | push | No | No |
| freeCodeCamp | crowdin-download.client-ui.yml | SCHEDULED | workflow_dispatch, schedule | No | No |
| freeCodeCamp | crowdin-upload.client-ui.yml | SCHEDULED | workflow_dispatch, schedule | No | No |
| freeCodeCamp | crowdin-upload.curriculum.yml | SCHEDULED | workflow_dispatch, schedule | No | No |
| freeCodeCamp | curriculum-i18n-submodule.yml | MERGE_GATE | push, workflow_dispatch | No | No |
| freeCodeCamp | deploy-api.yml | MAINTAINER_ONLY | workflow_dispatch | No | No |
| freeCodeCamp | deploy-client.yml | MAINTAINER_ONLY | workflow_dispatch | No | No |
| freeCodeCamp | devcontainer-ci.yml | PR_CHECK | pull_request, workflow_dispatch | Yes | Partial (runs on PRs, but secret-backed steps are limited on forks) |
| freeCodeCamp | docker-docr-cleanup.yml | SCHEDULED | workflow_dispatch, schedule | No | No |
| freeCodeCamp | docker-docr.yml | MAINTAINER_ONLY | workflow_dispatch, workflow_call | No | No |
| freeCodeCamp | docker-ghcr.yml | MERGE_GATE | workflow_dispatch, push | No | No |
| freeCodeCamp | e2e-playwright.yml | PR_CHECK | workflow_dispatch, pull_request | Yes | Partial (runs on PRs, but secret-backed steps are limited on forks) |
| freeCodeCamp | e2e-third-party.yml | MERGE_GATE | workflow_dispatch, push | No | No |
| freeCodeCamp | github-autoclose.yml | INFRA | pull_request_target | Yes | Partial (PR context with elevated maintainer-owned workflow) |
| freeCodeCamp | github-labeler.yaml | INFRA | pull_request_target | Yes | Partial (PR context with elevated maintainer-owned workflow) |
| freeCodeCamp | github-lock-closed-prs.yml | MAINTAINER_ONLY | pull_request_target | Yes | Partial (PR context with elevated maintainer-owned workflow) |
| freeCodeCamp | github-no-i18n-via-prs.yml | MAINTAINER_ONLY | pull_request_target | Yes | Partial (PR context with elevated maintainer-owned workflow) |
| freeCodeCamp | github-pr-guidelines.yml | MAINTAINER_ONLY | pull_request_target | Yes | Partial (PR context with elevated maintainer-owned workflow) |
| freeCodeCamp | github-spam.yml | INFRA | pull_request_target | Yes | Partial (PR context with elevated maintainer-owned workflow) |
| freeCodeCamp | i18n-validate-builds.yml | MERGE_GATE | push | No | No |
| freeCodeCamp | i18n-validate-prs.yml | PR_CHECK | pull_request | Yes | Partial (runs on PRs, but secret-backed steps are limited on forks) |
| freeCodeCamp | node.js-tests.yml | PR_CHECK | push, pull_request | Yes | Partial (runs on PRs, but secret-backed steps are limited on forks) |
| GrimoireLab | docker-image.yml | RELEASE | release, workflow_dispatch | No | No |
| GrimoireLab | grimoirelab-release.yml | RELEASE | workflow_dispatch | No | No |
| GrimoireLab | release-grimoirelab-component.yml | RELEASE | workflow_call | No | No |
| GrimoireLab | release.yml | RELEASE | push | No | No |
| Credo TS | cleanup-cache.yml | SCHEDULED | schedule, workflow_dispatch | No | No |
| Credo TS | continuous-integration.yml | PR_CHECK | pull_request, push, pull_request_review | Yes | Partial (runs on PRs, but secret-backed steps are limited on forks) |
| Credo TS | lint-pr.yml | MAINTAINER_ONLY | pull_request_target | Yes | Partial (PR context with elevated maintainer-owned workflow) |
| Credo TS | release.yml | RELEASE | push, pull_request | Yes | Partial (runs on PRs, but secret-backed steps are limited on forks) |
| Credo TS | repolinter.yml | INFRA | workflow_dispatch | No | No |
| Credo TS | scorecard.yml | SCHEDULED | schedule | No | No |
| Hyperledger Cacti | .dast-nuclei-cmd-api-server.yaml | PR_CHECK | push, pull_request | Yes | Yes |
| Hyperledger Cacti | actionlint.yaml | INFRA | workflow_call | No | No |
| Hyperledger Cacti | ai-config-lint.yaml | PR_CHECK | pull_request | Yes | Yes |
| Hyperledger Cacti | all-nodejs-packages-publish.yaml | RELEASE | push, workflow_dispatch | No | No |
| Hyperledger Cacti | besu-all-in-one-publish.yaml | RELEASE | push | No | No |
| Hyperledger Cacti | cacti-dev-container-vscode-publish.yaml | RELEASE | push | No | No |
| Hyperledger Cacti | checks-and-build.yaml | INFRA | workflow_call | No | No |
| Hyperledger Cacti | ci.yaml | SCHEDULED | pull_request, workflow_dispatch, schedule | Yes | Yes |
| Hyperledger Cacti | ci_weaver.yaml | SCHEDULED | workflow_dispatch, push, pull_request, schedule | Yes | Yes |
| Hyperledger Cacti | cmd-api-server-publish.yaml | RELEASE | push | No | No |
| Hyperledger Cacti | code-quality-checks.yaml | INFRA | workflow_call | No | No |
| Hyperledger Cacti | codeql-analysis.yml | SCHEDULED | push, pull_request, schedule | Yes | Yes |
| Hyperledger Cacti | commitlint-pull-request.yaml | INFRA | pull_request | Yes | Yes |
| Hyperledger Cacti | connector-besu-publish.yaml | RELEASE | push | No | No |
| Hyperledger Cacti | connector-corda-server-publish.yaml | RELEASE | push | No | No |
| Hyperledger Cacti | connector-fabric-cli-publish-dev.yaml | RELEASE | workflow_call, workflow_dispatch | No | No |
| Hyperledger Cacti | connector-fabric-cli-publish.yaml | RELEASE | push | No | No |
| Hyperledger Cacti | connector-fabric-publish.yaml | RELEASE | push | No | No |
| Hyperledger Cacti | connector-packages-workflow.yaml | DOCS | workflow_call | No | No |
| Hyperledger Cacti | core-packages-workflow.yaml | DOCS | workflow_call | No | No |
| Hyperledger Cacti | coverage_ts.yaml | INFRA | workflow_run | No | No |
| Hyperledger Cacti | daml-all-in-one-publish.yaml | RELEASE | push | No | No |
| Hyperledger Cacti | deploy_docs.yml | DOCS | push, workflow_dispatch | No | No |
| Hyperledger Cacti | dev-container-vscode-publish.yaml | RELEASE | push | No | No |
| Hyperledger Cacti | example-carbon-accounting-publish.yaml | RELEASE | push | No | No |
| Hyperledger Cacti | example-supply-chain-app-publish.yaml | RELEASE | push | No | No |
| Hyperledger Cacti | examples-workflow.yaml | INFRA | workflow_call | No | No |
| Hyperledger Cacti | fabric2-all-in-one-publish.yaml | RELEASE | push | No | No |
| Hyperledger Cacti | geth-all-in-one-publish.yaml | RELEASE | push | No | No |
| Hyperledger Cacti | gg-shield-action.yaml | PR_CHECK | push, pull_request | Yes | Partial (runs on PRs, but secret-backed steps are limited on forks) |
| Hyperledger Cacti | ghcr-workflow.yaml | INFRA | workflow_call | No | No |
| Hyperledger Cacti | ghpkg-all-kotlin-api-clients-publish.yaml | RELEASE | push | No | No |
| Hyperledger Cacti | htlc-packages-workflow.yaml | INFRA | workflow_call | No | No |
| Hyperledger Cacti | iroha2-all-in-one-publish.yaml | RELEASE | push | No | No |
| Hyperledger Cacti | keychain-packages-workflow.yaml | INFRA | workflow_call | No | No |
| Hyperledger Cacti | keychain-vault-server-publish.yaml | RELEASE | push | No | No |
| Hyperledger Cacti | other-packages-workflow.yaml | INFRA | workflow_call | No | No |
| Hyperledger Cacti | packages-workflow.yaml | INFRA | workflow_call | No | No |
| Hyperledger Cacti | publish-npm.yaml | RELEASE | workflow_dispatch | No | No |
| Hyperledger Cacti | satp-hermes-build.yaml | INFRA | workflow_call | No | No |
| Hyperledger Cacti | satp-hermes-codegen.yaml | INFRA | workflow_call | No | No |
| Hyperledger Cacti | satp-hermes-docs.yaml | DOCS | workflow_call, workflow_dispatch | No | No |
| Hyperledger Cacti | satp-hermes-ghcr-gateway-sdk.yaml | INFRA | workflow_call | No | No |
| Hyperledger Cacti | satp-hermes-lint.yaml | INFRA | workflow_call | No | No |
| Hyperledger Cacti | satp-hermes-npmjs-gateway-sdk.yaml | MERGE_GATE | push, workflow_dispatch, workflow_call | No | No |
| Hyperledger Cacti | satp-hermes-publish.yaml | RELEASE | workflow_call | No | No |
| Hyperledger Cacti | satp-hermes-release.yaml | RELEASE | workflow_call, workflow_dispatch | No | No |
| Hyperledger Cacti | satp-hermes-workflow.yaml | INFRA | workflow_call | No | No |
| Hyperledger Cacti | sawtooth-all-in-one-publish.yaml | RELEASE | push | No | No |
| Hyperledger Cacti | scorecard.yml | SCHEDULED | branch_protection_rule, schedule, push | No | No |
| Hyperledger Cacti | semantic-pull-request.yaml | INFRA | pull_request | Yes | Partial (runs on PRs, but secret-backed steps are limited on forks) |
| Hyperledger Cacti | test_weaver-asset-exchange-besu.yaml | INFRA | workflow_call | No | No |
| Hyperledger Cacti | test_weaver-asset-exchange-corda.yaml | INFRA | workflow_call | No | No |
| Hyperledger Cacti | test_weaver-asset-exchange-fabric.yaml | INFRA | workflow_call | No | No |
| Hyperledger Cacti | test_weaver-asset-transfer.yaml | INFRA | workflow_call | No | No |
| Hyperledger Cacti | test_weaver-corda-interop-app.yaml | INFRA | workflow_call | No | No |
| Hyperledger Cacti | test_weaver-data-sharing.yaml | INFRA | workflow_call | No | No |
| Hyperledger Cacti | test_weaver-docker-build.yaml | INFRA | workflow_call | No | No |
| Hyperledger Cacti | test_weaver-fabric-fabric-satp.yaml | INFRA | workflow_call | No | No |
| Hyperledger Cacti | test_weaver-go.yaml | INFRA | workflow_call | No | No |
| Hyperledger Cacti | test_weaver-node-pkgs.yaml | INFRA | workflow_call | No | No |
| Hyperledger Cacti | test_weaver-pre-release.yaml | RELEASE | workflow_call | No | No |
| Hyperledger Cacti | test_weaver-relay.yaml | INFRA | workflow_call | No | No |
| Hyperledger Cacti | weaver_deploy_corda-pkgs.yml | MERGE_GATE | push, workflow_dispatch | No | No |
| Hyperledger Cacti | weaver_deploy_go-pkgs.yml | MERGE_GATE | push, workflow_dispatch | No | No |
| Hyperledger Cacti | weaver_deploy_node-pkgs.yml | MERGE_GATE | push, workflow_dispatch | No | No |
| Hyperledger Cacti | weaver_deploy_relay-server.yml | MERGE_GATE | push, workflow_dispatch | No | No |
| Hyperledger Cacti | workflow-copm.yaml | INFRA | workflow_call | No | No |

## Section 2 — Cacti-Specific Gap Analysis

Cacti has a very large workflow estate, especially around package-specific publishing, Weaver integration tests, and SATP Hermes automation. Compared with Fabric, VS Code, Rust, freeCodeCamp, and Credo TS, Cacti exposes less of a clean boundary between contributor-facing PR checks and maintainer-facing release/deployment workflows. The repository does have strong PR validation coverage through files such as `checks-and-build.yaml`, `code-quality-checks.yaml`, `core-packages-workflow.yaml`, `connector-packages-workflow.yaml`, `examples-workflow.yaml`, and multiple Weaver test workflows, but the signal is diluted by the high number of adjacent publish and release workflows living in the same directory. The upstream workflow names do not by themselves explain which checks a first-time contributor should care about most, and the current contributor documentation does not surface a simple CI map in the way the better contributor-experience repositories effectively do through small, well-named workflow sets. Fork-based contributors are especially likely to be confused by publish, release, GHCR, npm, and scorecard files because those either require secrets or are not actionable for a normal PR. The strongest patterns Cacti could adopt are Fabric’s smaller split between PR validation and release security scans, Credo TS’s compact CI plus release shape, and VS Code’s very explicit naming of PR-specific operating-system test lanes.

## Section 3 — Recommended Cacti Workflow Improvements

1. Consolidate contributor-facing checks into a clearly documented small set of primary PR workflows and separate maintainer-only publish/release workflows with a naming prefix such as `release-` or `maintainer-`.
2. Add a CI overview section to `CONTRIBUTING.md` that maps common change types to the exact workflows contributors should expect on their PRs.
3. Reduce path-based fragmentation where possible by grouping related package validation into fewer reusable workflows with explicit summaries.
4. Mark secret-dependent jobs more clearly in workflow names or comments so fork contributors know which failures they can ignore versus which ones block merge.
5. Add more inline comments to the longest Weaver and SATP Hermes workflows, especially where orchestration, network setup, or publish logic is non-obvious.

## Section 4 — Contributor CI Cheat Sheet (draft for Cacti)

Hyperledger Cacti uses GitHub Actions for several different purposes, and it helps to separate contributor-facing checks from maintainer-only automation. On a normal pull request, you should expect validation workflows to run automatically for code quality, builds, package-specific checks, examples, and some Weaver or SATP-related tests depending on which paths changed. These are the workflows you should care about most before asking for review, because they are the closest thing to the repository’s merge gate. By contrast, publish, release, documentation deployment, GHCR image publication, npm publication, and similar workflows are mainly for maintainers and release managers. If you see a workflow that is clearly about publishing artifacts or pushing images, it is usually not something you need to debug for a first contribution unless your change intentionally modifies release automation. Before pushing, run the project’s documented install, lint, test, and build commands locally, and if your change touches a specific package family, run the nearest package-level checks for that area as well. When a CI check fails, read the failing job name first and map it back to the workflow file; Cacti has many workflows, so understanding whether the failure came from a core package check, a connector workflow, an example app, or a Weaver integration test will save time immediately. If the failure is in a maintainer-only publish or deploy workflow, confirm whether the job depends on repository secrets or release credentials before treating it as a contributor-side issue. If the failure is in a PR validation workflow, reproduce the failing command locally, fix the issue, and push a follow-up commit rather than guessing. If a failure seems unrelated to your change or appears to depend on external services, mention that in the PR and ask a maintainer whether the failure is a known flaky lane or a restricted workflow that behaves differently on forks.
