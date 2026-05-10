# Kubernetes Community — Onboarding & DX Research

## Repository
- URL: https://github.com/kubernetes/community
- Stars: 12846
- Contributors: 1786
- Primary Language: Jupyter Notebook

## Onboarding Files Present
| File | Exists? | Notes |
|------|---------|-------|
| README.md | ✅ | README.md |
| CONTRIBUTING.md | ✅ | CONTRIBUTING.md |
| ISSUE_TEMPLATE | ✅ | comms-request.yaml,config.yml election-request.yml general-issue.yml leadership-change.yml,moderator_application.yml slack-request.yml survey-request.yml |
| PR_TEMPLATE | ✅ | .github/PULL_REQUEST_TEMPLATE.md |
| CODEOWNERS | ❌ | Not found |
| CODE_OF_CONDUCT | ❌ | Not found |
| MAINTAINERS/GOVERNANCE | ❌ | Not found |

## Issue Labels for Contributors
- Open issues labeled `good first issue`: 0
- Open issues labeled `help wanted`: 11
- Beginner/contributor-facing labels found: area/mentorship-planning
- Sample active labels in the repo: ¯\_(ツ)_/¯, api-review, approved, area/admin, area/admission-control, area/annual-reports, area/api, area/apiserver, area/app-lifecycle, area/batch, area/build-release, area/cadvisor, area/client-libraries, area/cloudprovider, area/cn-summit, area/code-organization, area/community-management, area/community-meeting, area/configmap-api, area/conformance, area/contributor-comms, area/contributor-guide, area/contributor-summit, area/controller-manager, area/declarative-configuration

## CI/CD Workflows
- No root `.github/workflows/` inventory was found in the snapshot gathered here.
- The repo is more focused on process and community operations than code-heavy CI.
- Recent merged PR span for the last 10 merged PRs: 2026-04-23T09:30:46Z to 2026-04-30T18:47:25Z

## Key Onboarding Practices (summary)
- Treats community operations as a first-class repository with dedicated templates for requests, elections, moderation, and surveys.
- Makes mentorship visible in the contributing guide instead of treating it as a side program.
- Documents governance and communication channels up front, which lowers the social barrier to entry.
- Uses labels tied to contributor experience and community areas, not only technical components.

## Specific Patterns to Adopt for Cacti
- Create contributor-experience or mentorship-specific labels and documentation, not only technical backlog labels.
- Add lightweight templates for community requests such as mentorship, release support, docs help, or meeting-note updates.
- Document communication channels and project governance more prominently from the main repository.
- Publish an explicit pathway for non-code contributions like docs, testing, ecosystem examples, and community operations.

## Raw Notes / Interesting Snippets

- Top-level docs folder snapshot: No top-level `docs/` folder found
- README excerpt:
```text
# Kubernetes Community
Welcome to the Kubernetes community!
This is the starting point for joining and contributing to the Kubernetes community - improving docs, improving code, giving talks etc.
To learn more about the project structure and organization, please refer to [Project Governance] information.
## Communicating
The [communication](communication/) page lists communication channels like chat,
issues, mailing lists, conferences, etc.
For more specific topics, try a SIG.
## Governance
Kubernetes has the following types of groups that are officially supported:
* **Committees** are named sets of people that are chartered to take on sensitive topics.
  This group is encouraged to be as open as possible while achieving its mission but, because of the nature of the topics discussed, private communications are allowed.
```
- CONTRIBUTING excerpt:
```text
# Contributing to the Community Repo
Welcome to the Kubernetes Community contributing guide. We are excited about the prospect of you joining our [community](https://github.com/kubernetes/community)!
## Getting Started
We have full documentation on how to get started contributing here:
- [Kubernetes Contributor Guide](https://www.kubernetes.dev/docs/guide/) - Main contributor documentation
- [Contributor Cheat Sheet](https://www.kubernetes.dev/docs/contributor-cheatsheet/) - Common resources for existing developers
## Mentorship
- [Mentoring Initiatives](https://git.k8s.io/community/mentoring)  - We have a diverse set of mentorship programs available that are always looking for volunteers!
## Contributing to Individual SIGs
Each SIG may or may not have its own policies for editing their section of this repository.
Edits in SIG sub-directories should follow any additional guidelines described
by the respective SIG leads in the sub-directory's `CONTRIBUTING` file
```
- Issue template excerpt:
```text
name: Contributor Comms Request
description: Get support on sending a message out to our community through coordinated outreach on email, Slack, social media, and other public channels.
title: 'REQUEST: New communication about <topic>'
labels: area/contributor-comms, sig/contributor-experience
body:
  - type: textarea
    id: content
    attributes:
      label: What do you want to send out? (Please include a link to any information or a draft)
      description: Gists, Hackmd.io, or Google Doc preferred. Include any artwork, pics, diagrams, or any other assets with public links.
    validations:
      required: true
```
