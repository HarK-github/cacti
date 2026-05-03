# Hyperledger Cacti Mentorship Application Progress Tracker
Clone + Build Cacti

 Task 1 — Clone the repository, follow the build instructions in BUILD.md, and tell us what happened.

Include a short paragraph (your own words) explaining what Hyperledger Cacti is and what the build process does, plus at least 2 screenshots showing your progress.

There is no single correct outcome, we are interested in how you approach an unfamiliar codebase. 
Run a Cacti Demo

 Task 2 — Run a Cacti Demo End to End

Pick any demo from github.com/hyperledger-cacti/cacti-demos, run it end to end, and tell us about it. Answer three questions in your own words:

- What drew you to this demo?
- What happened under the hood? Describe what the demo is actually doing at a technical level.
- What did you learn? One or two concrete takeaways.

Include at least 2 screenshots showing the demo running or its output.
## Status Legend

- `Completed`: I ran the task or validated the output directly.
- `In Progress`: I started the task and have concrete evidence, but more work remains.
- `Planned`: I have the exact path and commands ready, but I have not finished execution yet.
- `Blocked`: I hit a real technical issue that needs resolution before the task can be considered complete.

## Progress Table

| Task | Status | Evidence (screenshots / links / outputs) | Next Action | Blockers |
| --- | --- | --- | --- | --- |
| Repository exploration | Completed | `ls -la` confirmed monorepo layout with `packages/`, `examples/`, `extensions/`, `docs/`, and `weaver/`; `README.md`, `BUILD.md`, `CONTRIBUTING.md`, and docs architecture files reviewed | Keep using the repo map when writing the application and cover letter | None |
| Corepack and Yarn bootstrap | Completed | `npm run enable-corepack` succeeded; output included `Preparing yarn@4.3.1 for immediate activation...`; `yarn --version` returned `4.3.1` | Reference this as the first successful build checkpoint | None |
| Main repo backend build | Completed | `yarn build:dev:backend` compiled the TypeScript project graph and finished `build:dev:backend:postbuild` for multiple packages; screenshot target: `screenshots/task1/02-backend-build-success.png` | Optionally run broader build targets later if more demo work depends on them | Full `yarn run configure` remains low-observability and warning-heavy |
| API config generation | Completed | First attempt failed with `ERR_MODULE_NOT_FOUND` for `packages/cactus-cmd-api-server/dist/.../config-service.js`; second attempt succeeded after backend build and wrote `.config.json` | Mention this ordering dependency explicitly in the application | Hidden dependency between build and config generation is not obvious in docs |
| API server runtime validation | Completed | `npm run start:api-server` logged `Configuration validation OK` and began loading `@hyperledger/cactus-plugin-keychain-memory`; screenshot target: `screenshots/task1/03-api-server-startup.png` | Use this as proof that the build artifacts are runnable, not just compiled | Long-running process was manually stopped after successful startup confirmation |
| Narrow unit test validation | Blocked | `timeout 60s npx tap --ts --timeout=600 packages/cactus-common/src/test/typescript/unit/bools.test.ts` failed with `TypeError [ERR_UNKNOWN_FILE_EXTENSION]: Unknown file extension ".ts"` on Node `v20.20.2`; screenshot target: `screenshots/task1/04-test-runtime-blocker.png` | Investigate the intended TS loader path for tap tests, likely via repo scripts or Node version alignment | Node 20 TypeScript runtime mismatch for direct `.ts` test execution |
| Task 1 application paragraph | Completed | Drafted in `docs/project_approach.md` under `Short Paragraph for Task 1 Submission` | Reuse directly in the application form or lightly tailor it to final character limits | None |
| `cacti-demos` repository fetch | Completed | `git clone https://github.com/hyperledger-cacti/cacti-demos.git /tmp/cacti-demos` succeeded | Continue using the local clone for demo-command planning | None |
| Demo repo target discovery | Completed | `make help` listed `run-satp-case-1`, `run-satp-case-2`, `run-satp-case-3`, and oracle targets; `README.md` and `gateway/satp/case_1/README.md` reviewed | Lock `run-satp-case-1` as the recommended application demo | None |
| Demo environment validation | In Progress | Local environment has Node `v20.20.2`, npm `10.8.2`, Python `3.13.5`, Docker `29.3.0`, Docker Compose `v5.1.0`; demo `Makefile` expects `nvm` and Node `18.19.0` for setup/check-node | Switch demo shell to Node `18.19.0` before attempting `make run-satp-case-1` | Cross-repo Node version mismatch between main repo and demo repo |
| Task 2 demo choice | Completed | Selected `make run-satp-case-1` because it best demonstrates cross-network interoperability, gateway orchestration, and SATP session flow | Execute the case in a clean environment and capture outputs | Node version alignment still needed before full run |
| Task 2 exact commands | Planned | Planned command sequence: `cd /tmp/cacti-demos`; optionally `make clean`; ensure Node `18.19.0`; `make run-satp-case-1`; if debugging manually, follow `gateway/satp/case_1/README.md` with Hardhat nodes, Docker Compose, token deployment, `satp-transact.py`, status, and audit scripts | Run the Make target end-to-end and save session/audit outputs | Node version mismatch and need for a clean Docker/port state |
| Task 2 narrative answers | Completed | Drafted in `docs/project_approach.md` under `Demo Reflection Draft` | Reuse in the application after the live run confirms the final wording | None |
| Cover letter draft | Completed | Full draft written in `docs/project_approach.md` under `Cover Letter Draft` | Tailor formatting and greeting to the final application portal if needed | None |
| Resume update plan | Completed | Resume action list written in `docs/project_approach.md` under `Resume Update Plan` | Apply the updates to the actual resume file before upload | Need to ensure the resume reflects only verified claims |

