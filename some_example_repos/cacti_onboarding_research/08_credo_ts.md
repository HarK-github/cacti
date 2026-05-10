# Credo TS — Onboarding & DX Research

## Repository
- URL: https://github.com/openwallet-foundation/credo-ts
- Stars: 343
- Contributors: 89
- Primary Language: TypeScript

## Onboarding Files Present
| File | Exists? | Notes |
|------|---------|-------|
| README.md | ✅ | README.md |
| CONTRIBUTING.md | ✅ | CONTRIBUTING.md |
| ISSUE_TEMPLATE | ❌ | Not found |
| PR_TEMPLATE | ❌ | Not found |
| CODEOWNERS | ✅ | CODEOWNERS |
| CODE_OF_CONDUCT | ❌ | Not found |
| MAINTAINERS/GOVERNANCE | ✅ | MAINTAINERS.md |

## Issue Labels for Contributors
- Open issues labeled `good first issue`: 3
- Open issues labeled `help wanted`: 0
- Beginner/contributor-facing labels found: Good First Issue
- Sample active labels in the repo: 0.2.0, 0.3.0, 0.5.0, AIP 1.0, AIP 2.0, alpha-release, breaking change, bug, ci-test, dependencies, DIDComm V2, docker, github_actions, github-actions, Good First Issue, Indy, javascript, JSON-LD VC, ledger agnostic anoncreds, modularization, multitenancy, npm, OOB - DidExchange, Platform: Node.JS, Platform: React Native

## CI/CD Workflows
- Notable workflows: `continuous-integration.yml`, `lint-pr.yml`, `repolinter.yml`, `scorecard.yml`, `release.yml`.
- PR coverage: core CI and PR linting are easy to identify from the workflow names.
- Recent merged PR span for the last 10 merged PRs: 2026-04-15T12:00:57Z to 2026-04-30T09:09:52Z

## Key Onboarding Practices (summary)
- CONTRIBUTING is short, practical, and explicit about how to propose large changes before coding them.
- Maintainer ownership is visible through both CODEOWNERS and a dedicated maintainers document.
- The checklist in CONTRIBUTING helps reviewers and contributors converge on smaller, more frequent changes.
- CI is comparatively compact and easier for a new contributor to understand than many larger platform repos.

## Specific Patterns to Adopt for Cacti
- Tighten CONTRIBUTING into a shorter entry path with a clear pre-PR checklist and escalation path for large changes.
- Encourage issue-first discussion for major architectural work to reduce rework across complex subsystems.
- Keep release cadence guidance visible so contributors understand how small, incremental PRs are preferred.
- Preserve a smaller, comprehensible CI surface for common contributor workflows even if the full release matrix remains large.

## Raw Notes / Interesting Snippets

- Top-level docs folder snapshot: No top-level `docs/` folder found
- README excerpt:
```text
<p align="center">
  <br />
  <img
    alt="Credo Logo"
    src="https://raw.githubusercontent.com/openwallet-foundation/credo-ts/c7886cb8377ceb8ee4efe8d264211e561a75072d/images/credo-logo.png"
    height="250px"
  />
</p>
<h1 align="center"><b>Credo</b></h1>
<p align="center">
  <img
    alt="Pipeline Status"
```
- CONTRIBUTING excerpt:
```text
## How to contribute
You are encouraged to contribute to the repository by **forking and submitting a pull request**.
(If you are new to GitHub, you might start with a [basic tutorial](https://help.github.com/articles/set-up-git) and check out a more detailed guide to [pull requests](https://help.github.com/articles/using-pull-requests/).)
Pull requests will be evaluated by the repository guardians on a schedule and if deemed beneficial will be committed to the main branch. Pull requests should have a descriptive name and include an summary of all changes made in the pull request description.
If you would like to propose a significant change, please open an issue first to discuss the proposed changes with the community and to avoid re-work.
Contributions are made pursuant to the Developer's Certificate of Origin, available at [https://developercertificate.org](https://developercertificate.org), and licensed under the Apache License, version 2.0 (Apache-2.0).
## Contributing checklist:
- It is difficult to manage a release with too many changes.
  - We should **release more often**, not months apart.
  - We should focus on feature releases (minor and patch releases) to speed iteration.
    - See our [Credo Docs on semantic versioning](https://credo.js.org/guides/updating#versioning). Notably, while our versions are pre 1.0.0, minor versions are breaking change versions.
- Mixing breaking changes with other PRs slows development.
```
- Issue template excerpt:
```text

```
