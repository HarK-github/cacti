# Detailed Instructions for Drafting a Mentorship Proposal

## Purpose

This guide helps you write a **strong, credible proposal** for the Hyperledger Cacti mentorship project (Documentation & Cleanup). A good proposal shows that you have explored the project, understood its pain points, and have a realistic, actionable plan. It is your first deliverable to the mentors.

---

## Step 1: Explore the Project( this is already done you may refer to ./task1-cactic-clone-build-report.md for this )
Do not start writing until you have completed this exploration. Your proposal must be based on actual findings, not generic statements.

### 1.1 Clone and build the project (you already did this)
- Note exactly what worked and what didn’t.
- Save the errors you encountered (ENOSPC, EXDEV, Trivy failure, IPv6 timeouts).
- Record the time taken and data downloaded.

### 1.2 Read all key documents
- `README.md`, `BUILD.md`, `FAQ.md`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`
- Identify missing or outdated sections. For example: no architecture overview, broken links, old commands.

### 1.3 Explore the issue tracker
Use these filters and record your findings:
- `label:documentation` – open and closed issues.
- `label:cleanup` – what needs cleaning?
- `label:good first issue` – what do newcomers struggle with?
- `label:tech debt` – long‑term problems.
- `label:stale` + `wontfix` – what maintainers have already rejected (avoid proposing those).

### 1.4 Understand the monorepo structure
- List all packages under `packages/` and `extensions/`.
- For each, check last commit date, presence of tests, and whether it’s referenced in the root `package.json` workspaces.
- Identify at least 2–3 packages that appear deprecated (no activity >1 year).

### 1.5 Review the Cacti Cleanup Initiative
- Ask your mentor for the link to the project board or tracking issue.
- Read any existing discussions about the cleanup goals.

### 1.6 Join Discord and observe
- Read the `#cacti` channel for a few days.
- Note common questions from new contributors (e.g., “how do I run only one test?” “why does `yarn run configure` fail?”).

### 1.7 Capture baseline metrics (for your proposal’s “Impact” section)
- Number of `.md` files in the repo (approx).
- CI runtime from a recent PR (check GitHub Actions).
- Number of open documentation issues.

---

## Step 2: Structure Your Proposal

Use the following headings. Write in clear, professional English. Length: 1500–2500 words (3–5 pages). Break long paragraphs; use bullet points and tables where helpful.

### Title
`Mentorship Proposal: Improving Documentation & Cleanup in Hyperledger Cacti`

### 1. Introduction
- Briefly explain what Hyperledger Cacti is (interoperability framework).
- State that you have successfully built and run the project (mention that your build environment is ready).
- Summarise the main problems you observed: fragmented documentation, legacy modules, complex onboarding, long CI times.
- State your goal: to improve usability, maintainability, and contributor experience.

### 2. Exploration Findings (Evidence)
Show that you have done the homework. Use concrete examples.

| Area | Current State | Problem |
|------|---------------|---------|
| `BUILD.md` | Missing troubleshooting for ENOSPC, EXDEV, IPv6 timeouts | New contributors get stuck for hours |
| Dev container | Trivy feature fails to install | Container build aborts |
| Documentation structure | Mixed across root, `docs/`, and package `README.md`s | Hard to find information |
| Package `cactus-plugin-old-thing` | No commits since 2022, no tests | Dead code, confuses users |
| CI workflow | Runs full test suite even on doc-only PRs | Wastes resources, slow feedback |

Include **screenshots** or **error logs** as evidence (you can attach them separately, but describe them in the proposal).

### 3. Proposed Work – Phased Plan
Present a phased approach. For each phase, state:
- **Goal** (one sentence)
- **Tasks** (bullet list)
- **Expected Deliverable** (e.g., “PR updating `BUILD.md`”, “New file `docs/architecture/overview.md`”)
- **Estimated effort** (days or weeks)

You can adapt the refined 5‑phase plan from the previous answer, but **tailor it** to your own observations. For example:

#### Phase 0: Onboarding & Auditing (1 week)
- Write a “state of the repo” document.
- Inventory all documentation, classify, report broken links.

#### Phase 1: Documentation Restructuring (2 weeks)
- Propose new folder structure (with Mermaid diagram).
- Write a “new user journey” document (30 minutes to API server).
- Fix all broken links.

#### Phase 2: Developer Experience Improvements (3 weeks)
- Rewrite `BUILD.md` with troubleshooting table.
- Pin and fix the Dev Container (remove broken features, add YARN_CACHE_FOLDER).
- Write “First PR” and “Plugin Development 101” tutorials.

#### Phase 3: Code Cleanup (2 weeks)
- Define deprecation criteria.
- Post in Discord, open removal issues for at least 3 deprecated packages.
- Perform safe removal and archive.

