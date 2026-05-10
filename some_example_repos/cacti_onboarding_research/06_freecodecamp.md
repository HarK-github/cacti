# freeCodeCamp — Onboarding & DX Research

## Repository
- URL: https://github.com/freeCodeCamp/freeCodeCamp
- Stars: 444082
- Contributors: 6444
- Primary Language: TypeScript

## Onboarding Files Present
| File | Exists? | Notes |
|------|---------|-------|
| README.md | ✅ | README.md |
| CONTRIBUTING.md | ❌ | Not found |
| ISSUE_TEMPLATE | ✅ | 01--issues-with-coding-challenges.yml,02--issues-with-software-on-platforms.yml 03--issues-with-content-on-articles-and-docs.yml 04--feature-request-for-freecodecamp-org-s-platforms.yml config.yml |
| PR_TEMPLATE | ✅ | .github/PULL_REQUEST_TEMPLATE.md |
| CODEOWNERS | ✅ | .github/CODEOWNERS |
| CODE_OF_CONDUCT | ❌ | Not found |
| MAINTAINERS/GOVERNANCE | ❌ | Not found |

## Issue Labels for Contributors
- Open issues labeled `good first issue`: 0
- Open issues labeled `help wanted`: 18
- Beginner/contributor-facing labels found: help wanted
- Sample active labels in the repo: archived coursework, backend js v9, bookmark, catalog, crowdin-sync, daily coding challenge, deprioritized, device specific, DO NOT MERGE!, english for developers, first timers only, frontend libraries v9 cert, help wanted, js v9 cert, lesson, MERGE CONFLICT!, Naomi's Sprints, odin project, platform: api, platform: coderadio, platform: exam environment, platform: forum, platform: learn, platform: news, professional chinese

## CI/CD Workflows
- Notable workflows: `node.js-tests.yml`, `e2e-playwright.yml`, `devcontainer-ci.yml`, `github-pr-guidelines.yml`, `i18n-validate-prs.yml`.
- PR coverage: tests, end-to-end validation, contributor guideline checks, and i18n validation.
- Recent merged PR span for the last 10 merged PRs: 2026-04-30T12:10:49Z to 2026-05-03T04:57:42Z

## Key Onboarding Practices (summary)
- Signals newcomer friendliness directly in the README and issue taxonomy.
- Uses issue forms scoped to product area, which helps contributors understand where to report problems.
- PR workflows include contributor-guidance automation, not just tests, which improves submission quality.
- Keeps a visible CODEOWNERS file and very active `help wanted` inventory for external contributors.

## Specific Patterns to Adopt for Cacti
- Put an explicit newcomer-friendly badge or callout in the README so the project signals approachability immediately.
- Expand label automation and PR guidance checks to coach contributors before maintainers have to review manually.
- Create issue forms that map directly to docs, examples, curriculum-style tutorials, and product areas.
- Treat contributor education as part of CI by validating PR conventions and required metadata automatically.

## Raw Notes / Interesting Snippets

- Top-level docs folder snapshot: No top-level `docs/` folder found
- README excerpt:
```text
[![freeCodeCamp Social Banner](https://cdn.freecodecamp.org/platform/universal/fcc_banner_new.png)](https://www.freecodecamp.org/)
[![first-timers-only Friendly](https://img.shields.io/badge/first--timers--only-friendly-blue.svg)](https://www.firsttimersonly.com/)
[![Discord](https://img.shields.io/discord/692816967895220344?logo=discord&label=Discord&color=5865F2)](https://discord.gg/PRyKn3Vbay)
[![LFX Active Contributors](https://insights.linuxfoundation.org/api/badge/active-contributors?project=freecodecamp&repos=https://github.com/freeCodeCamp/freeCodeCamp)](https://insights.linuxfoundation.org/project/freecodecamp/repository/freecodecamp-freecodecamp)
## freeCodeCamp.org's open-source codebase and curriculum
[freeCodeCamp.org](https://www.freecodecamp.org) is a friendly community where you can learn to code for free. It is run by a [donor-supported 501(c)(3) charity](https://www.freecodecamp.org/donate) to help millions of busy adults transition into tech. Our community has already helped more than 100,000 people get their first developer job.
Our full-stack web development and machine learning curriculum is completely free and self-paced. We have thousands of interactive coding challenges to help you expand your skills.
## Table of Contents
- [Certifications](#certifications)
- [The Learning Platform](#the-learning-platform)
- [Reporting Bugs and Issues](#reporting-bugs-and-issues)
- [Reporting Security Issues and Responsible Disclosure](#reporting-security-issues-and-responsible-disclosure)
```
- CONTRIBUTING excerpt:
```text

```
- Issue template excerpt:
```text
name: Issue - Content in our Coding Challenges
description: Report issues with a specific challenge, like broken tests, unclear instructions, etc.
labels: ['scope: curriculum', 'type: bug', 'status: waiting triage']
body:
  - type: markdown
    attributes:
      value: If you're reporting a security issue, don't create a GitHub issue. Instead, visit https://contribute.freecodecamp.org/#/security.
  - type: textarea
    attributes:
      label: Describe the Issue
      description: A clear and concise description of the issue you encountered.
    validations:
```
