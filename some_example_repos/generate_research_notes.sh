#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT_DIR="$ROOT_DIR/cacti_onboarding_research"
DATA_FILE="$OUT_DIR/research_data.json"

mark_exists() {
  if [[ -n "${1:-}" ]]; then
    printf '✅'
  else
    printf '❌'
  fi
}

notes_for_row() {
  local label="$1"
  local value="$2"
  if [[ -n "$value" ]]; then
    printf '%s' "$value"
  else
    printf 'Not found'
  fi
}

normalize_list() {
  local raw="${1:-}"
  if [[ -z "$raw" ]]; then
    printf ''
    return
  fi
  printf '%s\n' "$raw" \
    | tr ',' '\n' \
    | sed 's/^ *//; s/ *$//' \
    | awk 'NF' \
    | paste -sd ', ' -
}

key_practices() {
  case "$1" in
    01) cat <<'EOF'
- Puts the contributor guide in a visible top-level location and links to deeper docs rather than overloading the README.
- Uses issue forms for bugs, features, and work items, which improves triage quality from the first interaction.
- Publishes maintainer ownership and a code of conduct in-repo, so community expectations are easy to find.
- Shows quality and security signals prominently in the README, including build status and scorecard badges.
EOF
      ;;
    02) cat <<'EOF'
- Splits project onboarding cleanly between the code repo and the community repo, keeping the contribution path focused.
- Maintains a strong taxonomy of contributor-facing labels, especially `help wanted`, so there is visible work for newcomers.
- Uses structured issue forms for bug reports, enhancements, and flaky tests to route issues to the right maintainers faster.
- Keeps PR throughput high, which reduces the risk that first-time contributors wait too long for feedback.
EOF
      ;;
    03) cat <<'EOF'
- Treats community operations as a first-class repository with dedicated templates for requests, elections, moderation, and surveys.
- Makes mentorship visible in the contributing guide instead of treating it as a side program.
- Documents governance and communication channels up front, which lowers the social barrier to entry.
- Uses labels tied to contributor experience and community areas, not only technical components.
EOF
      ;;
    04) cat <<'EOF'
- The contributing guide steers users to the correct support channel before they file issues, reducing maintainers' triage load.
- The repo has dedicated PR workflows for different operating systems and test categories, making CI intent easy to understand.
- Issue templates are backed by contributor education in the wiki, so people learn how to report issues well.
- Ownership is explicit through CODEOWNERS and a large set of PR-specific workflows.
EOF
      ;;
    05) cat <<'EOF'
- Directs new contributors to a dedicated newcomer chat stream instead of forcing them to self-serve immediately.
- Separates different contribution domains with tailored issue templates, such as bootstrap, diagnostics, docs, and regressions.
- Keeps the compiler project linked to specialized external guides, which is more scalable than a single oversized CONTRIBUTING file.
- CI and merge flow are explicit and fast-moving, which matters for a project with a very large review surface.
EOF
      ;;
    06) cat <<'EOF'
- Signals newcomer friendliness directly in the README and issue taxonomy.
- Uses issue forms scoped to product area, which helps contributors understand where to report problems.
- PR workflows include contributor-guidance automation, not just tests, which improves submission quality.
- Keeps a visible CODEOWNERS file and very active `help wanted` inventory for external contributors.
EOF
      ;;
    07) cat <<'EOF'
- The README includes a real "getting started" path instead of only a conceptual overview.
- CONTRIBUTING explicitly welcomes non-code work such as support, docs, and analytics-related improvements.
- Maintainers are published, which helps newcomers identify where decisions live.
- The repo keeps release automation separated from contributor onboarding, which makes expectations easier to follow.
EOF
      ;;
    08) cat <<'EOF'
- CONTRIBUTING is short, practical, and explicit about how to propose large changes before coding them.
- Maintainer ownership is visible through both CODEOWNERS and a dedicated maintainers document.
- The checklist in CONTRIBUTING helps reviewers and contributors converge on smaller, more frequent changes.
- CI is comparatively compact and easier for a new contributor to understand than many larger platform repos.
EOF
      ;;
    09) cat <<'EOF'
- Cacti already has many of the structural ingredients: CONTRIBUTING, issue templates, PR template, CODEOWNERS, code of conduct, and maintainers.
- The docs surface is broad, and the README clearly explains project scope and current cleanup efforts.
- CI coverage is extensive and shows strong engineering rigor across packages, connectors, publish flows, and security scans.
- The repo uses `help wanted`, but beginner-targeted issue discovery is still much weaker than the strongest comparison repos.
EOF
      ;;
    10) cat <<'EOF'
