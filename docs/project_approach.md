# Hyperledger Cacti LFX Application Approach

## Context and Goal

This plan is for the LF Decentralized Trust 2026 mentorship application focused on improving the usability, maintainability, and contributor experience of Hyperledger Cacti. I am approaching the application the same way I would approach the project itself: gather evidence from the repository, validate the build and runtime path with real commands, understand the post-merger architecture, and then turn that understanding into a focused, technically honest application.

One date needs to be called out clearly: the prompt refers to an application deadline of **April 15, 2026**, while this workspace date is **April 16, 2026**. Because of that mismatch, this document treats the timeline in two ways:

1. As the ideal sequence I should have executed before **April 15, 2026**.
2. As an immediate catch-up plan I can still use on **April 16, 2026** for any grace period, follow-up communication, or future LFX-style submission.

## Personal Strategy

My application should not read like a generic open-source interest statement. It should show that I already did the work needed to understand Cacti as a real system:

- I enabled Corepack and activated Yarn 4.3.1.
- I verified that `yarn build:dev:backend` completes successfully.
- I confirmed that `npm run generate-api-server-config` fails before the backend build and succeeds after it, which exposed an ordering dependency in the developer workflow.
- I started the API server and saw it validate the configuration and load the `@hyperledger/cactus-plugin-keychain-memory` plugin.
- I ran a narrow test and captured a real Node 20 TypeScript execution problem: `ERR_UNKNOWN_FILE_EXTENSION` for `.ts`.
- I explored `cacti-demos` and confirmed that its SATP and oracle cases are driven by a top-level `Makefile`, but that the demo setup path expects Node `18.19.0` through `nvm`, while my current environment is Node `20.20.2`.

That evidence gives me a credible base for the application. Instead of claiming that I want to improve onboarding in the abstract, I can point to the exact friction I already hit.

## End-to-End Roadmap

### Phase 1: Explore and Validate the Main Repository

Objective: build enough technical confidence to write in my own words.

Actions:

- Read `README.md`, `BUILD.md`, `CONTRIBUTING.md`, `package.json`, and architecture docs.
- Map the monorepo layout: `packages/`, `examples/`, `extensions/`, `docs/`, and `weaver/`.
- Identify the contributor-critical commands instead of trying to understand every package at once.
- Record the gaps between documented flow and actual flow on my machine.

Expected output for the application:

- A concise explanation of what Cacti is.
- A concrete description of the build path and where the contributor experience currently breaks down.

### Phase 2: Finish Task 1, Clone + Build Cacti

Objective: produce build evidence, not just a claim that I can build it.

Actions:

1. Confirm the repository state and Node/npm versions.
2. Run `npm run enable-corepack`.
3. Run `yarn build:dev:backend` as the first reliable build checkpoint.
4. Run `npm run generate-api-server-config`.
5. Run `npm run start:api-server` and capture logs.
6. Run at least one targeted test and document the result honestly, even if it fails.

What I should emphasize in the application:

- Hyperledger Cacti is a pluggable interoperability framework created by merging Hyperledger Cactus and Weaver.
- The build step compiles the TypeScript backend, prepares runtime artifacts, and makes the API server and plugins loadable for local development.
- I already observed that some workflow steps are order-dependent, which is exactly the kind of usability issue this mentorship wants to improve.

### Phase 3: Finish Task 2, Run a Demo

Objective: prove I can move from core repo exploration into a practical interoperability use case.

Recommended demo:

- `make run-satp-case-1` from `cacti-demos`

Why I should choose it:

- It is directly aligned with the post-merger value of Cacti: decentralized, cross-network asset movement without a central settlement chain.
- It exposes the most important architectural pieces in one flow: local EVM chains, Dockerized gateway components, client contracts, SATP scripts, and audit/status checks.
- It is a stronger fit for this mentorship than a simpler oracle-only flow because it showcases the distinctive interoperability story of Cacti rather than just basic middleware access.

Execution notes:

- Before running the demo, align the Node runtime because the demo `Makefile` checks for Node `18.19.0` via `nvm`.
- Use a clean environment because the repo explicitly warns that stale contracts, containers, or ports will produce misleading results.
- Treat `make run-satp-case-1` as the primary automation path, but read `gateway/satp/case_1/README.md` to understand the five-terminal manual flow.

### Phase 4: Write the Cover Letter

Objective: connect my background to this specific mentorship without sounding generic.

The cover letter should cover exactly these four topics:

