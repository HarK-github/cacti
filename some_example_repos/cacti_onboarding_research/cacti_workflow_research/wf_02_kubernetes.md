# Kubernetes — Workflow Analysis

## Workflow Inventory
| File | Category | Trigger | Blocks PR? |
|------|----------|---------|------------|
| _No `.github/workflows/` directory_ | INFRA | none | No |

## Workflow Details

This repository does not currently keep GitHub Actions workflow files under `.github/workflows/`. For contributors, CI and automation are handled elsewhere in the project infrastructure.

## Contributor Summary

A new contributor should not expect standard GitHub Actions checks from the main repository because there are no workflow YAML files in `.github/workflows/`. CI for Kubernetes is largely orchestrated through external infrastructure and repository-integrated bots rather than local workflow files. That means a contributor should focus on the documented project-specific presubmit instructions and the PR bot feedback instead of looking for Actions tabs as the primary source of truth. Maintainer-triggered or infrastructure-owned checks may still run against pull requests, but they are not defined here. Before pushing, contributors still need to follow the repository’s documented build, test, and lint commands locally. Workflow failures inside GitHub Actions are not the main concern in this repo because the usual Actions surface is absent. The contributor experience implication is that CI behavior is less discoverable from the repository alone than in the other repos in this study.

## Red Flags / Observations

- CI discoverability is weaker than the other repositories because the main repo does not expose workflow definitions under `.github/workflows/`.
- New contributors have to learn external CI conventions instead of reading self-documenting workflow YAML in-repo.
- This is the opposite of the explicit, contributor-readable pattern that would help Hyperledger Cacti.