- Hiero positions this repository as the project entrypoint, which is a strong onboarding choice for a multi-repo ecosystem.
- The repository's value is organizational clarity: non-technical definitions, project context, and central navigation live in one place.
- The repo uses labels like `Good First Issue Candidate`, `learning`, `Non-Code`, and `volunteer`, which signals contributor intent even though formal scaffolding is light.
- As an entry repo, it lowers the chance that newcomers start in a deep subsystem before they understand the project structure.
EOF
      ;;
  esac
}

adopt_patterns() {
  case "$1" in
    01) cat <<'EOF'
- Mirror Fabric's split between a concise root CONTRIBUTING guide and deeper task-specific docs under `docs/`.
- Add a dedicated work-item issue form so design, refactor, and project-cleanup proposals are structured before implementation starts.
- Surface project quality signals in one contributor-facing dashboard page instead of scattering them across badges and workflows.
- Make maintainer ownership easier to navigate by pairing CODEOWNERS with a human-readable maintainer map.
EOF
      ;;
    02) cat <<'EOF'
- Borrow Kubernetes' stronger contributor label strategy by expanding beyond `help wanted` into `good first issue`, area labels, and triage-ready starter work.
- Separate "code repo" onboarding from "community repo" onboarding so contributors know where to go for process versus implementation details.
- Publish a contributor guide page that maps common tasks to maintainers, SIG-style groups, or subsystem owners.
- Keep issue forms narrowly scoped by problem type to reduce vague or misrouted reports.
EOF
      ;;
    03) cat <<'EOF'
- Create contributor-experience or mentorship-specific labels and documentation, not only technical backlog labels.
- Add lightweight templates for community requests such as mentorship, release support, docs help, or meeting-note updates.
- Document communication channels and project governance more prominently from the main repository.
- Publish an explicit pathway for non-code contributions like docs, testing, ecosystem examples, and community operations.
EOF
      ;;
    04) cat <<'EOF'
- Add a "where to ask vs where to file" section near the top of CONTRIBUTING to keep issues focused.
- Break CI communication down into a short contributor guide that explains which workflows matter for a typical PR.
- Use targeted PR workflows and naming conventions that make failures easier for first-time contributors to interpret.
- Maintain a living roadmap or iteration-plan page so contributors can align work with active priorities.
EOF
      ;;
    05) cat <<'EOF'
- Introduce a newcomer support channel or office-hours path similar to Rust's new-members stream.
- Split complex contribution areas into dedicated guides, for example connectors, examples, SATP/Weaver, docs, and release work.
- Provide role-specific issue forms for regressions, documentation, and subsystem-specific defects.
- Encourage smaller, reviewable changes with explicit guidance on how to scope PRs and when to discuss design first.
EOF
      ;;
    06) cat <<'EOF'
- Put an explicit newcomer-friendly badge or callout in the README so the project signals approachability immediately.
- Expand label automation and PR guidance checks to coach contributors before maintainers have to review manually.
- Create issue forms that map directly to docs, examples, curriculum-style tutorials, and product areas.
- Treat contributor education as part of CI by validating PR conventions and required metadata automatically.
EOF
      ;;
    07) cat <<'EOF'
- Build a true quick-start path for running a minimal local development setup, similar to GrimoireLab's default setup messaging.
- Emphasize non-code contribution paths in CONTRIBUTING so newcomers without deep blockchain expertise can still contribute.
- Publish a simplified "first successful contribution" path focused on docs, examples, or test improvements.
- Pair maintainer listings with a practical "who reviews what" reference for common onboarding tasks.
EOF
      ;;
    08) cat <<'EOF'
- Tighten CONTRIBUTING into a shorter entry path with a clear pre-PR checklist and escalation path for large changes.
- Encourage issue-first discussion for major architectural work to reduce rework across complex subsystems.
- Keep release cadence guidance visible so contributors understand how small, incremental PRs are preferred.
- Preserve a smaller, comprehensible CI surface for common contributor workflows even if the full release matrix remains large.
EOF
      ;;
    09) cat <<'EOF'
