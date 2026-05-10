#!/usr/bin/env python3
from __future__ import annotations

import re
from collections import OrderedDict
from pathlib import Path
from typing import Any

import yaml


ROOT = Path("/home/harshit-kandpal/Documents/github_files/cacti/some_example_repos/cacti_onboarding_research")
OUT_DIR = ROOT / "cacti_workflow_research"

REPOS = [
    {
        "index": "01",
        "key": "hyperledger_fabric",
        "name": "Hyperledger Fabric",
        "repo": "hyperledger/fabric",
        "path": ROOT / ".tmp" / "fabric",
        "outfile": "wf_01_hyperledger_fabric.md",
    },
    {
        "index": "02",
        "key": "kubernetes",
        "name": "Kubernetes",
        "repo": "kubernetes/kubernetes",
        "path": ROOT / ".tmp" / "kubernetes",
        "outfile": "wf_02_kubernetes.md",
    },
    {
        "index": "03",
        "key": "vscode",
        "name": "VS Code",
        "repo": "microsoft/vscode",
        "path": ROOT / ".tmp" / "vscode",
        "outfile": "wf_03_vscode.md",
    },
    {
        "index": "04",
        "key": "rust",
        "name": "Rust",
        "repo": "rust-lang/rust",
        "path": ROOT / ".tmp" / "rust",
        "outfile": "wf_04_rust.md",
    },
    {
        "index": "05",
        "key": "freecodecamp",
        "name": "freeCodeCamp",
        "repo": "freeCodeCamp/freeCodeCamp",
        "path": ROOT / ".tmp" / "freecodecamp",
        "outfile": "wf_05_freecodecamp.md",
    },
    {
        "index": "06",
        "key": "grimoirelab",
        "name": "GrimoireLab",
        "repo": "chaoss/grimoirelab",
        "path": ROOT / ".tmp" / "grimoirelab",
        "outfile": "wf_06_grimoirelab.md",
    },
    {
        "index": "07",
        "key": "credo_ts",
        "name": "Credo TS",
        "repo": "openwallet-foundation/credo-ts",
        "path": ROOT / ".tmp" / "credo-ts",
        "outfile": "wf_07_credo_ts.md",
    },
    {
        "index": "08",
        "key": "cacti",
        "name": "Hyperledger Cacti",
        "repo": "hyperledger-cacti/cacti",
        "path": ROOT / ".tmp" / "cacti-upstream",
        "outfile": "wf_08_cacti.md",
    },
]


def safe_load_yaml(path: Path) -> dict[str, Any]:
    class Loader(yaml.SafeLoader):
        pass

    # Avoid YAML 1.1 booleans turning `on` into True.
    for ch, resolvers in list(Loader.yaml_implicit_resolvers.items()):
        Loader.yaml_implicit_resolvers[ch] = [
            (tag, regexp)
            for tag, regexp in resolvers
            if tag != "tag:yaml.org,2002:bool"
        ]

    text = path.read_text(encoding="utf-8")
    data = yaml.load(text, Loader=Loader)
    return data if isinstance(data, dict) else {}


def workflow_files(repo_path: Path) -> list[Path]:
    wf_dir = repo_path / ".github" / "workflows"
    if not wf_dir.exists():
        return []
    return sorted([p for p in wf_dir.iterdir() if p.suffix in {".yml", ".yaml"}])


def normalize_on(data: dict[str, Any]) -> Any:
    if "on" in data:
        return data["on"]
    if True in data:
        return data[True]
    return None


def short_jsonish(value: Any) -> str:
    if value is None:
        return "none"
    if isinstance(value, str):
        return value
    if isinstance(value, list):
        return ", ".join(short_jsonish(v) for v in value)
    if isinstance(value, dict):
        parts = []
        for k, v in value.items():
            if isinstance(v, dict):
                inner = ", ".join(f"{ik}={short_jsonish(iv)}" for ik, iv in v.items())
                parts.append(f"{k}({inner})")
            else:
                parts.append(f"{k}={short_jsonish(v)}")
        return "; ".join(parts) if parts else "default"
    return str(value)


def extract_triggers(on_value: Any) -> tuple[list[str], str]:
    if on_value is None:
        return [], "none declared"
    if isinstance(on_value, str):
        return [on_value], on_value
    if isinstance(on_value, list):
        return [str(v) for v in on_value], ", ".join(str(v) for v in on_value)
    if isinstance(on_value, dict):
        triggers = [str(k) for k in on_value.keys()]
        return triggers, ", ".join(triggers)
    return [str(on_value)], str(on_value)


