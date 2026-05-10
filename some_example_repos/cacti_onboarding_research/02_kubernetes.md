# Kubernetes — Onboarding & DX Research

## Repository
- URL: https://github.com/kubernetes/kubernetes
- Stars: 122049
- Contributors: 5689
- Primary Language: Go

## Onboarding Files Present
| File | Exists? | Notes |
|------|---------|-------|
| README.md | ✅ | README.md |
| CONTRIBUTING.md | ✅ | CONTRIBUTING.md |
| ISSUE_TEMPLATE | ✅ | bug-report.yaml,config.yml enhancement.yaml failing-test.yaml flaking-test.yaml |
| PR_TEMPLATE | ✅ | .github/PULL_REQUEST_TEMPLATE.md |
| CODEOWNERS | ❌ | Not found |
| CODE_OF_CONDUCT | ❌ | Not found |
| MAINTAINERS/GOVERNANCE | ❌ | Not found |

## Issue Labels for Contributors
- Open issues labeled `good first issue`: 10
- Open issues labeled `help wanted`: 143
- Beginner/contributor-facing labels found: None found
- Sample active labels in the repo: ¯\_(ツ)_/¯, api-review, approved, area/admin, area/admission-control, area/api, area/api-validation, area/apiserver, area/app-lifecycle, area/artifacts, area/audit, area/batch, area/build-release, area/cadvisor, area/client-libraries, area/cloudprovider, area/code-generation, area/code-organization, area/code-organization/future-dependencies, area/community-meeting, area/configmap-api, area/conformance, area/controller-manager, area/custom-resources, area/declarative-configuration

## CI/CD Workflows
- Notable workflows were not present under `.github/workflows/` in the root repo snapshot gathered here.
- PR coverage still appears strong from overall merge velocity and project process, but workflow definitions may live elsewhere or be generated differently.
- Recent merged PR span for the last 10 merged PRs: 2026-05-01T10:41:22Z to 2026-05-03T17:43:36Z

## Key Onboarding Practices (summary)
- Splits project onboarding cleanly between the code repo and the community repo, keeping the contribution path focused.
- Maintains a strong taxonomy of contributor-facing labels, especially `help wanted`, so there is visible work for newcomers.
- Uses structured issue forms for bug reports, enhancements, and flaky tests to route issues to the right maintainers faster.
- Keeps PR throughput high, which reduces the risk that first-time contributors wait too long for feedback.

## Specific Patterns to Adopt for Cacti
- Borrow Kubernetes' stronger contributor label strategy by expanding beyond `help wanted` into `good first issue`, area labels, and triage-ready starter work.
- Separate "code repo" onboarding from "community repo" onboarding so contributors know where to go for process versus implementation details.
- Publish a contributor guide page that maps common tasks to maintainers, SIG-style groups, or subsystem owners.
- Keep issue forms narrowly scoped by problem type to reduce vague or misrouted reports.

## Raw Notes / Interesting Snippets

- Top-level docs folder snapshot: .gitignore,OWNERS
- README excerpt:
```text
# Kubernetes (K8s)
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/569/badge)](https://bestpractices.coreinfrastructure.org/projects/569) [![Go Report Card](https://goreportcard.com/badge/github.com/kubernetes/kubernetes)](https://goreportcard.com/report/github.com/kubernetes/kubernetes) ![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/kubernetes/kubernetes?sort=semver)
<img src="https://github.com/kubernetes/kubernetes/raw/master/logo/logo.png" width="100">
----
Kubernetes, also known as K8s, is an open source system for managing [containerized applications]
across multiple hosts. It provides basic mechanisms for the deployment, maintenance,
and scaling of applications.
Kubernetes builds upon a decade and a half of experience at Google running
production workloads at scale using a system called [Borg],
combined with best-of-breed ideas and practices from the community.
Kubernetes is hosted by the Cloud Native Computing Foundation ([CNCF]).
If your company wants to help shape the evolution of
```
- CONTRIBUTING excerpt:
```text
# Contributing
Welcome to Kubernetes! To learn more about contributing to the [Kubernetes code repo](README.md), check out the [Contributor's Guide](https://git.k8s.io/community/contributors/guide/).
The [Kubernetes community repo](https://github.com/kubernetes/community) contains information about how to get started, how the community organizes, and more.
## Sign the CLA
You must sign the [Contributor License Agreement](https://git.k8s.io/community/contributors/guide/README.md#sign-the-cla) in order to contribute.
```
- Issue template excerpt:
```text
name: Bug Report
description: Report a bug encountered while operating Kubernetes
labels: kind/bug
body:
  - type: textarea
    id: problem
    attributes:
      label: What happened?
      description: |
        Please provide as much info as possible. Not doing so may result in your bug not being addressed in a timely manner.
        If this matter is security related, please disclose it privately via https://kubernetes.io/security
    validations:
```
