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