def trigger_conditions(on_value: Any) -> str:
    if not isinstance(on_value, dict):
        return "default event settings"
    parts = []
    for event, config in on_value.items():
        if config in (None, {}):
            parts.append(f"{event}: default")
            continue
        if isinstance(config, list):
            parts.append(f"{event}: {', '.join(str(v) for v in config)}")
            continue
        if isinstance(config, dict):
            sub = []
            for key in ("branches", "branches-ignore", "tags", "tags-ignore", "paths", "paths-ignore", "types", "cron"):
                if key in config:
                    value = config[key]
                    if isinstance(value, list):
                        sub.append(f"{key}={', '.join(str(v) for v in value)}")
                    else:
                        sub.append(f"{key}={value}")
            if not sub:
                sub.append("custom filters")
            parts.append(f"{event}: {'; '.join(sub)}")
        else:
            parts.append(f"{event}: {config}")
    return " | ".join(parts)


def scan_secrets_and_env(text: str) -> list[str]:
    secrets = sorted(set(re.findall(r"secrets\.([A-Za-z0-9_]+)", text)))
    envs = sorted(set(re.findall(r"\$\{\{\s*env\.([A-Za-z0-9_]+)\s*\}\}", text)))
    vals = []
    if secrets:
        vals.extend(f"secret:{s}" for s in secrets)
    if envs:
        vals.extend(f"env:{e}" for e in envs)
    return vals


def describe_step(step: dict[str, Any]) -> str:
    if not isinstance(step, dict):
        return "unnamed step"
    if step.get("name"):
        return str(step["name"])
    if step.get("uses"):
        return f"Use {step['uses']}"
    if step.get("run"):
        line = str(step["run"]).strip().splitlines()[0]
        return f"Run `{line[:80]}`"
    return "unnamed step"


def infer_job_purpose(job_id: str, job: dict[str, Any], step_texts: list[str]) -> str:
    blob = " ".join([job_id, str(job.get("name", "")), *step_texts]).lower()
    mapping = [
        ("lint", "Linting and style validation"),
        ("test", "Automated test execution"),
        ("build", "Build or packaging validation"),
        ("release", "Release or publishing automation"),
        ("publish", "Artifact publishing"),
        ("deploy", "Deployment automation"),
        ("docker", "Container build or image publication"),
        ("docs", "Documentation build or deployment"),
        ("scorecard", "Security scorecard analysis"),
        ("codeql", "Static security analysis"),
        ("coverage", "Coverage collection and reporting"),
        ("label", "Repository automation or labeling"),
        ("i18n", "Translation or localization maintenance"),
        ("perf", "Performance benchmarking"),
    ]
    for needle, label in mapping:
        if needle in blob:
            return label
    return "Workflow-specific automation"


def infer_visibility(triggers: list[str], text: str, secrets: list[str]) -> str:
    trig = set(triggers)
    has_pr = "pull_request" in trig or "pull_request_target" in trig
    uses_secrets = any(item.startswith("secret:") for item in secrets)
    if "pull_request_target" in trig:
        return "Partial (PR context with elevated maintainer-owned workflow)"
    if has_pr and uses_secrets:
        return "Partial (runs on PRs, but secret-backed steps are limited on forks)"
    if has_pr:
        return "Yes"
    if "workflow_dispatch" in trig or "workflow_call" in trig or "workflow_run" in trig:
        return "No"
    if "push" in trig or "schedule" in trig:
        return "No"
    if "issue_comment" in trig or "pull_request_review" in trig:
        return "Partial"
    return "No"


def classify(path: Path, triggers: list[str], text: str) -> str:
    name = path.name.lower()
    trig = set(triggers)
    lower = text.lower()
    if "schedule" in trig:
        return "SCHEDULED"
    if any(x in trig for x in ("release", "registry_package")) or "release" in name or "publish" in name:
        return "RELEASE"
    if "gh-pages" in lower or "pages" in lower or "deploy_docs" in name or "docs" in name:
        return "DOCS"
    if any(k in name for k in ("label", "stale", "spam", "autoclose", "scorecard", "repolinter", "semantic", "commitlint")):
        return "INFRA"
    if "pull_request_target" in trig or ("workflow_dispatch" in trig and "secret:" in lower):
        return "MAINTAINER_ONLY"
    if "pull_request" in trig:
        return "PR_CHECK"
    if "push" in trig:
        return "MERGE_GATE"
    if "workflow_dispatch" in trig:
        return "MAINTAINER_ONLY"
    return "INFRA"


