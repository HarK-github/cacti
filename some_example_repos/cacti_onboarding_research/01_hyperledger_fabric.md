# Hyperledger Fabric — Onboarding & DX Research

## Repository
- URL: https://github.com/hyperledger/fabric
- Stars: 16638
- Contributors: 568
- Primary Language: Go

## Onboarding Files Present
| File | Exists? | Notes |
|------|---------|-------|
| README.md | ✅ | README.md |
| CONTRIBUTING.md | ✅ | CONTRIBUTING.md |
| ISSUE_TEMPLATE | ✅ | bug.yaml,config.yml feature.yaml workitem.yaml |
| PR_TEMPLATE | ✅ | .github/PULL_REQUEST_TEMPLATE.md |
| CODEOWNERS | ✅ | CODEOWNERS |
| CODE_OF_CONDUCT | ✅ | CODE_OF_CONDUCT.md |
| MAINTAINERS/GOVERNANCE | ✅ | MAINTAINERS.md |

## Issue Labels for Contributors
- Open issues labeled `good first issue`: 1
- Open issues labeled `help wanted`: 0
- Beginner/contributor-facing labels found: good first issue, help wanted
- Sample active labels in the repo: bug, channel-participation-api, conflicts, dep, dependencies, do-not-merge, doc-merge, documentation, draft, duplicate, enhancement, Epic, go, good first issue, help wanted, invalid, ledger-snapshot, needs-dco-signoff, needs-release-note, pending-other-pr, python, question, size=L, size=M, size=S

## CI/CD Workflows
- Notable workflows: `verify-build.yml`, `vulnerability-scan.yml`, `broken-link-checker.yml`, `scorecard.yml`, `release.yml`.
- PR coverage: build verification, link checking, and security-oriented checks are visible from the workflow set.
- Recent merged PR span for the last 10 merged PRs: 2026-04-12T07:06:25Z to 2026-05-03T12:01:30Z

## Key Onboarding Practices (summary)
- Puts the contributor guide in a visible top-level location and links to deeper docs rather than overloading the README.
- Uses issue forms for bugs, features, and work items, which improves triage quality from the first interaction.
- Publishes maintainer ownership and a code of conduct in-repo, so community expectations are easy to find.
- Shows quality and security signals prominently in the README, including build status and scorecard badges.

## Specific Patterns to Adopt for Cacti
- Mirror Fabric's split between a concise root CONTRIBUTING guide and deeper task-specific docs under `docs/`.
- Add a dedicated work-item issue form so design, refactor, and project-cleanup proposals are structured before implementation starts.
- Surface project quality signals in one contributor-facing dashboard page instead of scattering them across badges and workflows.
- Make maintainer ownership easier to navigate by pairing CODEOWNERS with a human-readable maintainer map.

## Raw Notes / Interesting Snippets

- Top-level docs folder snapshot: .gitignore,Makefile README.md custom_theme requirements.txt,source wrappers
- README excerpt:
```text
# Hyperledger Fabric
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/hyperledger/fabric/badge)](https://scorecard.dev/viewer/?uri=github.com/hyperledger/fabric)
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/955/badge)](https://bestpractices.coreinfrastructure.org/projects/955)
[![Go Report Card](https://goreportcard.com/badge/github.com/hyperledger/fabric)](https://goreportcard.com/report/github.com/hyperledger/fabric)
[![GoDoc](https://godoc.org/github.com/hyperledger/fabric?status.svg)](https://godoc.org/github.com/hyperledger/fabric)
[![Documentation Status](https://readthedocs.org/projects/hyperledger-fabric/badge/?version=latest)](http://hyperledger-fabric.readthedocs.io/en/latest)
[![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/hyperledger/fabric/verify-build.yml?branch=main&label=build%20-%20main)](https://github.com/hyperledger/fabric/actions/workflows/verify-build.yml)
[![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/hyperledger/fabric/verify-build.yml?branch=release-2.5&label=build%20-%20release-2.5)](https://github.com/hyperledger/fabric/actions/workflows/verify-build.yml)
[![Security vulnerability scan](https://github.com/hyperledger/fabric/actions/workflows/vulnerability-scan.yml/badge.svg?branch=main)](https://github.com/hyperledger/fabric/actions/workflows/vulnerability-scan.yml)
[![GitHub go.mod Go version](https://img.shields.io/github/go-mod/go-version/hyperledger/fabric)](https://github.com/hyperledger/fabric/blob/main/go.mod)
[![GitHub Release](https://img.shields.io/github/v/release/hyperledger/fabric)](https://github.com/hyperledger/fabric/releases)
## Overview
```
- CONTRIBUTING excerpt:
```text
## Contributing
We welcome contributions to the Hyperledger Fabric Project in many forms, and
there's always plenty to do!
Please visit the
[contributors guide](http://hyperledger-fabric.readthedocs.io/en/latest/CONTRIBUTING.html) in the
docs to learn how to make contributions to this exciting project.
## Running Unit tests
An example of using the script as used in the CI pipeline to run Unit Tests 
```
TEST_PKGS=github.com/hyperledger/fabric/core/chaincode/... ./scripts/run-unit-tests.sh
```
## Creating the mocks for unit tests
```
- Issue template excerpt:
```text
# Copyright the Hyperledger Fabric contributors. All rights reserved.
#
# SPDX-License-Identifier: Apache-2.0
#
# How to modify this file: https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-issue-forms
name: Bug Report
description: Let us know what went wrong
labels: ["bug"]
body:
  - type: textarea
    id: bug
    attributes:
```
