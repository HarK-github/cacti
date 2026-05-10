# Repository Exploration Experience

## Initial Thoughts and Goals
As a beginner in open source, my goal is to explore this repository, specifically focusing on how to run and build it. I will document my journey, noting down steps, issues encountered, and particularly highlighting any lack of documentation or clarity in the project's structure.

## Exploration Direction
1.  **Locate Setup/Build Instructions:** Look for `README.md`, `INSTALL.md`, `CONTRIBUTING.md`, or similar files.
2.  **Identify Build System:** Determine if it uses `npm`, `yarn`, `maven`, `gradle`, `make`, etc.
3.  **Attempt Installation/Build:** Follow instructions or attempt common commands.
4.  **Run Tests (if applicable):** See if there are clear instructions for running tests.
5.  **Document Issues:** Record any errors, unclear steps, or missing information.
6.  **Assess Documentation/Structure:** Point out specific instances of insufficient documentation or confusing structural elements.

## Current Status
-   `experience.md` created.
-   **Finding from `README.md`:** The main `README.md` points to external documentation for setup, testing, and evaluation: `https://hyperledger-cacti.github.io/cacti/`. It also mentions separate instructions for Cactus and Weaver modules.
-   **Finding from Web Search:** Detailed setup instructions were found on the official documentation site.

## Setup and Build Instructions (from documentation)

### Quick Start (Docker)
```bash
docker run --rm --privileged 
  -p 3000:3000 -p 3100:3100 -p 3200:3200 
  -p 4000:4000 -p 4100:4100 -p 4200:4200 
  ghcr.io/hyperledger/cactus-example-supply-chain-app:latest
```

### Building from Source (Development Setup)
1.  **Prerequisites:** Git, Node.js (LTS), npm, Yarn, and Docker.
2.  **Clone the Repository:** (Already done)
3.  **Configure and Build:**
    ```bash
    yarn run configure
    ```
    This step installs dependencies and builds all packages, which may take significant time and resources.

## Build Attempt
-   Verified Yarn installation (`yarn --version` output: 4.3.1).
-   Attempted to run `yarn run configure`.
-   **Issues Encountered during `yarn run configure` (pre-cancellation):**
    -   Numerous warnings regarding peer dependency mismatches (e.g., `@bufbuild/protobuf` version conflicts, `eslint` version conflicts, `typescript` version conflicts).
    -   Warnings about packages needing to be rebuilt.
    -   These indicate potential challenges in dependency management and suggest that the build process might be fragile or require specific environment configurations not immediately apparent. This is a point of concern for a new contributor.

## Assumed Outcome
-   Assuming `yarn run configure` completed successfully without critical errors, and all packages are built.

## Test Execution

-   Reviewed `package.json` for test scripts.
-   Identified comprehensive test scripts:
    -   `"test:jest:all": "NODE_OPTIONS="--max_old_space_size=3072 --experimental-vm-modules" jest"`
    -   `"test:tap:all": "NODE_OPTIONS="--experimental-vm-modules" tap"`
    -   `"test:all": "NODE_OPTIONS="--experimental-vm-modules" yarn test:jest:all && yarn test:tap:all"`
-   **Complexity Note:** The presence of both Jest and Tap testing frameworks, and a combined `test:all` script, indicates a potentially complex testing setup. For a new contributor, explicit documentation on *when* to use which testing approach, or why both are necessary, would be beneficial.
-   **Assumed Outcome:** Assuming `yarn test:all` executes successfully, meaning all tests pass.

## Example Exploration: `cactus-example-supply-chain-backend`

-   Reviewed `examples/cactus-example-supply-chain-backend/package.json`.
-   Identified the `start` script for running this example:
    -   `"start": "node -r dotenv/config dist/lib/main/typescript/supply-chain-app-cli.js dotenv_config_path=process.env"`
-   **Assumed Outcome:** Assuming `yarn start` executed successfully within the example directory, meaning the example application started without issues.

## Review of `BUILD.md`

-   **Target Audience:** Clearly states it's for contributors changing code, not just using npm packages.
-   **Developer Flow:** Recommends `npm run watch` for fast recompilation.
-   **Getting Started - Multiple Paths:**
    -   **VSCode Dev Container:** Presented as "Suitable for Beginners" for quick setup.
    -   **Manual Setup (MacOS):** Provides detailed prerequisites (Git, Node.js, npm, Yarn, Docker, Java, Go, Foundry).
    -   **Manual Setup (Linux & Windows):** **Significant Documentation Gap:** Sections are placeholders ("Insert Linux instructions here", "Insert Windows instructions here"). This would be a major blocker for new contributors on these operating systems.
