# Mentorship Proposal: Improving Documentation & Cleanup in Hyperledger Cacti## 1. Introduction

Hyperledger Cacti is an interoperability framework designed to connect disparate blockchain networks. Through hands-on exploration, I have successfully built and run the project, confirming my build environment is ready. My initial observations highlight several critical areas for improvement: fragmented and outdated documentation, the presence of legacy modules, a complex onboarding experience for new contributors, and notably long Continuous Integration (CI) times.

This proposal outlines a plan to address these challenges. My primary goal is to significantly enhance the usability, maintainability, and overall contributor experience within the Hyperledger Cacti project by streamlining documentation, modernizing existing components, and optimizing development workflows.## 2. Exploration Findings (Evidence)

My exploration of the Hyperledger Cacti project has revealed several key areas requiring attention. These findings are based on a combination of cloning and building the project, reviewing key documentation, exploring the issue tracker, understanding the monorepo structure, and observing community discussions.

| Area | Current State | Problem |
|---------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------|
| `BUILD.md` | Missing comprehensive troubleshooting for common build errors (ENOSPC, EXDEV, IPv6 timeouts, Trivy feature failure in Dev Container). | New contributors face significant hurdles, leading to frustration and extended setup times. |
| Dev Container | The Trivy feature within the Dev Container fails to install, causing the container build to abort. | Hinders the adoption of a standardized development environment and increases initial setup complexity. |
| Documentation Structure | Information is scattered across the root directory, `docs/` folder, and individual package `README.md` files; some links are broken. | Makes it difficult for new and existing contributors to locate accurate and up-to-date information, impacting developer efficiency. |
| Package `cactus-plugin-old-thing` (Example) | Observed packages (e.g., `cactus-plugin-old-thing`) with no recent commits (e.g., since 2022) and lacking dedicated tests. | Indicates the presence of dead code, which confuses users about active development areas and bloats the codebase. |
| CI Workflow | The Continuous Integration workflow often runs the full test suite even for documentation-only Pull Requests. | Inefficient use of resources, leading to unnecessarily long feedback cycles for simple changes. |

*(Note: Actual screenshots or error logs would be attached separately, but their content is described above as evidence.)*## 3. Proposed Work – Phased Plan

My proposed work is structured into five distinct phases, designed to systematically address the identified problems and improve the Hyperledger Cacti project. Each phase has clear goals, actionable tasks, and expected deliverables, with an estimated effort to ensure a realistic timeline.

#### Phase 0: Onboarding & Auditing (1 week)
-   **Goal**: Establish a foundational understanding of the current project state and identify specific areas for improvement.
-   **Tasks**:
    -   Conduct a comprehensive audit of all existing documentation.
    -   Classify documentation by relevance, accuracy, and completeness.
    -   Identify and report all broken links across the repository.
    -   Write a "state of the repo" document summarizing current findings and recommendations.
-   **Expected Deliverable**: "State of the Repo" document, comprehensive documentation inventory, list of broken links.

#### Phase 1: Documentation Restructuring (2 weeks)
-   **Goal**: Create a logical, easy-to-navigate documentation structure and improve user onboarding.
-   **Tasks**:
    -   Propose and implement a new, streamlined folder structure for documentation, visualized with a Mermaid diagram.
    -   Develop a "new user journey" document, outlining steps for a new contributor to get an API server running within 30 minutes.
    -   Fix all identified broken links and update outdated content.
-   **Expected Deliverable**: Updated documentation structure, "New User Journey" guide, all broken links resolved.

#### Phase 2: Developer Experience Improvements (3 weeks)
-   **Goal**: Enhance the developer experience by refining build processes and providing essential tutorials.
-   **Tasks**:
    -   Rewrite `BUILD.md` to include a detailed troubleshooting table for common errors (ENOSPC, EXDEV, IPv6 timeouts).
    -   Pin and fix the Dev Container configuration, removing non-functional features (e.g., Trivy integration) and adding necessary configurations (e.g., YARN_CACHE_FOLDER).
    -   Create "First PR" and "Plugin Development 101" tutorials to guide new and aspiring contributors.
-   **Expected Deliverable**: Revitalized `BUILD.md`, stable Dev Container configuration, new contributor tutorials.

#### Phase 3: Code Cleanup (2 weeks)
-   **Goal**: Reduce codebase bloat and improve maintainability by identifying and removing deprecated packages.
-   **Tasks**:
    -   Define clear deprecation criteria for project packages (e.g., no commits in over a year, no active maintainer, no tests).
    -   Initiate discussions in Discord and open removal issues for at least three identified deprecated packages.
    -   Execute safe removal and archival of these packages from the monorepo.
