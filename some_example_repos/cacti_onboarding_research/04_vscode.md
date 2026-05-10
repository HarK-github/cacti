# Visual Studio Code — Onboarding & DX Research

## Repository
- URL: https://github.com/microsoft/vscode
- Stars: 184518
- Contributors: 3063
- Primary Language: TypeScript

## Onboarding Files Present
| File | Exists? | Notes |
|------|---------|-------|
| README.md | ✅ | README.md |
| CONTRIBUTING.md | ✅ | CONTRIBUTING.md |
| ISSUE_TEMPLATE | ✅ | bug_report.md,config.yml copilot_bug_report.md feature_request.md |
| PR_TEMPLATE | ✅ | .github/pull_request_template.md |
| CODEOWNERS | ✅ | .github/CODEOWNERS |
| CODE_OF_CONDUCT | ❌ | Not found |
| MAINTAINERS/GOVERNANCE | ❌ | Not found |

## Issue Labels for Contributors
- Open issues labeled `good first issue`: 22
- Open issues labeled `help wanted`: 502
- Beginner/contributor-facing labels found: None found
- Sample active labels in the repo: *as-designed, *caused-by-extension, *dev-question, *duplicate, *edu, *english-please, *error-fix-driving, *extension-candidate, *fix, *investigate, *not-reproducible, *off-topic, *out-of-scope, *question, *trigger-cache-update, *workspace-trust-docs, /tests, ~accessibility-sla, ~agent-behavior, ~capi, ~chat-authentication, ~chat-billing, ~chat-infinite-response-loop, ~chat-lm-unavailable, ~chat-no-response-returned

## CI/CD Workflows
- Notable workflows: `pr.yml`, `pr-linux-test.yml`, `pr-darwin-test.yml`, `pr-win32-test.yml`, `pr-linux-cli-test.yml`, `screenshot-test.yml`, `component-fixture-tests.yml`.
- PR coverage: multi-platform testing, screenshot validation, component fixtures, and proposal/version checks.
- Recent merged PR span for the last 10 merged PRs: 2026-03-18T10:12:22Z to 2026-05-03T18:16:37Z

## Key Onboarding Practices (summary)
- The contributing guide steers users to the correct support channel before they file issues, reducing maintainers' triage load.
- The repo has dedicated PR workflows for different operating systems and test categories, making CI intent easy to understand.
- Issue templates are backed by contributor education in the wiki, so people learn how to report issues well.
- Ownership is explicit through CODEOWNERS and a large set of PR-specific workflows.

## Specific Patterns to Adopt for Cacti
- Add a "where to ask vs where to file" section near the top of CONTRIBUTING to keep issues focused.
- Break CI communication down into a short contributor guide that explains which workflows matter for a typical PR.
- Use targeted PR workflows and naming conventions that make failures easier for first-time contributors to interpret.
- Maintain a living roadmap or iteration-plan page so contributors can align work with active priorities.

## Raw Notes / Interesting Snippets

- Top-level docs folder snapshot: No top-level `docs/` folder found
- README excerpt:
```text
# Visual Studio Code - Open Source ("Code - OSS")
[![Feature Requests](https://img.shields.io/github/issues/microsoft/vscode/feature-request.svg)](https://github.com/microsoft/vscode/issues?q=is%3Aopen+is%3Aissue+label%3Afeature-request+sort%3Areactions-%2B1-desc)
[![Bugs](https://img.shields.io/github/issues/microsoft/vscode/bug.svg)](https://github.com/microsoft/vscode/issues?utf8=✓&q=is%3Aissue+is%3Aopen+label%3Abug)
[![Gitter](https://img.shields.io/badge/chat-on%20gitter-yellow.svg)](https://gitter.im/Microsoft/vscode)
## The Repository
This repository ("`Code - OSS`") is where we (Microsoft) develop the [Visual Studio Code](https://code.visualstudio.com) product together with the community. Not only do we work on code and issues here, but we also publish our [roadmap](https://github.com/microsoft/vscode/wiki/Roadmap), [monthly iteration plans](https://github.com/microsoft/vscode/wiki/Iteration-Plans), and our [endgame plans](https://github.com/microsoft/vscode/wiki/Running-the-Endgame). This source code is available to everyone under the standard [MIT license](https://github.com/microsoft/vscode/blob/main/LICENSE.txt).
## Visual Studio Code
<p align="center">
  <img alt="VS Code in action" src="https://user-images.githubusercontent.com/35271042/118224532-3842c400-b438-11eb-923d-a5f66fa6785a.png">
</p>
[Visual Studio Code](https://code.visualstudio.com) is a distribution of the `Code - OSS` repository with Microsoft-specific customizations released under a traditional [Microsoft product license](https://code.visualstudio.com/License/).
[Visual Studio Code](https://code.visualstudio.com) combines the simplicity of a code editor with what developers need for their core edit-build-debug cycle. It provides comprehensive code editing, navigation, and understanding support along with lightweight debugging, a rich extensibility model, and lightweight integration with existing tools.
```
- CONTRIBUTING excerpt:
```text
# Contributing to VS Code
Welcome, and thank you for your interest in contributing to VS Code!
There are several ways in which you can contribute, beyond writing code. The goal of this document is to provide a high-level overview of how you can get involved.
## Asking Questions
Have a question? Instead of opening an issue, please ask on [Stack Overflow](https://stackoverflow.com/questions/tagged/visual-studio-code) using the tag `visual-studio-code`.
The active community will be eager to assist you. Your well-worded question will serve as a resource to others searching for help.
## Providing Feedback
Your comments and feedback are welcome, and the development team is available via a handful of different channels.
See the [Feedback Channels](https://github.com/microsoft/vscode/wiki/Feedback-Channels) wiki page for details on how to share your thoughts.
## Reporting Issues
Have you identified a reproducible problem in VS Code? Do you have a feature request? We want to hear about it! Here's how you can report your issue as effectively as possible.
### Identify Where to Report
```
- Issue template excerpt:
```text
---
name: Bug report
about: Create a report to help us improve
title: ''
labels: ''
assignees: ''
---
<!-- ⚠️⚠️ Do Not Delete This! bug_report_template ⚠️⚠️ -->
<!-- Please read our Rules of Conduct: https://opensource.microsoft.com/codeofconduct/ -->
<!-- 🕮 Read our guide about submitting issues: https://github.com/microsoft/vscode/wiki/Submitting-Bugs-and-Suggestions -->
<!-- 🔎 Search existing issues to avoid creating duplicates. -->
<!-- 🧪 Test using the latest Insiders build to see if your issue has already been fixed: https://code.visualstudio.com/insiders/ -->
```