## Recommended Task 1 Command Sequence

```bash
cd /home/harshit-kandpal/Documents/github_files/cacti
git status --short --branch
ls -la
npm --version
node --version
npm run enable-corepack
yarn --version
yarn build:dev:backend
npm run generate-api-server-config
npm run start:api-server
timeout 60s npx tap --ts --timeout=600 packages/cactus-common/src/test/typescript/unit/bools.test.ts
```

## Recommended Task 1 Screenshot Checkpoints

1. `screenshots/task1/01-corepack-enabled.png`
   Capture after Corepack/Yarn activation.
2. `screenshots/task1/02-backend-build-success.png`
   Capture near the end of `yarn build:dev:backend`.
3. `screenshots/task1/03-api-server-startup.png`
   Capture when configuration validation succeeds and plugin loading begins.
4. `screenshots/task1/04-test-runtime-blocker.png`
   Capture the `.ts` loader error from the tap command.

## Recommended Task 2 Command Sequence

```bash
cd /tmp/cacti-demos
make help
make clean
# switch shell to Node 18.19.0 through nvm before the next step
make run-satp-case-1
```

## If I Need the Manual SATP Case 1 Flow Instead of the Makefile

```bash
cd /tmp/cacti-demos/gateway/satp/case_1

# Terminal 1
docker compose up

# Terminal 2
cd ../../../EVM && npx hardhat node --hostname 0.0.0.0 --port 8545

# Terminal 3
cd ../../../EVM && npx hardhat node --hostname 0.0.0.0 --port 8546

# Terminal 4
cd ../../../EVM && node scripts/SATPTokenContract.js

# Terminal 5
python3 satp-evm-get-integrations.py
python3 satp-transact.py
python3 satp-evm-check-status.py <SESSION_ID>
python3 satp-evm-perform-audit.py
```

## Recommended Task 2 Screenshot Checkpoints

1. `screenshots/task2/01-make-help.png`
   Show the available SATP and oracle demo targets.
2. `screenshots/task2/02-satp-case1-readme.png`
   Show the SATP Case 1 workflow description.
3. `screenshots/task2/03-satp-case1-runtime.png`
   Show Hardhat nodes plus gateway startup during the live run.
4. `screenshots/task2/04-satp-case1-audit-status.png`
   Show either a successful session status or audit output.

## Short Notes for Final Submission

### What Hyperledger Cacti is

Hyperledger Cacti is a post-merger interoperability framework that combines the plugin-oriented runtime model of Hyperledger Cactus with the protocol- and relay-oriented interoperability model of Weaver. It is designed to let independent ledger networks interact securely without relying on a central settlement chain.

### What the build does

The local build compiles the TypeScript backend across the monorepo, produces the runtime artifacts needed by the API server, and enables plugin-based services to start locally. In practice, that means the build is not just a packaging step; it is the point where the server-side execution path becomes usable for development and testing.

## AI & CLI Validation Notes

- Ran `pwd` and confirmed the main Cacti repo path is `/home/harshit-kandpal/Documents/github_files/cacti`.
- Ran `ls -la` in the main repo and confirmed the post-merger layout with `packages/`, `examples/`, `extensions/`, `docs/`, and `weaver/`.
- Ran `git status --short --branch` and preserved unrelated local changes without modifying them.
- Ran `cat BUILD.md`, `cat README.md | head -n 100`, and `rg -n "(yarn|lerna|npm run|make )" BUILD.md` to extract the documented contributor flow.
- Ran `npm --version` and `node --version`, which returned `10.8.2` and `v20.20.2`.
- Analyzed `BUILD.md` with Proxima using ChatGPT and Perplexity; both highlighted that the Linux section is incomplete and that the real contributor path is `enable-corepack` followed by `configure`.
- Analyzed `CONTRIBUTING.md`, `package.json`, `docs/README.md`, `docs/docs/architecture.md`, and `docs/docs/vision.md` with Proxima to map the repo layout, build system, and post-merger architecture story.
- Used Proxima deep search for `build`, `onboarding`, `deprecated modules`, `documentation structure`, `SATP`, and `connector` to align the application plan with the cleanup and contributor-experience theme of Issue #62.
- Ran `npm run enable-corepack`, which succeeded and activated Yarn `4.3.1`.
- Ran `yarn run configure`; it produced many peer-dependency warnings and poor observability, which is now captured as a contributor-experience pain point.
- Ran `yarn build:dev:backend`, which completed successfully and produced the missing `config-service.js` artifact.
- Ran `npm run generate-api-server-config` before and after the backend build; the first run failed due to a missing compiled artifact, and the second run succeeded and wrote `.config.json`.
- Ran `npm run start:api-server` and confirmed real startup logs including configuration validation and plugin loading.
- Ran a narrow tap test with `timeout 60s npx tap --ts --timeout=600 packages/cactus-common/src/test/typescript/unit/bools.test.ts`; it failed with `ERR_UNKNOWN_FILE_EXTENSION`, which is now documented honestly as a current blocker.
- Cloned `cacti-demos`, ran `make help`, inspected the top-level `Makefile`, `README.md`, and `gateway/satp/case_1/README.md`, and selected `run-satp-case-1` as the strongest demo for the application.
- ChatGPT feedback reinforced that the final documents should be evidence-first and explicit about build-order, Node-version, and TypeScript-runtime issues; Perplexity reinforced that the tracker should read like a real engineering dashboard rather than a generic plan.
- The plan is now ready for immediate execution as a production-grade application aid: it has a verified build story, a justified demo choice, a full cover-letter draft, a resume update plan, and an honest record of current blockers.