- Add a real `good first issue` program with triaged starter issues and a documented SLA for first response.
- Create a concise "start here" guide that sits above the current long-form CONTRIBUTING content and points to the right subsystem docs.
- Distill the very large workflow inventory into a contributor-facing CI map: what runs on normal PRs, what is optional, and what only maintainers need.
- Introduce mentorship-oriented labels and newcomer-safe issue templates tied to docs, tests, examples, and cleanup work.
EOF
      ;;
    10) cat <<'EOF'
- Borrow Hiero's entrypoint-repo pattern by keeping one clear landing place for project-wide onboarding, governance, and repository map content.
- Add a top-level ecosystem map for Cacti that explains which repos or subsystems a newcomer should approach first.
- Treat non-technical onboarding documents as first-class project artifacts instead of scattering them across technical docs.
- Use the entry repo to direct contributors toward starter issues in the right downstream modules.
EOF
      ;;
  esac
}

raw_note_intro() {
  case "$1" in
    09) printf '%s\n' '- Note: the repo listed in `tasks.md` as `hyperledger/cacti` is now `hyperledger-cacti/cacti`; the audit used the live repository.' ;;
    10) printf '' ;;
    *) printf '' ;;
  esac
}

ci_summary() {
  case "$1" in
    01) printf '%s\n' '- Notable workflows: `verify-build.yml`, `vulnerability-scan.yml`, `broken-link-checker.yml`, `scorecard.yml`, `release.yml`.' '- PR coverage: build verification, link checking, and security-oriented checks are visible from the workflow set.' ;;
    02) printf '%s\n' '- Notable workflows were not present under `.github/workflows/` in the root repo snapshot gathered here.' '- PR coverage still appears strong from overall merge velocity and project process, but workflow definitions may live elsewhere or be generated differently.' ;;
    03) printf '%s\n' '- No root `.github/workflows/` inventory was found in the snapshot gathered here.' '- The repo is more focused on process and community operations than code-heavy CI.' ;;
    04) printf '%s\n' '- Notable workflows: `pr.yml`, `pr-linux-test.yml`, `pr-darwin-test.yml`, `pr-win32-test.yml`, `pr-linux-cli-test.yml`, `screenshot-test.yml`, `component-fixture-tests.yml`.' '- PR coverage: multi-platform testing, screenshot validation, component fixtures, and proposal/version checks.' ;;
    05) printf '%s\n' '- Notable workflows: `ci.yml`, `post-merge.yml`, `dependencies.yml`, `ghcr.yml`.' '- PR coverage: compiler CI runs on pull requests, with additional post-merge and dependency maintenance workflows.' ;;
    06) printf '%s\n' '- Notable workflows: `node.js-tests.yml`, `e2e-playwright.yml`, `devcontainer-ci.yml`, `github-pr-guidelines.yml`, `i18n-validate-prs.yml`.' '- PR coverage: tests, end-to-end validation, contributor guideline checks, and i18n validation.' ;;
    07) printf '%s\n' '- Notable workflows: `release.yml`, `docker-image.yml`, `grimoirelab-release.yml`, `release-grimoirelab-component.yml`.' '- PR coverage is less visible than release automation; contributor onboarding depends more on docs than on PR-specific workflow signaling.' ;;
    08) printf '%s\n' '- Notable workflows: `continuous-integration.yml`, `lint-pr.yml`, `repolinter.yml`, `scorecard.yml`, `release.yml`.' '- PR coverage: core CI and PR linting are easy to identify from the workflow names.' ;;
    09) printf '%s\n' '- Notable workflows: `checks-and-build.yaml`, `ci.yaml`, `code-quality-checks.yaml`, `coverage_ts.yaml`, `codeql-analysis.yml`, `semantic-pull-request.yaml`, plus many package and connector-specific workflows.' '- PR coverage: broad build, quality, security, coverage, semantic PR, and subsystem-specific validation, but the workflow surface is large for newcomers.' ;;
    10) printf '%s\n' '- No root `.github/workflows/` inventory was found in the snapshot gathered here.' '- PR automation is minimal or absent in this entrypoint repo, which keeps it simple but also means less contributor guidance is encoded in CI.' ;;
  esac
}