1. Why I am interested in Hyperledger Cacti and this mentorship in particular.
2. What relevant technical background I bring.
3. How my background maps to the specific goals of Issue #62.
4. How I would approach the project and contribute during the mentorship.

### Phase 5: Update the Resume

Objective: make the resume consistent with the evidence in the application.

Resume updates should include:

- Open-source contribution experience.
- Infrastructure and container orchestration experience.
- Practical build, CI, or developer tooling work.
- Any direct Cacti-related exploration or issue/PR activity that I can show before submission.

## Timeline

### Ideal Pre-Deadline Sequence

If executed before **April 15, 2026**, the plan should have been:

### Day 1

- Explore the repo structure and read core docs.
- Run the main build path and capture raw terminal evidence.
- Note every blocker while the commands are still fresh.

### Day 2

- Convert raw evidence into short, clean explanations.
- Draft the architecture overview.
- Explore `cacti-demos` and choose the SATP case.

### Day 3

- Run the chosen demo or, if blocked, document the exact blockers and remediation path.
- Capture screenshots and summarize what happened under the hood.

### Day 4

- Draft the cover letter in my own voice.
- Update the resume to align with the mentorship focus.
- Do a final consistency pass so the build story, architecture story, and cover letter reinforce each other.

### Immediate Catch-Up Sequence From April 16, 2026

Since the current date is **April 16, 2026**, I should compress the work into the next 24 to 48 hours:

### First 4 Hours

- Finish documenting Task 1 with the successful backend build and API-server evidence.
- Lock in `run-satp-case-1` as the primary demo recommendation.

### Next 4 Hours

- Verify the Node-version gap for the demo environment.
- Prepare demo commands, screenshot checkpoints, and a clean explanation of the expected outputs.

### Final 4 Hours

- Finalize the cover letter and resume updates.
- Make sure every paragraph is in my own words and consistent with the actual command results.

## Risk Management

### Risk 1: Writing in generic or borrowed language

Mitigation:

- Write only from command outputs, repo docs, and my own reasoning.
- Prefer concrete observations such as `config-service.js` missing before the backend build over vague language like "the build system is complex."

### Risk 2: Over-claiming demo completion

Mitigation:

- Distinguish clearly between what I have already run and what I have planned next.
- If the SATP demo is blocked by environment alignment, state that directly and explain the exact fix path.

### Risk 3: Missing technical depth

Mitigation:

- Explain the difference between Cactus-style API server/plugin orchestration and Weaver-style relay-based interoperability.
- Show that I understand why the merger matters for maintainability and contributor onboarding.

### Risk 4: Missing evidence

Mitigation:

- Save screenshots after each major checkpoint.
- Use descriptive filenames such as `screenshots/task1/01-corepack-enabled.png` and `screenshots/task2/02-satp-case1-status.png`.
- Pair every screenshot with one sentence explaining what it proves.

### Risk 5: Deadline pressure

Mitigation:

- Prioritize the evidence-heavy sections first: build, architecture understanding, and demo choice.
- If time is tight, submit a truthful application built around verified work rather than inflating incomplete work.

## Recommended Screenshot Plan

### Task 1 Screenshots

- `screenshots/task1/01-corepack-enabled.png`
  What it should show: `npm run enable-corepack` completed and Yarn 4.3.1 became available.

- `screenshots/task1/02-backend-build-success.png`
  What it should show: `yarn build:dev:backend` progressing through TypeScript projects and finishing the Lerna postbuild step.

- `screenshots/task1/03-api-server-startup.png`
  What it should show: configuration validation succeeded and the API server started loading plugins.

- `screenshots/task1/04-test-runtime-blocker.png`
  What it should show: `ERR_UNKNOWN_FILE_EXTENSION` from the `.ts` test run on Node 20.

### Task 2 Screenshots

- `screenshots/task2/01-make-help.png`
  What it should show: available SATP and oracle demo targets in `cacti-demos`.

- `screenshots/task2/02-satp-case1-readme.png`
  What it should show: the case overview and multi-terminal flow for SATP Case 1.

- `screenshots/task2/03-satp-case1-runtime.png`
  What it should show after execution: Hardhat nodes, gateway containers, and SATP session output.

- `screenshots/task2/04-satp-case1-audit-status.png`
  What it should show after execution: SATP session status or audit details.

## Short Paragraph for Task 1 Submission