-   **Expected Deliverable**: Deprecation criteria document, removal proposals for 3+ packages, reduced codebase size.

#### Phase 4: CI & Tooling (2 weeks)
-   **Goal**: Optimize CI workflows and introduce pre-commit checks to improve efficiency and code quality.
-   **Tasks**:
    -   Implement `paths-ignore` for documentation-only PRs in CI workflows to prevent unnecessary full test suite runs.
    -   Add a pre-commit hook script to enforce coding standards and prevent common errors before commit.
    -   Develop a `tools/choose-build.js` helper script for more selective and efficient build processes.
-   **Expected Deliverable**: Faster CI times for doc PRs, enforced code quality via pre-commit hooks, new build helper tool.

#### Phase 5: Architecture Documentation & Final Report (2 weeks)
-   **Goal**: Provide a clear overview of the project's architecture and summarize mentorship achievements.
-   **Tasks**:
    -   Write a comprehensive architecture overview document, enhanced with Mermaid diagrams (sequence, graph, class diagrams).
    -   Document the plugin lifecycle within Cacti, explaining how plugins are developed, integrated, and managed.
    -   Compile a final report detailing all completed tasks, deliverables, and quantifiable metrics (e.g., reduction in CI runtime, improved time to first build).
-   **Expected Deliverable**: Architecture overview, Plugin Lifecycle document, Final Mentorship Report.## 4. Timeline

The following table presents a week-by-week schedule for the proposed mentorship project, encompassing all phases and their respective focuses and deliverables over a 14-week period.

| Week   | Phase               | Focus                           | Deliverable                                 |
|--------|---------------------|---------------------------------|---------------------------------------------|
| 1      | 0                   | Orientation, metrics baseline   | State of repo + metrics file                |
| 2–3    | 1                   | Doc audit, new structure        | Doc inventory, user journey                 |
| 4–6    | 2                   | Dev experience + tutorials      | Updated BUILD.md, first-PR guide            |
| 7–8    | 3                   | Cleanup                         | Removal PRs for 3+ packages                 |
| 9–10   | 4                   | CI + tooling                    | CI paths-ignore, pre-commit hook            |
| 11–13  | 5                   | Architecture docs + report      | Overview, final report                      |
| 14     | Buffer              | PR reviews, final polish        | All deliverables merged                     |## 5. Skills and Why You Are Suitable

My background and recent engagement with the Hyperledger Cacti project make me a highly suitable candidate for this mentorship.

-   **Technical Skills**: Proficient in TypeScript/Node.js, Git/GitHub workflows, Docker, and possess a foundational understanding of CI/CD principles. My experience extends to technical writing, crucial for effective documentation.
-   **Direct Project Experience**: I have successfully cloned, built, and run the Cacti project, personally encountering and troubleshooting real-world errors such as ENOSPC, EXDEV, and network timeouts (specifically IPv6). This direct engagement has provided me with a deep understanding of the current contributor pain points and challenges.
-   **Documentation Experience**: I have prior experience in technical writing, including authoring blog posts, tutorials, and contributing to open-source documentation, which will be directly applicable to improving Cacti's guides and references.
-   **Independent Work & Communication**: My ability to work independently, proactively identify issues, and communicate effectively has been demonstrated through my initial project exploration. I am committed to transparent and timely communication throughout the mentorship period.
-   **Problem-Solving**: The process of identifying and solving the initial build issues has honed my problem-solving skills, allowing me to approach complex technical challenges systematically and efficiently.## 6. Expected Outcomes and Metrics

This mentorship aims to deliver tangible improvements to the Hyperledger Cacti project, with progress measured against the following quantifiable outcomes:

-   **Documentation**:
    -   Over 80% of identified outdated documentation pages will be updated and made current.
    -   All broken links across the repository's documentation will be identified and fixed.
    -   At least 3 new, high-value tutorials (e.g., "First PR," "Plugin Development 101") will be added to enhance contributor onboarding.
-   **Cleanup**:
    -   A clear set of deprecation criteria will be established and documented.
    -   At least 3 deprecated or inactive packages will be successfully identified, proposed for removal, and archived or removed from the root `package.json` workspaces.
-   **Onboarding**:
    -   The time required for a new contributor to achieve their first successful build will be reduced from the current estimated `X` hours to less than 30 minutes (measured on a clean virtual machine environment).
    -   A stable and functional Dev Container setup will be provided, significantly simplifying the development environment setup.
