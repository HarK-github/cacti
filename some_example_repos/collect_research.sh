#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT_DIR="$ROOT_DIR/cacti_onboarding_research"
TMP_DIR="$OUT_DIR/.tmp"
mkdir -p "$OUT_DIR" "$TMP_DIR"
FILTER_IDX="${1:-}"

repos=(
  "01|hyperledger/fabric|Hyperledger Fabric|01_hyperledger_fabric.md"
  "02|kubernetes/kubernetes|Kubernetes|02_kubernetes.md"
  "03|kubernetes/community|Kubernetes Community|03_kubernetes_community.md"
  "04|microsoft/vscode|Visual Studio Code|04_vscode.md"
  "05|rust-lang/rust|Rust|05_rust_lang.md"
  "06|freeCodeCamp/freeCodeCamp|freeCodeCamp|06_freecodecamp.md"
  "07|chaoss/grimoirelab|CHAOSS GrimoireLab|07_grimoirelab.md"
  "08|openwallet-foundation/credo-ts|Credo TS|08_credo_ts.md"
  "09|hyperledger-cacti/cacti|Hyperledger Cacti|09_cacti_current_state.md"
  "10|hiero-ledger/hiero|Hiero|10_hiero.md"
)

gh_api() {
  gh api -H "Accept: application/vnd.github+json" "$@"
}

json_escape() {
  jq -Rs .
}

decode_content() {
  jq -r '.content // empty' | tr -d '\n' | base64 -d 2>/dev/null || true
}

fetch_to_file() {
  local endpoint="$1"
  local outfile="$2"
  if gh_api "$endpoint" >"$outfile" 2>/dev/null; then
    return 0
  fi
  return 1
}

path_exists() {
  local repo="$1"
  local path="$2"
  gh_api "repos/$repo/contents/$path" >/dev/null 2>&1
}

get_first_existing_file() {
  local repo="$1"
  shift
  local path
  for path in "$@"; do
    if path_exists "$repo" "$path"; then
      printf '%s\n' "$path"
      return 0
    fi
  done
  return 1
}

list_dir_names() {
  local repo="$1"
  local path="$2"
  local outfile="$TMP_DIR/dir.json"
  if fetch_to_file "repos/$repo/contents/$path" "$outfile"; then
    jq -r '.[].name' "$outfile"
  fi
}

get_text_excerpt() {
  local repo="$1"
  local path="$2"
  local outfile="$TMP_DIR/file.json"
  if fetch_to_file "repos/$repo/contents/$path" "$outfile"; then
    decode_content <"$outfile" \
      | sed 's/\r$//' \
      | awk 'NF {print}' \
      | head -n 12
  fi
}

search_count() {
  local q="$1"
  gh_api "search/issues?q=$(printf '%s' "$q" | jq -sRr @uri)&per_page=1" | jq -r '.total_count // 0'
}

get_contributor_count() {
  local repo="$1"
  local headers
  headers="$(gh api -i "repos/$repo/contributors?per_page=1&anon=1" 2>/dev/null || true)"
  local last
  last="$(printf '%s\n' "$headers" | grep -i '^link:' | grep -o 'page=[0-9]*>; rel="last"' | grep -o '[0-9]*' | tail -n1 || true)"
  if [[ -n "$last" ]]; then
    printf '%s\n' "$last"
    return
  fi
  if printf '%s\n' "$headers" | grep -q '^\['; then
    printf '1\n'
    return
  fi
  printf '0\n'
}

write_json_summary() {
  local file="$1"
  shift
  jq -n "$@" >"$file"
}

