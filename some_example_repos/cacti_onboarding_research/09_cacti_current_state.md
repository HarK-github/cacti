# Hyperledger Cacti — Onboarding & DX Research

## Repository
- URL: https://github.com/hyperledger-cacti/cacti
- Stars: 387
- Contributors: 144
- Primary Language: TypeScript

## Onboarding Files Present
| File | Exists? | Notes |
|------|---------|-------|
| README.md | ✅ | README.md |
| CONTRIBUTING.md | ✅ | CONTRIBUTING.md |
| ISSUE_TEMPLATE | ✅ | bug_report.md,feature_request.md user-story-template.md |
| PR_TEMPLATE | ✅ | PULL_REQUEST_TEMPLATE.md |
| CODEOWNERS | ✅ | CODEOWNERS |
| CODE_OF_CONDUCT | ✅ | CODE_OF_CONDUCT.md |
| MAINTAINERS/GOVERNANCE | ✅ | MAINTAINERS.md |

## Issue Labels for Contributors
- Open issues labeled `good first issue`: 0
- Open issues labeled `help wanted`: 6
- Beginner/contributor-facing labels found: help wanted
- Sample active labels in the repo: API_Server, backlog, Besu, Breaking_V2, bug, Chia, cleanup, Corda, Core_API, DAML, dependencies, dependent, Developer_Experience, documentation, duplicate, enhancement, Epic, ethereum, Fabric, Flaky-Test-Automation, GFI_Climate_Action_SIG, github_actions, go, good-first-issue, good-first-issue-100-introductory

## CI/CD Workflows
- Notable workflows: `checks-and-build.yaml`, `ci.yaml`, `code-quality-checks.yaml`, `coverage_ts.yaml`, `codeql-analysis.yml`, `semantic-pull-request.yaml`, plus many package and connector-specific workflows.
- PR coverage: broad build, quality, security, coverage, semantic PR, and subsystem-specific validation, but the workflow surface is large for newcomers.
- Recent merged PR span for the last 10 merged PRs: 2026-04-20T17:17:32Z to 2026-04-29T20:02:43Z

## Key Onboarding Practices (summary)
- Cacti already has many of the structural ingredients: CONTRIBUTING, issue templates, PR template, CODEOWNERS, code of conduct, and maintainers.
- The docs surface is broad, and the README clearly explains project scope and current cleanup efforts.
- CI coverage is extensive and shows strong engineering rigor across packages, connectors, publish flows, and security scans.
- The repo uses `help wanted`, but beginner-targeted issue discovery is still much weaker than the strongest comparison repos.

## Specific Patterns to Adopt for Cacti
- Add a real `good first issue` program with triaged starter issues and a documented SLA for first response.
- Create a concise "start here" guide that sits above the current long-form CONTRIBUTING content and points to the right subsystem docs.
- Distill the very large workflow inventory into a contributor-facing CI map: what runs on normal PRs, what is optional, and what only maintainers need.
- Introduce mentorship-oriented labels and newcomer-safe issue templates tied to docs, tests, examples, and cleanup work.

## Raw Notes / Interesting Snippets
- Note: the repo listed in `tasks.md` as `hyperledger/cacti` is now `hyperledger-cacti/cacti`; the audit used the live repository.
- Top-level docs folder snapshot: .gitignore,CODEOWNERS LICENSE README.md assets,docs mkdocs.yml overrides requirements.txt,scripts
- README excerpt:
```text
 [![Open in Visual Studio Code](https://img.shields.io/static/v1?logo=visualstudiocode&label=&message=Open%20in%20Visual%20Studio%20Code&labelColor=2c2c32&color=007acc&logoColor=007acc)](https://vscode.dev/github/hyperledger-cacti/cacti)
 [![License](https://img.shields.io/github/license/hyperledger-cacti/cacti)](https://opensource.org/licenses/Apache-2.0) [![LFX Health Score](https://insights.linuxfoundation.org/api/badge/health-score?project=cacti)](https://insights.linuxfoundation.org/project/cacti) [![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/4089/badge)](https://bestpractices.coreinfrastructure.org/projects/4089)[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/hyperledger-cacti/cacti/badge)](https://scorecard.dev/viewer/?uri=github.com/hyperledger-cacti/cacti)
 [![GitHub issues](https://img.shields.io/github/issues/hyperledger-cacti/cacti)](https://github.com/hyperledger-cacti/cacti/issues)
[![LFX Active Contributors](https://insights.linuxfoundation.org/api/badge/active-contributors?project=cacti)](https://insights.linuxfoundation.org/project/cacti)
![Cacti Logo Color](./images/HL_Cacti_Logo_Color.png#gh-light-mode-only)
![Cacti Logo Color](./images/HL_Cacti_Logo_Colorreverse.svg#gh-dark-mode-only)
# Hyperledger Cacti
Hyperledger Cacti is a multi-faceted pluggable interoperability framework to link networks built on heterogeneous distributed ledger and blockchain technologies and to run transactions spanning multiple networks. This project is the result of a merger of the [Weaver Lab](https://github.com/hyperledger-labs/weaver-dlt-interoperability) project with **Hyperledger Cactus**, which was subsequently renamed to **Cacti**. It draws on the cutting-edge technological features of both constituent projects to provide a common general purpose platform and toolkit for DLT interoperability. This was the first-of-a-kind merger of two systems, architecture and code bases, to create a new project, under the Hyperledger Foundation. See this [Hyperledger Foundation blog article](https://www.hyperledger.org/blog/2022/11/07/introducing-hyperledger-cacti-a-multi-faceted-pluggable-interoperability-framework) for more information about the merger.
[Cacti is a _Graduated_ Hyperledger project](https://www.hyperledger.org/blog/hyperledger-cacti-a-general-purpose-modular-interoperability-framework-moves-to-graduated-status). Information on the different stages of a Hyperledger project and graduation criteria can be found in
the [Hyperledger Project Incubation Exit Criteria document](https://wiki.hyperledger.org/display/TSC/Project+Incubation+Exit+Criteria).
# 📍 Important announcement
We are conducting an initiative called "Cacti cleanup". The initiative focuses on several key goals:​
```
- CONTRIBUTING excerpt:
```text
- [Git Know How / Reading List](#git-know-how--reading-list)
- [Small, Focused Pull Requests](#small-focused-pull-requests)
- [PR Checklist - Contributor/Developer](#pr-checklist---contributordeveloper)
- [PR Checklist - Maintainer/Reviewer](#pr-checklist---maintainerreviewer)
- [Create local branch](#create-local-branch)
  - [Directory structure](#directory-structure)
- [Create a new package](#create-a-new-package)
- [Test Automation](#test-automation)
  - [Summary](#summary)
  - [Test Case Core Principles](#test-case-core-principles)
- [Working with the Code](#working-with-the-code)
  - [Running/Debugging the tests](#runningdebugging-the-tests)
```
- Issue template excerpt:
```text
---
name: Bug report
about: Create a report to help us improve
title: ''
labels: bug
assignees: ''
---
**Describe the bug**
A clear and concise description of what the bug is.
**To Reproduce**
Steps to reproduce the behavior on a successfully deployed Hyperledger Cactus cluster.
**Expected behavior**
```
