# Workflow Research Progress

## Scope
- Target output folder: `some_example_repos/cacti_onboarding_research/cacti_workflow_research/`
- Target repositories:
  - `hyperledger/fabric`
  - `kubernetes/kubernetes`
  - `microsoft/vscode`
  - `rust-lang/rust`
  - `freeCodeCamp/freeCodeCamp`
  - `chaoss/grimoirelab`
  - `openwallet-foundation/credo-ts`
  - `hyperledger-cacti/cacti`

## Progress Log
- Initialized `cacti_workflow_research/`.
- Used GitHub MCP to inventory `.github/workflows/` for all requested repositories.
- Confirmed `kubernetes/kubernetes` does not currently have a `.github/workflows/` directory in the main repository.
- Cloned the target repositories into `.tmp/` for exhaustive local inspection of workflow files:
  - `.tmp/fabric`
  - `.tmp/kubernetes`
  - `.tmp/vscode`
  - `.tmp/rust`
  - `.tmp/freecodecamp`
  - `.tmp/grimoirelab`
  - `.tmp/credo-ts`
  - `.tmp/cacti-upstream`
- Verified local workflow inventories:
  - Fabric: 5 workflow files
  - Kubernetes: no `.github/workflows/`
  - VS Code: 17 files in `.github/workflows/` plus one shell helper file in that directory
  - Rust: 4 workflow files
  - freeCodeCamp: 21 workflow files
  - GrimoireLab: 4 workflow files
  - Credo TS: 6 workflow files
  - Cacti upstream: 68 workflow files

## Current State
- Repository inventories are complete.
- Upstream Cacti clone is ready and will be used instead of the local worktree so the report matches GitHub rather than local uncommitted changes.
- Created a local virtualenv at `.tmp/venv` and installed `PyYAML` for structured workflow parsing.
- Wrote `analyze_workflows.py` to extract triggers, trigger conditions, jobs, key steps, secrets/env references, contributor visibility, estimated runtime, and merge-impact heuristics from each workflow YAML file.
- Generated the final output set in `cacti_workflow_research/`:
  - `wf_00_synthesis.md`
  - `wf_01_hyperledger_fabric.md`
  - `wf_02_kubernetes.md`
  - `wf_03_vscode.md`
  - `wf_04_rust.md`
  - `wf_05_freecodecamp.md`
  - `wf_06_grimoirelab.md`
  - `wf_07_credo_ts.md`
  - `wf_08_cacti.md`

## Notes / Caveats
- The workflow inventories are based on the upstream repository state in the local shallow clones, cross-checked against the earlier GitHub MCP directory inventories.
- `kubernetes/kubernetes` currently has no `.github/workflows/` directory in the main repository clone.
- `Blocks PR merge` and parts of `Contributor visible` are inferred from trigger type and secret usage in YAML. Actual branch protection rules and org-level restrictions are not encoded in the workflow files themselves.