for entry in "${repos[@]}"; do
  IFS='|' read -r idx repo display_name out_file <<<"$entry"
  if [[ -n "$FILTER_IDX" && "$idx" != "$FILTER_IDX" ]]; then
    continue
  fi
  owner="${repo%%/*}"
  name="${repo##*/}"
  summary_json="$TMP_DIR/${idx}_${name}_summary.json"

  repo_json="$TMP_DIR/${idx}_${name}_repo.json"
  gh_api "repos/$repo" >"$repo_json"

  stars="$(jq -r '.stargazers_count // 0' "$repo_json")"
  language="$(jq -r '.language // "Unknown"' "$repo_json")"
  default_branch="$(jq -r '.default_branch // "main"' "$repo_json")"
  repo_url="$(jq -r '.html_url' "$repo_json")"
  description="$(jq -r '.description // ""' "$repo_json")"

  contributor_count="$(get_contributor_count "$repo")"

  readme_path="$(get_first_existing_file "$repo" README.md readme.md README.rst README || true)"
  contributing_path="$(get_first_existing_file "$repo" CONTRIBUTING.md .github/CONTRIBUTING.md CONTRIBUTING.rst || true)"
  pr_template_path="$(get_first_existing_file "$repo" .github/PULL_REQUEST_TEMPLATE.md PULL_REQUEST_TEMPLATE.md docs/PULL_REQUEST_TEMPLATE.md .github/pull_request_template.md pull_request_template.md || true)"
  codeowners_path="$(get_first_existing_file "$repo" .github/CODEOWNERS CODEOWNERS docs/CODEOWNERS || true)"
  coc_path="$(get_first_existing_file "$repo" CODE_OF_CONDUCT.md .github/CODE_OF_CONDUCT.md docs/CODE_OF_CONDUCT.md || true)"
  governance_path="$(get_first_existing_file "$repo" MAINTAINERS.md GOVERNANCE.md GOVERNANCE.md docs/GOVERNANCE.md docs/MAINTAINERS.md MAINTAINERS.rst || true)"

  issue_templates="$(list_dir_names "$repo" ".github/ISSUE_TEMPLATE" | paste -sd ', ' - || true)"
  docs_entries="$(list_dir_names "$repo" "docs" | head -n 20 | paste -sd ', ' - || true)"
  workflow_entries="$(list_dir_names "$repo" ".github/workflows" | paste -sd ', ' - || true)"

  labels_json="$TMP_DIR/${idx}_${name}_labels.json"
  gh_api "repos/$repo/labels?per_page=100" >"$labels_json"
  beginner_labels="$(jq -r '[.[].name | select(test("good first issue|help wanted|beginner|starter|easy|first-timers|up-for-grabs|mentorship|onboarding|newcomer"; "i"))] | unique | join(", ")' "$labels_json")"
  all_labels_sample="$(jq -r '.[0:25] | map(.name) | join(", ")' "$labels_json")"

  good_first_count="$(search_count "repo:$repo is:issue is:open label:\"good first issue\"")"
  help_wanted_count="$(search_count "repo:$repo is:issue is:open label:\"help wanted\"")"

  pulls_json="$TMP_DIR/${idx}_${name}_pulls.json"
  gh_api "repos/$repo/pulls?state=closed&sort=updated&direction=desc&per_page=50" >"$pulls_json"
  merged_prs="$(jq '[.[] | select(.merged_at != null)][0:10]' "$pulls_json")"
  merged_count="$(printf '%s' "$merged_prs" | jq 'length')"
  merged_span="$(printf '%s' "$merged_prs" | jq -r 'if length > 1 then "\(.[length-1].merged_at) to \(.[0].merged_at)" else "Not enough merged PR data" end')"
  merged_titles="$(printf '%s' "$merged_prs" | jq -r 'map("- " + .title + " (" + .merged_at + ")") | join("\n")')"

  workflow_notes=""
  if [[ -n "${workflow_entries:-}" ]]; then
    IFS=',' read -ra wf_arr <<<"$workflow_entries"
    for wf_raw in "${wf_arr[@]}"; do
      wf="$(printf '%s' "$wf_raw" | xargs)"
      [[ -z "$wf" ]] && continue
      wf_json="$TMP_DIR/${idx}_${name}_workflow.json"
      if fetch_to_file "repos/$repo/contents/.github/workflows/$wf" "$wf_json"; then
        wf_content="$(decode_content <"$wf_json")"
        wf_name="$(printf '%s\n' "$wf_content" | sed -n 's/^name:[[:space:]]*//p' | head -n1)"
        [[ -z "$wf_name" ]] && wf_name="$wf"
        if printf '%s\n' "$wf_content" | grep -Eq 'pull_request|pull_request_target'; then
          trigger="Runs on PRs"
        else
          trigger="No direct PR trigger detected"
        fi
        jobs="$(printf '%s\n' "$wf_content" | grep -E '^[[:space:]]{2}[A-Za-z0-9_-]+:' | sed 's/^[[:space:]]*//' | sed 's/:$//' | head -n 6 | paste -sd ', ' -)"
        [[ -z "$jobs" ]] && jobs="jobs not parsed"
        workflow_notes+="- $wf_name (\`$wf\`): $trigger; jobs include $jobs"$'\n'
      fi
    done
  fi

  readme_excerpt="$( [[ -n "${readme_path:-}" ]] && get_text_excerpt "$repo" "$readme_path" || true )"
  contributing_excerpt="$( [[ -n "${contributing_path:-}" ]] && get_text_excerpt "$repo" "$contributing_path" || true )"
  issue_template_excerpt=""
  if [[ -n "${issue_templates:-}" ]]; then
    first_issue_template="$(printf '%s\n' "$issue_templates" | tr ',' '\n' | head -n1 | xargs)"
    if [[ -n "$first_issue_template" ]]; then
      issue_template_excerpt="$(get_text_excerpt "$repo" ".github/ISSUE_TEMPLATE/$first_issue_template" || true)"
    fi
  fi

  write_json_summary "$summary_json" \
    --arg idx "$idx" \
    --arg repo "$repo" \
    --arg display_name "$display_name" \
    --arg out_file "$out_file" \
    --arg repo_url "$repo_url" \
    --arg description "$description" \
    --arg stars "$stars" \
    --arg contributors "$contributor_count" \
    --arg language "$language" \
    --arg default_branch "$default_branch" \
    --arg readme_path "${readme_path:-}" \
    --arg contributing_path "${contributing_path:-}" \
    --arg issue_templates "${issue_templates:-}" \
    --arg pr_template_path "${pr_template_path:-}" \
    --arg codeowners_path "${codeowners_path:-}" \
    --arg coc_path "${coc_path:-}" \
    --arg governance_path "${governance_path:-}" \
    --arg docs_entries "${docs_entries:-}" \
    --arg workflow_entries "${workflow_entries:-}" \
    --arg workflow_notes "${workflow_notes:-}" \
    --arg beginner_labels "${beginner_labels:-}" \
    --arg all_labels_sample "${all_labels_sample:-}" \
    --arg good_first_count "$good_first_count" \
    --arg help_wanted_count "$help_wanted_count" \
    --arg merged_count "$merged_count" \
    --arg merged_span "$merged_span" \
    --arg merged_titles "${merged_titles:-}" \
    --arg readme_excerpt "${readme_excerpt:-}" \
    --arg contributing_excerpt "${contributing_excerpt:-}" \
    --arg issue_template_excerpt "${issue_template_excerpt:-}" \
    '{
      idx: $idx,
      repo: $repo,
      display_name: $display_name,
      out_file: $out_file,
      repo_url: $repo_url,
      description: $description,
      stars: ($stars | tonumber),
      contributors: ($contributors | tonumber),
      language: $language,
      default_branch: $default_branch,
      paths: {
        readme: $readme_path,
        contributing: $contributing_path,
        issue_templates: $issue_templates,
        pr_template: $pr_template_path,
        codeowners: $codeowners_path,
        code_of_conduct: $coc_path,
        governance: $governance_path
      },
      docs_entries: $docs_entries,
      workflow_entries: $workflow_entries,
      workflow_notes: $workflow_notes,
      beginner_labels: $beginner_labels,
      all_labels_sample: $all_labels_sample,
      good_first_count: ($good_first_count | tonumber),
      help_wanted_count: ($help_wanted_count | tonumber),
      merged_count: ($merged_count | tonumber),
      merged_span: $merged_span,
      merged_titles: $merged_titles,
      excerpts: {
        readme: $readme_excerpt,
        contributing: $contributing_excerpt,
        issue_template: $issue_template_excerpt
      }
    }'

  printf 'Collected %s\n' "$repo"
done

jq -s '.' "$TMP_DIR"/*_summary.json >"$OUT_DIR/research_data.json"
printf 'Wrote %s\n' "$OUT_DIR/research_data.json"