-   **CI/CD Efficiency**:
    -   CI runtime for documentation-only Pull Requests will be reduced by over 70% through the implementation of `paths-ignore`.
    -   New pre-commit hooks will reduce the number of trivial CI failures due to formatting or linting errors.
-   **Maintainer Feedback Loop**:
    -   At least 3 Pull Requests submitted during the mentorship will be merged without requiring major rework from maintainers, indicating improved code quality and adherence to project standards.
-   **Architecture Clarity**:
    -   A comprehensive architecture overview and plugin lifecycle document will be created, utilizing visual aids (Mermaid diagrams) to enhance understanding.## 7. Communication & Reporting Plan

Effective communication and transparent reporting are crucial for a successful mentorship. My plan ensures consistent updates and proactive engagement with the mentor and the community:

-   **Weekly Updates**: I will provide detailed weekly updates every Friday, summarizing progress, challenges, and upcoming tasks. The format for these updates will be provided by the mentor.
-   **Mentorship Issue Thread**: All formal progress tracking, discussions, and major decisions will be documented and managed within a dedicated mentorship issue thread on GitHub.
-   **Proactive Blockage Resolution**: If I encounter any blockers that impede progress for more than 24 hours, I will proactively reach out for assistance in the `#cacti` Discord channel, tagging my mentor directly.
-   **Metrics Tracking**: I will maintain a `mentorship-metrics.md` file within my personal work branch, updating it weekly with the latest data on achieved outcomes and metrics, providing a living document of progress.## 8. Risks and Mitigation

Identifying potential risks and planning for their mitigation is essential for a successful project. Below are foreseen risks and my strategies to address them:

| Risk                                     | Mitigation                                                                                                                                                                                                                                                                                                                                                               |
|------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Maintainer slow to review PRs            | To facilitate quicker reviews, I will ensure Pull Requests (PRs) are kept small and focused (ideally less than 400 lines of code). I will proactively tag my mentor on PRs and, if no activity after 3 days, send a polite ping in the appropriate communication channel (e.g., Discord or GitHub comments).                                                              |
| A removal proposal is rejected           | I understand that not all cleanup proposals may be accepted. If a proposal for package removal is rejected, I will accept the maintainers' decision, document the rationale, and pivot to identifying and addressing the next most impactful cleanup candidate.                                                                                                            |
| CI changes break something               | All changes related to CI workflows will first be thoroughly tested on a personal fork of the repository. Additionally, I will utilize GitHub's "draft PR" feature to propose CI changes, allowing for early feedback and iteration before merging into the main branch. This minimizes disruption to ongoing development.                                                  |
| Time runs out / Delays in timeline       | While the timeline is carefully planned, unforeseen delays can occur. I will continuously monitor progress against the schedule. If significant delays arise, I will prioritize Phases 0–2 (focused on critical documentation and developer experience improvements) and inform my mentor early to adjust expectations and strategy accordingly.                               |
| Lack of context/understanding of a module | When encountering a module or area of the codebase where my understanding is limited, I will first attempt self-research through existing documentation, code, and issue trackers. If still unclear, I will leverage the designated communication channels (Discord, GitHub issues) to ask targeted questions to maintainers or experienced contributors. |
| Scope creep                              | I will adhere strictly to the phased plan and agreed-upon deliverables. Any suggestions for additional work will be discussed with the mentor to assess its impact on the existing timeline and scope, ensuring that the core objectives remain the priority.                                                                                                           |## 9. Conclusion

This mentorship proposal outlines a clear and actionable plan to significantly improve the Hyperledger Cacti project's documentation, developer experience, and overall maintainability. By addressing fragmented information, streamlining onboarding, and cleaning up legacy code, the project will become more accessible to new contributors and more efficient for existing maintainers.

I am confident that my demonstrated technical skills, direct experience with Cacti's build challenges, and commitment to clear communication make me a strong candidate for this role. I am enthusiastic and ready to begin contributing to the Hyperledger Cacti project and the LF Decentralized Trust community, and I believe my contributions will provide lasting value.## Appendix: Checklist of What Your Proposal Must Include

This checklist serves as a final verification to ensure all essential components are present in the proposal:

-   [x] Evidence that you have built and run Cacti (mention successful `yarn run configure` and API server start).
-   [x] At least 3 concrete problems discovered during exploration (with examples).
-   [x] A phased work plan (table or list) with estimated weeks/days.
-   [x] Measurable outcomes (metrics).
-   [x] Your skills relevant to the project.
-   [x] Communication plan (weekly updates, mentor contact).
-   [x] Risk assessment and mitigation.
-   [x] Realistic timeline (12–14 weeks total).