Hyperledger Cacti is a modular interoperability framework that connects heterogeneous blockchain and DLT networks such as Fabric, Besu, Corda, and Ethereum without relying on a central settlement chain. The local build process prepares the TypeScript backend, generates the API-server runtime artifacts, and makes the plugin-based server stack runnable so contributors can test connectors, integrations, and cross-network workflows from a real development environment.

## Demo Reflection Draft

### What drew me to this demo?

I am most interested in the SATP Case 1 demo because it shows the interoperability problem that Cacti is designed to solve, not just a generic smart-contract interaction. It turns the post-merger vision into something concrete: two independent EVM chains, a gateway layer, and a protocol-driven asset transfer flow that avoids a central intermediary.

### What happened under the hood?

The demo starts two local Hardhat EVM networks, launches the SATP gateway components with Docker Compose, deploys token contracts and bridge-related logic, and then triggers SATP transaction scripts that coordinate burn-and-mint style asset movement across chains. After the transfer request is submitted, the gateway exposes status and audit data so I can inspect the session lifecycle rather than treating the transfer as a black box.

### What did I learn?

I learned that Cacti's interoperability story is not just about having multiple connectors; it depends on a carefully orchestrated runtime flow across local chains, gateway services, protocol steps, and audit/status endpoints. I also learned that contributor experience depends heavily on environment consistency, because even a strong demo path becomes fragile when Node-version assumptions, Docker state, or generated artifacts are not made explicit.

## Cover Letter Draft

Dear Hyperledger Cacti mentors,

I am applying for the LF Decentralized Trust 2026 mentorship on improving the usability, maintainability, and contributor experience of Hyperledger Cacti because this project sits at the intersection of the two things that motivate me most: practical systems engineering and meaningful open-source infrastructure. Cacti is not just another blockchain repository. It is an ambitious interoperability framework created from the merger of Hyperledger Cactus and Weaver, and that post-merger reality makes contributor experience especially important. The project needs people who are willing to understand how the system behaves today, identify where the friction actually is, and improve the path for the next contributor. That is exactly the kind of engineering work I want to do.

I am Harshit from Durg, India, and my background is strongest in infrastructure, container orchestration, and open-source driven engineering. I am most comfortable when I can move between system setup, runtime debugging, documentation gaps, and developer workflow improvements without treating them as separate problems. In practice, that means I pay close attention to how real build environments behave, how tooling assumptions drift, and how small workflow issues compound into onboarding friction for new contributors. I enjoy the kind of work where the result is not only cleaner code, but also a clearer path for other developers to build, run, understand, and extend the system.

That background maps directly to Issue #62. In my exploration of Cacti, I already saw the kinds of problems this mentorship is meant to tackle. I enabled Corepack and Yarn successfully, built the backend, generated API-server config, and started the API server locally. In doing that, I found a real workflow dependency: config generation failed before the backend build because the required runtime artifact was missing, then succeeded after the build. I also found a test-runtime issue on Node 20 where a TypeScript test failed with `ERR_UNKNOWN_FILE_EXTENSION`, and I found that the `cacti-demos` Makefile still assumes a Node 18.19.0 environment through `nvm`. Those are exactly the kinds of usability and maintainability issues that matter for onboarding, documentation quality, and architecture simplification.

If selected, I would approach the mentorship incrementally and evidence-first. I would begin by documenting the real contributor path from clone to first successful run, then reduce ambiguity in the build and demo workflows, then improve architecture documentation so contributors can connect high-level concepts to actual folders, packages, and runtime flows. From there, I would work on cleanup and simplification with a bias toward changes that reduce cognitive load for contributors: clearer module boundaries, better onboarding docs, explicit environment requirements, and removal or isolation of legacy paths that create confusion without adding enough value. I want my work on Cacti to make the project easier to understand, easier to contribute to, and easier to maintain after the mentorship ends.

Sincerely,

Harshit

## Resume Update Plan

Before submission, I should update the resume so it supports the narrative above.

Add or strengthen:

- Open-source contributions that show follow-through, not just interest.
- Infrastructure and container orchestration work, especially anything involving reproducible environments, CI/CD, Docker, or developer tooling.
- A short project bullet that references Hyperledger Cacti exploration, local build verification, API-server runtime validation, and SATP demo planning.
- Evidence of writing technical documentation or simplifying onboarding for others.

## Final Checklist

- Build story is based on commands I actually ran.
- Architecture story explains the Cactus and Weaver merger clearly.
- Demo choice is justified technically, not emotionally.
- Cover letter is written in my own words.
- Resume aligns with the same narrative.
- Every claimed result has either a command output or a screenshot behind it.
