You are a research agent with access to the GitHub MCP tool. Your task is to explore open source repositories known for excellent contributor onboarding and developer experience, and produce structured research notes for each one.

## OBJECTIVE
Research the following repositories to help improve Hyperledger Cacti's onboarding, usability, and contributor experience for the LF Decentralized Trust 2026 mentorship application.

## REPOSITORIES TO RESEARCH
1. https://github.com/hyperledger/fabric
2. https://github.com/kubernetes/kubernetes
3. https://github.com/kubernetes/community
4. https://github.com/microsoft/vscode
5. https://github.com/rust-lang/rust
6. https://github.com/freeCodeCamp/freeCodeCamp
7. https://github.com/chaoss/grimoirelab
8. https://github.com/openwallet-foundation/credo-ts
9. https://github.com/hyperledger/cacti  ← this is the TARGET project

## WHAT TO EXTRACT FOR EACH REPO (1–8)
For each repository, use the GitHub MCP to:

1. Fetch and read the following files (if they exist):
   - README.md
   - CONTRIBUTING.md
   - .github/ISSUE_TEMPLATE/ (list all templates)
   - .github/PULL_REQUEST_TEMPLATE.md
   - .github/CODEOWNERS
   - CODE_OF_CONDUCT.md
   - MAINTAINERS.md or GOVERNANCE.md
   - docs/ folder structure (list top-level files only)

2. Check repository metadata:
   - Number of open issues labeled "good first issue"
   - Number of open issues labeled "help wanted"
   - List of active labels used in issues
   - Recent PR merge frequency (last 10 merged PRs)
   - Number of contributors

3. Check CI/CD setup:
   - List workflow files in .github/workflows/
   - Note what checks run on PRs

## OUTPUT FORMAT
Save each repository's findings as a SEPARATE markdown file named:
  - 01_hyperledger_fabric.md
  - 02_kubernetes.md
  - 03_kubernetes_community.md
  - 04_vscode.md
  - 05_rust_lang.md
  - 06_freecodecamp.md
  - 07_grimoirelab.md
  - 08_credo_ts.md
  - 09_cacti_current_state.md  ← audit of target repo

Each file must follow this structure:

---
# [Repo Name] — Onboarding & DX Research

## Repository
- URL:
- Stars:
- Contributors:
- Primary Language:

## Onboarding Files Present
| File | Exists? | Notes |
|------|---------|-------|
| README.md | ✅/❌ | |
| CONTRIBUTING.md | ✅/❌ | |
| ISSUE_TEMPLATE | ✅/❌ | |
| PR_TEMPLATE | ✅/❌ | |
| CODEOWNERS | ✅/❌ | |
| CODE_OF_CONDUCT | ✅/❌ | |
| MAINTAINERS/GOVERNANCE | ✅/❌ | |

## Issue Labels for Contributors
- List all beginner/contributor-facing labels found

## CI/CD Workflows
- List workflow files and their purpose

## Key Onboarding Practices (summary)
Write 3–5 bullet points on what this repo does especially well for new contributors.

## Specific Patterns to Adopt for Cacti
Write 3–5 concrete, actionable recommendations that Cacti could borrow from this project.

## Raw Notes / Interesting Snippets
Paste any notable sections from CONTRIBUTING.md, issue templates, or README that are worth referencing.
---

## FINAL FILE: 00_synthesis.md
After completing all individual files, create a synthesis file named 00_synthesis.md that:

1. Has a summary table comparing all repos across these dimensions:
   - Has CONTRIBUTING.md (Y/N)
   - Has Issue Templates (Y/N)
   - Has PR Template (Y/N)
   - Has CODEOWNERS (Y/N)
   - Has Mentorship Labels (Y/N)
   - Has Dev Setup Guide (Y/N)
   - CI on PRs (Y/N)

2. Lists the TOP 10 practices across all repos that Cacti should adopt, ranked by impact.

3. Includes a "Cacti Gap Analysis" section comparing Cacti's current state (from 09_cacti_current_state.md) against the best practices found.

4. Suggests a phased implementation plan:
   - Phase 1 (Quick wins, <1 week): e.g., labels, templates
   - Phase 2 (Medium effort, 1–4 weeks): e.g., contributor guide rewrite, dev setup guide
   - Phase 3 (Long term, 1–3 months): e.g., mentorship program, architecture guide site

## NOTES FOR THE AGENT
- Use GitHub MCP `get_file_contents` to read individual files
- Use GitHub MCP `search_repositories` or `get_repository` for metadata
- Use GitHub MCP `list_issues` with label filters for "good first issue" counts
- Use GitHub MCP `list_repository_workflows` for CI info
- If a file doesn't exist in a repo, mark it as ❌ and move on — do not fail
- Work through repos one at a time, save each file before moving to the next
- All files should be saved to a folder called: cacti_onboarding_research/