#### Phase 4: CI & Tooling (2 weeks)
- Add `paths-ignore` for doc‑only PRs.
- Add pre‑commit hook script.
- Create `tools/choose-build.js` helper.

#### Phase 5: Architecture Documentation & Final Report (2 weeks)
- Write architecture overview with Mermaid diagrams (sequence, graph, class).
- Write plugin lifecycle document.
- Deliver final report with metrics (time to first build, CI reduction, etc.)

### 4. Timeline (Gantt or Table)
Present a week‑by‑week schedule. Example:

| Week | Phase | Focus | Deliverable |
|------|-------|-------|-------------|
| 1 | 0 | Orientation, metrics baseline | State of repo + metrics file |
| 2–3 | 1 | Doc audit, new structure | Doc inventory, user journey |
| 4–6 | 2 | Dev experience + tutorials | Updated BUILD.md, first-PR guide |
| 7–8 | 3 | Cleanup | Removal PRs for 3+ packages |
| 9–10 | 4 | CI + tooling | CI paths-ignore, pre-commit hook |
| 11–13 | 5 | Architecture docs + report | Overview, final report |
| 14 | Buffer | PR reviews, final polish | All deliverables merged |

### 5. Skills and Why You Are Suitable
- List technical skills: TypeScript/Node.js, Git/GitHub, Docker, CI/CD basics, technical writing.
- Mention your specific experience: you have already built Cacti, solved real errors (ENOSPC, EXDEV, network timeouts), and understand the contributor pain points.
- If you have written documentation before (blog, tutorials, previous open source), mention it.
- Show that you can work independently and communicate proactively.

### 6. Expected Outcomes and Metrics
State **measurable** outcomes. For example:

- **Documentation**: >80% of outdated pages updated, all broken links fixed, 3+ new tutorials added.
- **Cleanup**: At least 3 deprecated packages removed, root `package.json` workspaces simplified.
- **Onboarding**: Time to first successful build reduced from X hours to <30 minutes (measured on a clean VM).
- **CI**: Runtime for doc‑only PRs reduced by >70% (via `paths-ignore`).
- **Maintainer feedback**: At least 3 PRs merged without major rework.

### 7. Communication & Reporting Plan
- Weekly updates every Friday (format provided).
- Use mentorship issue thread for tracking.
- If blocked, will ask in `#cacti` within 24 hours.
- Will keep `mentorship-metrics.md` updated weekly.

### 8. Risks and Mitigation
Identify possible problems and how you will handle them:

| Risk | Mitigation |
|------|-------------|
| Maintainer slow to review PRs | Keep PRs small (<400 lines), tag mentor, ping after 3 days |
| A removal proposal is rejected | Accept decision, document, move to next candidate |
| CI changes break something | Test on fork first, use draft PR |
| Time runs out | Prioritise Phase 0–2 (docs) over Phase 5 if needed; inform mentor early |

### 9. Conclusion
- Reiterate the value of the mentorship to the Cacti project and LF Decentralized Trust.
- Express enthusiasm and readiness to start.

---

## Step 3: Write the Proposal – Style and Tone

- **Be specific** – avoid “I will improve documentation”. Say “I will rewrite `BUILD.md` to include a troubleshooting table with ENOSPC, EXDEV, and IPv6 errors.”
- **Be humble but confident** – show you understand the complexity, but have already overcome it.
- **Use evidence** – reference actual issue numbers, file paths, error messages you encountered.
- **Keep it concise** – mentors read many proposals; every sentence should add value.
- **Proofread** – typos and grammar errors hurt credibility.

---

## Step 4: Validate Your Proposal Before Submission

1. **Ask a friend or another contributor** to read it and check if it is clear.
2. **Run it through a spell checker** (Grammarly, LanguageTool).
3. **Ensure all links work** (if you link to issues or Discord discussions).
4. **Check that your timeline is realistic** – add a buffer week for unexpected delays.

---

## Step 5: Submit

- Convert the proposal to **PDF** (unless the mentorship programme requires a different format).
- Name the file: `YourName-Cacti-Mentorship-Proposal.pdf`.
- Submit through the official portal (or email to mentors) as instructed.
- Also post a link to your proposal in the `#cacti-mentorship` Discord channel (if exists) – it shows transparency.

---

## Appendix: Checklist of What Your Proposal Must Include

- [ ] Evidence that you have built and run Cacti (mention successful `yarn run configure` and API server start).
- [ ] At least 3 concrete problems discovered during exploration (with examples).
- [ ] A phased work plan (table or list) with estimated weeks/days.
- [ ] Measurable outcomes (metrics).
- [ ] Your skills relevant to the project.
- [ ] Communication plan (weekly updates, mentor contact).
- [ ] Risk assessment and mitigation.
- [ ] Realistic timeline (12–14 weeks total).
 