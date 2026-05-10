# CHAOSS GrimoireLab — Onboarding & DX Research

## Repository
- URL: https://github.com/chaoss/grimoirelab
- Stars: 597
- Contributors: 65
- Primary Language: Shell

## Onboarding Files Present
| File | Exists? | Notes |
|------|---------|-------|
| README.md | ✅ | README.md |
| CONTRIBUTING.md | ✅ | CONTRIBUTING.md |
| ISSUE_TEMPLATE | ❌ | Not found |
| PR_TEMPLATE | ❌ | Not found |
| CODEOWNERS | ❌ | Not found |
| CODE_OF_CONDUCT | ❌ | Not found |
| MAINTAINERS/GOVERNANCE | ✅ | MAINTAINERS.md |

## Issue Labels for Contributors
- Open issues labeled `good first issue`: 0
- Open issues labeled `help wanted`: 1
- Beginner/contributor-facing labels found: good first issue, help wanted
- Sample active labels in the repo: 2.x, api, bug, configuration, data access, data model, data processing, dependencies, duplicate, enhancement, events, good first issue, help wanted, integration, invalid, perceval, python, question, scheduling, sortinghat, wontfix

## CI/CD Workflows
- Notable workflows: `release.yml`, `docker-image.yml`, `grimoirelab-release.yml`, `release-grimoirelab-component.yml`.
- PR coverage is less visible than release automation; contributor onboarding depends more on docs than on PR-specific workflow signaling.
- Recent merged PR span for the last 10 merged PRs: 2025-11-04T10:50:41Z to 2026-02-05T08:11:47Z

## Key Onboarding Practices (summary)
- The README includes a real "getting started" path instead of only a conceptual overview.
- CONTRIBUTING explicitly welcomes non-code work such as support, docs, and analytics-related improvements.
- Maintainers are published, which helps newcomers identify where decisions live.
- The repo keeps release automation separated from contributor onboarding, which makes expectations easier to follow.

## Specific Patterns to Adopt for Cacti
- Build a true quick-start path for running a minimal local development setup, similar to GrimoireLab's default setup messaging.
- Emphasize non-code contribution paths in CONTRIBUTING so newcomers without deep blockchain expertise can still contribute.
- Publish a simplified "first successful contribution" path focused on docs, examples, or test improvements.
- Pair maintainer listings with a practical "who reviews what" reference for common onboarding tasks.

## Raw Notes / Interesting Snippets

- Top-level docs folder snapshot: LICENSE,README.md _config.yml _data _includes,_layouts _site ar css,font-awesome fonts img index.html,js
- README excerpt:
```text
# GrimoireLab
[![grimoirelab-showcase](https://user-images.githubusercontent.com/25265451/84442403-30dcce80-ac5b-11ea-9f5b-60266d875ebd.png "GrimoireLab | CHAOSS Bitergia Analytics")](https://chaoss.biterg.io/app/kibana#/dashboard/Overview)
GrimoireLab is a [CHAOSS](https://chaoss.community) toolset for software development analytics. It includes a coordinated set of tools
to retrieve data from systems used to support software development (repositories), store it in databases,
enrich it by computing relevant metrics, and make it easy to run analytics and visualizations on it.
You can learn more about GrimoireLab in the [GrimoireLab tutorial](https://chaoss.github.io/grimoirelab-tutorial/),
or visit the [GrimoireLab website](https://chaoss.github.io/grimoirelab).
Metrics available in GrimoireLab are, in part, developed in the CHAOSS project. For more information regarding CHAOSS metrics, see the latest release at: https://chaoss.community/metrics/
# Getting started
To ease the newcomer experience we are providing a [default setup](default-grimoirelab-settings)
to analyze git activity for this repository. For this set up, there are several options to run GrimoireLab:
## Using `docker-compose`
```
- CONTRIBUTING excerpt:
```text
# Contributing to GrimoireLab
There are multiple ways to contribute to GrimoireLab. You can help other
users solve their issues running the platform, report issues you might have
found using in our software, propose new ideas, improve documentation,
and even write code to add new features or fix existing bugs.
The following is information and general guidelines for collaborating with us.
## Before You Contribute
Before opening a new discussion, bug, issue, etc, please check if similar one
has already been reported. This helps us avoid duplication of effort and keeps
our discussions and issues focused.
Also, please check our [Code of Conduct](https://github.com/chaoss/.github/blob/main/CODE_OF_CONDUCT.md).
GrimoireLab is part of the [CHAOSS Collaborative Project](http://chaoss.community)
```
- Issue template excerpt:
```text

```