def estimate_runtime(data: dict[str, Any], text: str) -> str:
    jobs = data.get("jobs", {}) if isinstance(data.get("jobs"), dict) else {}
    job_count = max(len(jobs), 1)
    lower = text.lower()
    score = job_count * 4
    for keyword, bump in [
        ("docker build", 6),
        ("buildx", 6),
        ("playwright", 10),
        ("e2e", 10),
        ("integration", 8),
        ("matrix", 8),
        ("gradle", 6),
        ("mvn", 6),
        ("cargo test", 8),
        ("npm test", 5),
        ("yarn test", 5),
    ]:
        if keyword in lower:
            score += bump
    if score <= 6:
        return "~5-10 minutes"
    if score <= 15:
        return "~10-20 minutes"
    if score <= 30:
        return "~20-45 minutes"
    return "~45+ minutes"


def blocks_pr(category: str, triggers: list[str]) -> str:
    if "pull_request" in triggers or "pull_request_target" in triggers:
        return "Yes"
    if category == "PR_CHECK":
        return "Yes"
    return "No"


def render_repo(repo_cfg: dict[str, Any]) -> tuple[list[dict[str, Any]], str]:
    files = workflow_files(repo_cfg["path"])
    all_rows: list[dict[str, Any]] = []
    lines = [f"# {repo_cfg['name']} — Workflow Analysis", "", "## Workflow Inventory", "| File | Category | Trigger | Blocks PR? |", "|------|----------|---------|------------|"]

    if not files:
        lines.extend([
            "| _No `.github/workflows/` directory_ | INFRA | none | No |",
            "",
            "## Workflow Details",
            "",
            "This repository does not currently keep GitHub Actions workflow files under `.github/workflows/`. For contributors, CI and automation are handled elsewhere in the project infrastructure.",
            "",
            "## Contributor Summary",
            "",
            "A new contributor should not expect standard GitHub Actions checks from the main repository because there are no workflow YAML files in `.github/workflows/`. CI for Kubernetes is largely orchestrated through external infrastructure and repository-integrated bots rather than local workflow files. That means a contributor should focus on the documented project-specific presubmit instructions and the PR bot feedback instead of looking for Actions tabs as the primary source of truth. Maintainer-triggered or infrastructure-owned checks may still run against pull requests, but they are not defined here. Before pushing, contributors still need to follow the repository’s documented build, test, and lint commands locally. Workflow failures inside GitHub Actions are not the main concern in this repo because the usual Actions surface is absent. The contributor experience implication is that CI behavior is less discoverable from the repository alone than in the other repos in this study.",
            "",
            "## Red Flags / Observations",
            "",
            "- CI discoverability is weaker than the other repositories because the main repo does not expose workflow definitions under `.github/workflows/`.",
            "- New contributors have to learn external CI conventions instead of reading self-documenting workflow YAML in-repo.",
            "- This is the opposite of the explicit, contributor-readable pattern that would help Hyperledger Cacti.",
        ])
        return all_rows, "\n".join(lines) + "\n"

    analyses = []
    for wf in files:
        text = wf.read_text(encoding="utf-8")
        data = safe_load_yaml(wf)
        on_value = normalize_on(data)
        triggers, trigger_text = extract_triggers(on_value)
        cond_text = trigger_conditions(on_value)
        secrets = scan_secrets_and_env(text)
        visibility = infer_visibility(triggers, text, secrets)
        category = classify(wf, triggers, text)
        runtime = estimate_runtime(data, text)
        blocks = blocks_pr(category, triggers)
        jobs = data.get("jobs", OrderedDict()) if isinstance(data.get("jobs"), dict) else OrderedDict()
        job_items = []
        for job_id, job in jobs.items():
            if not isinstance(job, dict):
                continue
            steps = job.get("steps", []) if isinstance(job.get("steps"), list) else []
            step_texts = [describe_step(step) for step in steps[:8]]
            purpose = infer_job_purpose(job_id, job, step_texts)
            job_items.append(
                {
                    "job_id": job_id,
                    "purpose": purpose,
                    "steps": step_texts or ["No explicit steps in this job body"],
                }
            )

        analyses.append(
            {
                "file": wf.name,
                "category": category,
                "trigger": trigger_text,
                "conditions": cond_text,
                "visibility": visibility,
                "jobs": job_items,
                "secrets": secrets,
                "runtime": runtime,
                "blocks": blocks,
            }
        )
        all_rows.append(
            {
                "repo": repo_cfg["name"],
                "file": wf.name,
                "category": category,
                "trigger": trigger_text,
                "blocks": blocks,
                "visibility": visibility,
            }
        )

        lines.append(f"| {wf.name} | {category} | {trigger_text} | {blocks} |")

    lines.extend(["", "## Workflow Details", ""])
    for item in analyses:
        lines.append(f"### `{item['file']}` — {item['category']}")
        lines.append(f"**Triggers:** {item['trigger']}")
        lines.append(f"**Branches/Paths:** {item['conditions']}")
        lines.append(f"**Contributor visible:** {item['visibility']}")
        lines.append("")
        lines.append("#### Jobs")
        if item["jobs"]:
            for idx, job in enumerate(item["jobs"], start=1):
                lines.append(f"{idx}. **{job['job_id']}** — {job['purpose']}")
                for step in job["steps"]:
                    lines.append(f"   - Step: {step}")
        else:
            lines.append("1. **No jobs declared** — This file likely delegates work through reusable workflows or event plumbing.")
        lines.append("")
        lines.append(f"**Secrets required:** {', '.join(item['secrets']) if item['secrets'] else 'none'}")
        lines.append(f"**Estimated run time:** {item['runtime']}")
        lines.append(f"**Blocks PR merge:** {item['blocks']}")
        lines.append("")

    pr_like = [a["file"] for a in analyses if a["blocks"] == "Yes"]
    maintainer_only = [a["file"] for a in analyses if a["category"] in {"RELEASE", "MAINTAINER_ONLY", "DOCS"} and a["visibility"] != "Yes"]
    local_prep = sorted(
        {
            prep
            for a in analyses
            for prep in [
                "run lint" if any("lint" in j["purpose"].lower() for j in a["jobs"]) else "",
                "run tests" if any("test" in j["purpose"].lower() for j in a["jobs"]) else "",
                "verify builds" if any("build" in j["purpose"].lower() for j in a["jobs"]) else "",
            ]
            if prep
        }
    )
    lines.extend(["## Contributor Summary", ""])
    summary = (
        f"New contributors should expect these workflows to matter most on their pull requests: {', '.join(pr_like[:10]) if pr_like else 'none directly from GitHub Actions'}. "
        f"Workflows that are mainly for maintainers or release automation include {', '.join(maintainer_only[:10]) if maintainer_only else 'very few maintainer-only files'}. "
        f"To stay ahead of CI, contributors should at minimum {', '.join(local_prep) if local_prep else 'follow the repository build and test instructions locally'}. "
        f"Release, publishing, scheduled maintenance, scorecard, and documentation deployment workflows are usually not something a first-time contributor needs to optimize for unless their change touches that surface. "
        f"If a PR-visible workflow fails, the quickest path is to compare the failing job steps with the local equivalent command and then re-run only after reproducing or understanding the issue. "
        f"The contributor experience in this repository is {'broad and explicit' if len(analyses) > 8 else 'fairly compact'} because the workflow files themselves expose most of the automation contract."
    )
    lines.append(summary)
    lines.append("")
    lines.append("## Red Flags / Observations")
    lines.append("")
    complex_files = [a["file"] for a in analyses if len(a["jobs"]) >= 6 or "45+" in a["runtime"]][:6]
    if complex_files:
        lines.append(f"- Potentially complex for newcomers: {', '.join(complex_files)}.")
    unnamed = [a["file"] for a in analyses if any(j['purpose'] == 'Workflow-specific automation' for j in a["jobs"])][:6]
    if unnamed:
        lines.append(f"- Some workflows need more in-file explanation because job intent is not obvious from names alone: {', '.join(unnamed)}.")
    confusing = [a["file"] for a in analyses if "Partial" in a["visibility"]][:6]
    if confusing:
        lines.append(f"- These may confuse fork-based contributors because they mix PR execution with restricted secrets or elevated contexts: {', '.join(confusing)}.")
    good_examples = [a["file"] for a in analyses if a["category"] == "PR_CHECK"][:6]
    if good_examples:
        lines.append(f"- Good patterns Cacti can replicate: clearly separated PR checks such as {', '.join(good_examples)}.")
    lines.append("")
    return all_rows, "\n".join(lines)


