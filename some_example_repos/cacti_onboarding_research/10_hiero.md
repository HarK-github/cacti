# Hiero — Onboarding & DX Research

## Repository
- URL: https://github.com/hiero-ledger/hiero
- Stars: 26
- Contributors: 11
- Primary Language: Python

## Onboarding Files Present
| File | Exists? | Notes |
|------|---------|-------|
| README.md | ✅ | README.md |
| CONTRIBUTING.md | ❌ | Not found |
| ISSUE_TEMPLATE | ❌ | Not found |
| PR_TEMPLATE | ❌ | Not found |
| CODEOWNERS | ❌ | Not found |
| CODE_OF_CONDUCT | ❌ | Not found |
| MAINTAINERS/GOVERNANCE | ❌ | Not found |

## Issue Labels for Contributors
- Open issues labeled `good first issue`: 0
- Open issues labeled `help wanted`: 0
- Beginner/contributor-facing labels found: Good First Issue, Good First Issue Candidate, help wanted
- Sample active labels in the repo: Audit, best practices, bug, documentation, duplicate, enhancement, github_actions, Good First Issue, Good First Issue Candidate, hacktoberfest, hacktoberfest-accepted, help wanted, invalid, learning, Non-Code, question, Spam, volunteer, wontfix

## CI/CD Workflows
- No root `.github/workflows/` inventory was found in the snapshot gathered here.
- PR automation is minimal or absent in this entrypoint repo, which keeps it simple but also means less contributor guidance is encoded in CI.
- Recent merged PR span for the last 10 merged PRs: 2025-09-24T19:02:28Z to 2026-04-02T14:43:51Z

## Key Onboarding Practices (summary)
- Hiero positions this repository as the project entrypoint, which is a strong onboarding choice for a multi-repo ecosystem.
- The repository's value is organizational clarity: non-technical definitions, project context, and central navigation live in one place.
- The repo uses labels like `Good First Issue Candidate`, `learning`, `Non-Code`, and `volunteer`, which signals contributor intent even though formal scaffolding is light.
- As an entry repo, it lowers the chance that newcomers start in a deep subsystem before they understand the project structure.

## Specific Patterns to Adopt for Cacti
- Borrow Hiero's entrypoint-repo pattern by keeping one clear landing place for project-wide onboarding, governance, and repository map content.
- Add a top-level ecosystem map for Cacti that explains which repos or subsystems a newcomer should approach first.
- Treat non-technical onboarding documents as first-class project artifacts instead of scattering them across technical docs.
- Use the entry repo to direct contributors toward starter issues in the right downstream modules.

## Raw Notes / Interesting Snippets

- Top-level docs folder snapshot: No top-level `docs/` folder found
- README excerpt:
```text
# Hiero
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/hiero-ledger/hiero/badge)](https://scorecard.dev/viewer/?uri=github.com/hiero-ledger/hiero)
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/10697/badge)](https://bestpractices.coreinfrastructure.org/projects/10697)
[![License](https://img.shields.io/badge/license-apache2-blue.svg)](LICENSE)
## Overview
This repository is the main entrypoint for the Hiero project at GitHub.
General information about the project can be found on our [landing page](https://hiero.org). 
We will use this repository as a central point for [Github discussions regarding Hiero](https://github.com/orgs/LFDT-Hiero/discussions) and for [general issues](https://github.com/LFDT-Hiero/hiero/issues).
## Transfering and adding repositories into [hiero-ledger](https://github.com/hiero-ledger/)
### 👉 Transition trackers
- [Transition of projects to Hiero](https://github.com/hiero-ledger/hiero/blob/main/community-transition.md)
- COMPLETED - [Transition of Hedera projects to Hiero](https://github.com/hiero-ledger/hiero/blob/main/transition.md)
```
- CONTRIBUTING excerpt:
```text

```
- Issue template excerpt:
```text

```