while IFS= read -r idx; do
  item="$(jq ".[] | select(.idx == \"$idx\")" "$DATA_FILE")"
  display_name="$(jq -r '.display_name' <<<"$item")"
  out_file="$(jq -r '.out_file' <<<"$item")"
  repo_url="$(jq -r '.repo_url' <<<"$item")"
  stars="$(jq -r '.stars' <<<"$item")"
  contributors="$(jq -r '.contributors' <<<"$item")"
  language="$(jq -r '.language' <<<"$item")"
  readme_path="$(jq -r '.paths.readme' <<<"$item")"
  contributing_path="$(jq -r '.paths.contributing' <<<"$item")"
  issue_templates="$(jq -r '.paths.issue_templates' <<<"$item")"
  pr_template_path="$(jq -r '.paths.pr_template' <<<"$item")"
  codeowners_path="$(jq -r '.paths.codeowners' <<<"$item")"
  coc_path="$(jq -r '.paths.code_of_conduct' <<<"$item")"
  governance_path="$(jq -r '.paths.governance' <<<"$item")"
  docs_entries="$(jq -r '.docs_entries' <<<"$item")"
  beginner_labels="$(jq -r '.beginner_labels' <<<"$item")"
  all_labels_sample="$(jq -r '.all_labels_sample' <<<"$item")"
  good_first_count="$(jq -r '.good_first_count' <<<"$item")"
  help_wanted_count="$(jq -r '.help_wanted_count' <<<"$item")"
  merged_span="$(jq -r '.merged_span' <<<"$item")"
  readme_excerpt="$(jq -r '.excerpts.readme' <<<"$item")"
  contributing_excerpt="$(jq -r '.excerpts.contributing' <<<"$item")"
  issue_excerpt="$(jq -r '.excerpts.issue_template' <<<"$item")"

  issue_templates="$(normalize_list "$issue_templates")"
  docs_entries="$(normalize_list "$docs_entries")"

  cat >"$OUT_DIR/$out_file" <<EOF
# $display_name — Onboarding & DX Research

## Repository
- URL: $repo_url
- Stars: $stars
- Contributors: $contributors
- Primary Language: $language

## Onboarding Files Present
| File | Exists? | Notes |
|------|---------|-------|
| README.md | $(mark_exists "$readme_path") | $(notes_for_row "README" "$readme_path") |
| CONTRIBUTING.md | $(mark_exists "$contributing_path") | $(notes_for_row "CONTRIBUTING" "$contributing_path") |
| ISSUE_TEMPLATE | $(mark_exists "$issue_templates") | $(notes_for_row "ISSUE_TEMPLATE" "$issue_templates") |
| PR_TEMPLATE | $(mark_exists "$pr_template_path") | $(notes_for_row "PR_TEMPLATE" "$pr_template_path") |
| CODEOWNERS | $(mark_exists "$codeowners_path") | $(notes_for_row "CODEOWNERS" "$codeowners_path") |
| CODE_OF_CONDUCT | $(mark_exists "$coc_path") | $(notes_for_row "CODE_OF_CONDUCT" "$coc_path") |
| MAINTAINERS/GOVERNANCE | $(mark_exists "$governance_path") | $(notes_for_row "MAINTAINERS/GOVERNANCE" "$governance_path") |

