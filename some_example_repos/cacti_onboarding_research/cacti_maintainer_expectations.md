# Hyperledger Cacti - Maintainer Expectations and Unwritten Rules

This document summarizes maintainer expectations and "unwritten rules" derived from recent merged Pull Request comments (last 6 months) and open "good first issue" / "help wanted" issues in the `hyperledger-cacti/cacti` repository.

## Key Maintainer Expectations

### 1. Code & Git Hygiene
-   **Atomic Commits & Squashing:** Contributions are expected to be logically grouped into single, coherent commits. Maintainers frequently request contributors to squash multiple commits into one.
    -   *Evidence:* Comments on PR #4161 (from `sandeepnRES`), PR #4099 (from `AndreAugusto11`).
-   **Rebasing:** Branches should be rebased onto the `main` branch to maintain a clean history.
    -   *Evidence:* Comments on PR #4161 (from `RafaelAPB`), PR #4097 (from `LordKubaya`).
-   **Conventional Commits:** Adherence to the Conventional Commits specification is critical for commit messages and PR titles. This includes proper formatting, scope, type, and avoiding capitalization in the commit subject line.
    -   *Evidence:* Comment on PR #4161 (from `LordKubaya`), and PR templates' requirements.
-   **DCO Compliance:** All commits must be signed off, indicating compliance with the Developer Certificate of Origin. Maintainers actively check for this.
    -   *Evidence:* Comment on PR #4161 (from `RafaelAPB`).
-   **Generated Code:** Changes that impact generated code (e.g., from OpenAPI specifications) require corresponding updates to the generated files. Maintainers are willing to assist by running codegen scripts directly or guiding contributors through the process.
    -   *Evidence:* Comments on PR #4099 (from `AndreAugusto11` and `VRamakrishna`).

### 2. Documentation Standards
-   **Accuracy & Up-to-dateness:** Documentation must accurately reflect the current state of the codebase. Outdated documents (like whitepapers) are flagged as technical debt requiring attention.
    -   *Evidence:* Issue #3994 ("docs: revamp cacti documentation").
-   **Completeness:** Any significant code changes, especially new features or updates to software requirements, should be accompanied by relevant documentation updates. This includes foundational setup instructions for new tools.
    -   *Evidence:* PR #4147 (adding Foundry installation instructions to `BUILD.md` and `docs/docs/cactus/build.md`).
-   **Structured Documentation:** There's an interest in improving the overall structure and presentation of documentation (e.g., suggestion for new sub-repositories and reproducible builds for the whitepaper).
    -   *Evidence:* Issue #3994.
-   **Module-Specific Docs:** Specific attention is paid to documentation for key modules like SATP Hermes, including diagrams.
    -   *Evidence:* PR #4125 (SATP Hermes docs in mkdocs).

### 3. CI/CD & Developer Experience
-   **Efficiency & Automation:** There is a clear desire for a fast and efficient CI/CD pipeline, including optimizing build times through caching. Fully automated solutions are preferred over manual steps.
    -   *Evidence:* Issue #1567 (caching container image builds), Issue #481 (ARM64 Docker support requesting full automation), PR #4151 (removing redundant CI triggers).
-   **Focused CI Triggers:** Unnecessary CI runs (e.g., on every push that doesn't include code changes relevant to the triggered workflow) should be avoided to conserve resources and provide faster feedback.
    -   *Evidence:* PR #4151 (removing push-based CI trigger).
-   **Tooling Updates:** Regular updates to core tooling and dependencies (e.g., Node.js versions, actionlint) are part of ongoing maintenance to ensure compatibility and leverage improvements.
    -   *Evidence:* PR #4104 (upgrade to node 20), PR #4105 (upgrade actionlint).

### 4. General Contribution Practices
-   **Proactive Problem Solving:** Issues are often well-detailed with reproduction steps, root cause analysis, and suggested solutions, indicating an expectation for thorough investigation from contributors, especially for "help wanted" tasks.
    -   *Evidence:* Issue #4028 (detailed bug report for Fabric TLS bug).
-   **Collaboration & Guidance:** Maintainers are actively involved in guiding contributors through the review process, including offering direct assistance (e.g., committing to a contributor's branch) and providing clear instructions for addressing feedback.
    -   *Evidence:* Comments on PR #4099 (from `VRamakrishna` and `AndreAugusto11`).
-   **Community Engagement:** Labels like `good-first-issue` and `help wanted` are used to signal opportunities for new contributors, with some issues being highly detailed to facilitate external involvement.

## Conclusion

The Hyperledger Cacti maintainers value clean, well-structured contributions that adhere to established git and code quality standards. There is a strong emphasis on comprehensive and up-to-date documentation, robust CI/CD practices (with a focus on efficiency and automation), and a willingness to guide contributors through complex technical or procedural requirements. New contributors looking to engage with the project, especially through the Cacti Cleanup Initiative, should prioritize these aspects to ensure their contributions align with maintainer expectations.

This research was conducted on May 10, 2026.