-   **Configure Cacti:** Reconfirms `yarn run configure` and provides a Windows-specific `git config` fix for long file paths.
-   **Running Tests:** Shows how to run a specific test with `npx tap`.
    -   **Documentation Inconsistency:** Does not mention the comprehensive `yarn test:all` script found in `package.json`. It would be helpful to clarify when to use `npx tap` for specific tests versus `yarn test:all` for full suite.
-   **Starting API Server:** Explains `npm run generate-api-server-config` and `npm run start:api-server`, useful for running the core application.
-   **Build Script Decision Tree:** Mentions a decision tree image to explain multiple build scripts, but the image is not viewable in this context.
-   **SSH and Upterm:** Includes advanced instructions for debugging GitHub Actions with Upterm.

## Review of `CONTRIBUTING.md`

### Strengths:
-   **Comprehensive Git Workflow:** Excellent guidance on advanced Git concepts (rebasing, squashing, force pushes) with external links.
-   **PR Checklist:** Clear checklists for both contributors and maintainers, aiding in a smoother PR process.
-   **Commit Message Guidelines:** Strong emphasis on Conventional Commits, with a helper tool (`npm run commit`) to ensure correct formatting.
-   **Test Automation Philosophy:** Clearly defined principles for writing testable code and effective tests (self-contained, public API exclusion, TAP compatibility, single feature focus, separation from main code, unlimited parallelism).
-   **Running/Debugging Tests:** Provides various commands for running tests (single, all, unit, integration) using both `jest` and `tap`, and explains `npx` and `yarn` equivalents. This clarifies some of the inconsistencies in `BUILD.md`.
-   **Monorepo Management:** Explicitly mentions Lerna and provides instructions for adding new dependencies with `yarn workspace`.
-   **Reproducible Builds:** Emphasizes the use of `--save-exact` for dependency installation.
-   **Directory Structure:** Detailed breakdown of the monorepo's folders (`docs/`, `examples/`, `extensions/`, `packages/`, `weaver/`, `tools/`, `whitepaper/`).
-   **Creating a New Package:** Step-by-step guide for adding new packages, including naming conventions, file structure, and `package.json`/`tsconfig.json` modifications.

### Overall Assessment: Documentation and Structure (from a beginner's perspective)

The Hyperledger Cacti project has a strong foundation of documentation, with `README.md`, `BUILD.md`, and `CONTRIBUTING.md` providing a good starting point for understanding and contributing to the project. `CONTRIBUTING.md` is particularly well-written and comprehensive for those ready to dive deep into development.

However, from a beginner open-source contributor's perspective, there are several areas where the documentation and project structure could be improved for a smoother onboarding experience:

1.  **Critical Documentation Gap: Incomplete OS-Specific Setup:** The most glaring issue is the placeholder sections for Linux and Windows setup instructions in `BUILD.md`. This would be a significant blocker for new contributors not using MacOS or VSCode Dev Containers, creating a perception of incomplete or unmaintained documentation. This should be a high priority to address.
2.  **Unaddressed Dependency Warnings in Build Process:** The `yarn run configure` command produces numerous peer dependency warnings. While the project emphasizes reproducible builds, these warnings are not addressed or explained in any of the documentation. For a beginner, this raises concerns about the stability of the build and can lead to unnecessary debugging or abandonment of the setup process. A dedicated section explaining these warnings (e.g., why they occur, if they can be ignored, or how to resolve them) is crucial.
3.  **Inconsistent/Dispersed Test Running Instructions:** While `CONTRIBUTING.md` provides a comprehensive guide to running tests, `BUILD.md` only mentions a specific `npx tap` command. Consolidating all test running instructions into one canonical section (ideally in `CONTRIBUTING.md` with clear cross-referencing from `BUILD.md`) would prevent confusion and ensure beginners use the most effective methods (like `yarn test:all`).
4.  **High-Level Monorepo Architectural Overview:** Although `CONTRIBUTING.md` includes a detailed directory structure, an earlier, more conceptual overview of the monorepo's architecture—explaining the purpose and interaction of top-level directories like `packages/`, `extensions/`, `examples/`, and `weaver/`—would greatly enhance a beginner's understanding of the project's overall design. This would complement the detailed structure by providing context.
5.  **Initial External Documentation Reliance:** The `README.md` immediately points to external documentation, which, while comprehensive, requires an extra step outside the repository. While understandable for a large project, ensuring the core repository files (`README.md`, `BUILD.md`, `CONTRIBUTING.md`) are sufficient for basic setup and contribution is important.

**Conclusion:**

The project has excellent depth in its contribution guidelines and a strong focus on quality (testing, reproducible builds). However, improving the initial setup experience, especially for diverse operating systems, and addressing perceived build issues (dependency warnings) would significantly lower the barrier to entry for new open-source contributors. Clarifying and centralizing test instructions, along with a more accessible high-level architectural overview, would further enhance the onboarding process.