## Issue Labels for Contributors
- Open issues labeled \`good first issue\`: $good_first_count
- Open issues labeled \`help wanted\`: $help_wanted_count
- Beginner/contributor-facing labels found: ${beginner_labels:-None found}
- Sample active labels in the repo: ${all_labels_sample:-No label sample captured}

## CI/CD Workflows
$(ci_summary "$idx")
- Recent merged PR span for the last 10 merged PRs: $merged_span

## Key Onboarding Practices (summary)
$(key_practices "$idx")

## Specific Patterns to Adopt for Cacti
$(adopt_patterns "$idx")

## Raw Notes / Interesting Snippets
$(raw_note_intro "$idx")
- Top-level docs folder snapshot: ${docs_entries:-No top-level \`docs/\` folder found}
- README excerpt:
\`\`\`text
$readme_excerpt
\`\`\`
- CONTRIBUTING excerpt:
\`\`\`text
$contributing_excerpt
\`\`\`
- Issue template excerpt:
\`\`\`text
$issue_excerpt
\`\`\`
EOF
done < <(jq -r '.[].idx' "$DATA_FILE")

cat >"$OUT_DIR/00_synthesis.md" <<'EOF'
# Cross-Repo Synthesis — Cacti Onboarding & DX Research

## Comparison Table
| Repository | CONTRIBUTING.md | Issue Templates | PR Template | CODEOWNERS | Mentorship Labels | Dev Setup Guide | CI on PRs |
|------------|-----------------|----------------|-------------|------------|-------------------|-----------------|-----------|
| Hyperledger Fabric | Y | Y | Y | Y | Y | Y | Y |
| Kubernetes | Y | Y | Y | N | Y | Y | Unclear from root snapshot |
| Kubernetes Community | Y | Y | Y | N | Y | Y | N/A or minimal |
| Visual Studio Code | Y | Y | Y | Y | Y | Y | Y |
| Rust | Y | Y | Y | N | N | Y | Y |
| freeCodeCamp | N | Y | Y | Y | Y | Partial | Y |
| CHAOSS GrimoireLab | Y | N | N | N | Y | Y | Limited |
| Credo TS | Y | N | N | Y | Y | Partial | Y |
| Hyperledger Cacti | Y | Y | Y | Y | Partial | Y | Y |
| Hiero | N | N | N | N | Y | N | N |

## Top 10 Practices Cacti Should Adopt
1. Launch a real `good first issue` program with curated, actively maintained starter tasks.
2. Add a short "start here" contributor path above the current long-form CONTRIBUTING guide.
3. Publish a contributor-facing CI map that explains which workflows matter for a normal PR.
4. Create subsystem-specific onboarding guides for connectors, examples, core packages, docs, and Weaver/SATP work.
5. Make mentorship and newcomer support explicit through labels, docs, and a human support channel or office hours.
6. Separate support questions from bug reports with a clear "where to ask vs where to file" section.
7. Expand non-code contribution paths so docs, tests, examples, and cleanup work are visible and intentionally welcomed.
8. Add more structured issue forms for docs gaps, regressions, cleanup, and contributor-task proposals.
9. Pair CODEOWNERS with a human-readable maintainer/subsystem map so newcomers know who reviews what.
10. Use automation to coach PR quality early, including semantic PR checks, checklists, and contributor guidance.

## Cacti Gap Analysis
- Cacti already compares well on structural hygiene: it has a README, CONTRIBUTING guide, issue templates, PR template, CODEOWNERS, code of conduct, maintainers list, and extensive CI.
- The main gap is discoverability. Repos like VS Code, Fabric, Rust, and Kubernetes make the first contributor journey easier to navigate with a shorter entry path, clearer routing, or stronger social/community guidance.
- Cacti has `help wanted`, but unlike Kubernetes, VS Code, Fabric, and Credo TS, it does not currently expose a strong newcomer funnel centered on `good first issue` work.
- Cacti's workflow surface is much larger than any repo in this comparison set. That is good for rigor, but it raises cognitive load for first-time contributors unless the workflows are explained.
- Community-facing repositories such as `kubernetes/community` show that mentorship, communications, and governance should be treated as onboarding artifacts, not only project-administration material.
- freeCodeCamp demonstrates that contributor coaching can be automated. Cacti has many checks, but not enough visible newcomer-oriented guidance around those checks.
- Hiero reinforces the value of a dedicated project entrypoint for multi-repo ecosystems; Cacti would benefit from a similarly explicit ecosystem map.

## Phased Implementation Plan
### Phase 1 (Quick wins, under 1 week)
- Add and triage a `good first issue` label with 10 to 20 genuinely newcomer-safe issues.
- Add a short "start here" section at the top of `CONTRIBUTING.md`.
- Add a "where to ask questions" section to steer support traffic away from the issue tracker.
- Create a contributor-facing index page that links to docs, maintainer ownership, and common tasks.

### Phase 2 (Medium effort, 1 to 4 weeks)
- Split the current contributor documentation into focused guides by subsystem and contribution type.
- Add issue forms for docs, regressions, cleanup tasks, and contributor work proposals.
- Publish a CI guide that explains normal PR checks, optional checks, and maintainer-only release flows.
- Add a maintainer/subsystem map that complements CODEOWNERS with plain-language ownership.

### Phase 3 (Long term, 1 to 3 months)
- Establish a lightweight mentorship or newcomer office-hours program.
- Build architecture and developer setup material into a dedicated docs site path optimized for first contributions.
- Track onboarding health with metrics such as first-response time, time-to-first-merge, and stale `good first issue` counts.
- Create a standing backlog of docs/tests/examples tasks that can absorb new contributors without requiring deep domain context.
EOF

printf 'Generated markdown files in %s\n' "$OUT_DIR"
