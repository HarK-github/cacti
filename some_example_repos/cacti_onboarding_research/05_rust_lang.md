# Rust — Onboarding & DX Research

## Repository
- URL: https://github.com/rust-lang/rust
- Stars: 112498
- Contributors: 8397
- Primary Language: Rust

## Onboarding Files Present
| File | Exists? | Notes |
|------|---------|-------|
| README.md | ✅ | README.md |
| CONTRIBUTING.md | ✅ | CONTRIBUTING.md |
| ISSUE_TEMPLATE | ✅ | bootstrap.md,bug_report.md config.yml diagnostics.yaml documentation.yaml,ice.md ice.yaml library_tracking_issue.md regression.md,rustdoc.md tracking_issue.md tracking_issue_future.md |
| PR_TEMPLATE | ✅ | .github/pull_request_template.md |
| CODEOWNERS | ❌ | Not found |
| CODE_OF_CONDUCT | ✅ | CODE_OF_CONDUCT.md |
| MAINTAINERS/GOVERNANCE | ❌ | Not found |

## Issue Labels for Contributors
- Open issues labeled `good first issue`: 0
- Open issues labeled `help wanted`: 0
- Beginner/contributor-facing labels found: None found
- Sample active labels in the repo: -Clink-dead-code, -Cprefer-dynamic, -Zbuild-std, -Zcrate-attr, -Zdebuginfo-compression, -Zdump-mir, -Zdwarf-version, -Zembed-source, -Zfixed-x18, -Zfmt-debug, -Zhint-mostly-unused, -Zindirect-branch-cs-prefix, -Zinline-mir, -Zllvm-plugins, -Zmetrics-dir, -Zno-link, -Znormalize-docs, -Zpolymorphize, -Zrandomize-layout, -Zreg-struct-return, -Zregparm, -Zshare-generics, -Zterminal-urls, -Zthir-unsafeck, -Ztrace-macros

## CI/CD Workflows
- Notable workflows: `ci.yml`, `post-merge.yml`, `dependencies.yml`, `ghcr.yml`.
- PR coverage: compiler CI runs on pull requests, with additional post-merge and dependency maintenance workflows.
- Recent merged PR span for the last 10 merged PRs: 2026-05-03T09:52:26Z to 2026-05-03T17:53:42Z

## Key Onboarding Practices (summary)
- Directs new contributors to a dedicated newcomer chat stream instead of forcing them to self-serve immediately.
- Separates different contribution domains with tailored issue templates, such as bootstrap, diagnostics, docs, and regressions.
- Keeps the compiler project linked to specialized external guides, which is more scalable than a single oversized CONTRIBUTING file.
- CI and merge flow are explicit and fast-moving, which matters for a project with a very large review surface.

## Specific Patterns to Adopt for Cacti
- Introduce a newcomer support channel or office-hours path similar to Rust's new-members stream.
- Split complex contribution areas into dedicated guides, for example connectors, examples, SATP/Weaver, docs, and release work.
- Provide role-specific issue forms for regressions, documentation, and subsystem-specific defects.
- Encourage smaller, reviewable changes with explicit guidance on how to scope PRs and when to discuss design first.

## Raw Notes / Interesting Snippets

- Top-level docs folder snapshot: No top-level `docs/` folder found
- README excerpt:
```text
<div align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/rust-lang/www.rust-lang.org/master/static/images/rust-social-wide-dark.svg">
    <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/rust-lang/www.rust-lang.org/master/static/images/rust-social-wide-light.svg">
    <img alt="The Rust Programming Language: A language empowering everyone to build reliable and efficient software"
         src="https://raw.githubusercontent.com/rust-lang/www.rust-lang.org/master/static/images/rust-social-wide-light.svg"
         width="50%">
  </picture>
[Website][Rust] | [Getting started] | [Learn] | [Documentation] | [Contributing]
</div>
This is the main source code repository for [Rust]. It contains the compiler,
standard library, and documentation.
```
- CONTRIBUTING excerpt:
```text
# Contributing to Rust
Thank you for your interest in contributing to Rust! There are many ways to contribute
and we appreciate all of them.
The best way to get started is by asking for help in the [#new
members](https://rust-lang.zulipchat.com/#narrow/stream/122652-new-members)
Zulip stream. We have a lot of documentation below on how to get started on your own, but
the Zulip stream is the best place to *ask* for help.
Documentation for contributing to the compiler or tooling is located in the [Guide to Rustc
Development][rustc-dev-guide], commonly known as the [rustc-dev-guide]. Documentation for the
standard library is in the [Standard library developers Guide][std-dev-guide], commonly known as the [std-dev-guide].
## Making changes to subtrees and submodules
For submodules, changes need to be made against the repository corresponding to the
```
- Issue template excerpt:
```text
---
name: Bootstrap (Rust Build System) Report
about: Issues encountered on bootstrap build system
labels: C-bug, T-bootstrap
---
<!--
Thank you for submitting a bootstrap report! Please provide detailed information to help us reproduce and diagnose the issue.
-->
### Summary
<!--
Provide a brief description of the problem you are experiencing.
-->
```