def write_reports() -> None:
    OUT_DIR.mkdir(exist_ok=True)
    master_rows = []
    repo_outputs = {}
    for repo in REPOS:
        rows, md = render_repo(repo)
        master_rows.extend(rows)
        repo_outputs[repo["outfile"]] = md

    for filename, body in repo_outputs.items():
        (OUT_DIR / filename).write_text(body, encoding="utf-8")

    synth = [
        "# Workflow Synthesis",
        "",
        "## Section 1 — Master Workflow Inventory Table",
        "",
        "| Repo | File | Category | Trigger | Blocks PR | Contributor Visible |",
        "|------|------|----------|---------|-----------|---------------------|",
    ]
    for row in master_rows:
        synth.append(
            f"| {row['repo']} | {row['file']} | {row['category']} | {row['trigger']} | {row['blocks']} | {row['visibility']} |"
        )
    synth.extend(
        [
            "",
            "## Section 2 — Cacti-Specific Gap Analysis",
            "",
            "Cacti has a very large workflow estate, especially around package-specific publishing, Weaver integration tests, and SATP Hermes automation. Compared with Fabric, VS Code, Rust, freeCodeCamp, and Credo TS, Cacti exposes less of a clean boundary between contributor-facing PR checks and maintainer-facing release/deployment workflows. The repository does have strong PR validation coverage through files such as `checks-and-build.yaml`, `code-quality-checks.yaml`, `core-packages-workflow.yaml`, `connector-packages-workflow.yaml`, `examples-workflow.yaml`, and multiple Weaver test workflows, but the signal is diluted by the high number of adjacent publish and release workflows living in the same directory. The upstream workflow names do not by themselves explain which checks a first-time contributor should care about most, and the current contributor documentation does not surface a simple CI map in the way the better contributor-experience repositories effectively do through small, well-named workflow sets. Fork-based contributors are especially likely to be confused by publish, release, GHCR, npm, and scorecard files because those either require secrets or are not actionable for a normal PR. The strongest patterns Cacti could adopt are Fabric’s smaller split between PR validation and release security scans, Credo TS’s compact CI plus release shape, and VS Code’s very explicit naming of PR-specific operating-system test lanes.",
            "",
            "## Section 3 — Recommended Cacti Workflow Improvements",
            "",
            "1. Consolidate contributor-facing checks into a clearly documented small set of primary PR workflows and separate maintainer-only publish/release workflows with a naming prefix such as `release-` or `maintainer-`.",
            "2. Add a CI overview section to `CONTRIBUTING.md` that maps common change types to the exact workflows contributors should expect on their PRs.",
            "3. Reduce path-based fragmentation where possible by grouping related package validation into fewer reusable workflows with explicit summaries.",
            "4. Mark secret-dependent jobs more clearly in workflow names or comments so fork contributors know which failures they can ignore versus which ones block merge.",
            "5. Add more inline comments to the longest Weaver and SATP Hermes workflows, especially where orchestration, network setup, or publish logic is non-obvious.",
            "",
            "## Section 4 — Contributor CI Cheat Sheet (draft for Cacti)",
            "",
            "Hyperledger Cacti uses GitHub Actions for several different purposes, and it helps to separate contributor-facing checks from maintainer-only automation. On a normal pull request, you should expect validation workflows to run automatically for code quality, builds, package-specific checks, examples, and some Weaver or SATP-related tests depending on which paths changed. These are the workflows you should care about most before asking for review, because they are the closest thing to the repository’s merge gate. By contrast, publish, release, documentation deployment, GHCR image publication, npm publication, and similar workflows are mainly for maintainers and release managers. If you see a workflow that is clearly about publishing artifacts or pushing images, it is usually not something you need to debug for a first contribution unless your change intentionally modifies release automation. Before pushing, run the project’s documented install, lint, test, and build commands locally, and if your change touches a specific package family, run the nearest package-level checks for that area as well. When a CI check fails, read the failing job name first and map it back to the workflow file; Cacti has many workflows, so understanding whether the failure came from a core package check, a connector workflow, an example app, or a Weaver integration test will save time immediately. If the failure is in a maintainer-only publish or deploy workflow, confirm whether the job depends on repository secrets or release credentials before treating it as a contributor-side issue. If the failure is in a PR validation workflow, reproduce the failing command locally, fix the issue, and push a follow-up commit rather than guessing. If a failure seems unrelated to your change or appears to depend on external services, mention that in the PR and ask a maintainer whether the failure is a known flaky lane or a restricted workflow that behaves differently on forks.",
            "",
        ]
    )
    (OUT_DIR / "wf_00_synthesis.md").write_text("\n".join(synth), encoding="utf-8")


if __name__ == "__main__":
    write_reports()
