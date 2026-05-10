# HYPERLEDGER CACTI: CI/CD REWORK & MONOREPO LOGIC
Generated: Sun May 10 04:08:48 PM IST 2026


--- FILE: lerna.json ---
```json
{
  "packages": [
    "packages/cactus-*",
    "examples/cactus-*",
    "extensions/cactus-*",
    "packages/cacti-*",
    "examples/cacti-*",
    "extensions/cacti-*",
    "weaver/common/protos-js",
    "weaver/sdks/fabric/interoperation-node-sdk",
    "weaver/sdks/besu/node",
    "weaver/core/drivers/fabric-driver",
    "weaver/core/identity-management/iin-agent",
    "weaver/samples/fabric/fabric-cli",
    "weaver/samples/besu/besu-cli",
    "weaver/samples/besu/simpleasset",
    "weaver/samples/besu/simplestate"
  ],
  "version": "2.1.0",
  "npmClient": "yarn",
  "useWorkspaces": "true",
  "command": {
    "version": {
      "message": "chore(release): publish"
    }
  },
  "changelogPreset": "angular"
}
```


--- FILE: tsconfig.base.json ---
```json
{
  "include": [
    "src",
    "src/**/*.json",
  ],
  "compilerOptions": {
    "paths": {
      "@hyperledger/cactus-*": ["./*/src"]
    },
    /* Basic Options */
    "incremental": true,                   /* Enable incremental compilation */
    "target": "ES2022", /* Specify ECMAScript target version: 'ES3' (default), 'ES5', 'ES2015', 'ES2016', 'ES2017', 'ES2018', 'ES2019' or 'ESNEXT'. */
    "module": "CommonJS", /* Specify module code generation: 'none', 'commonjs', 'amd', 'system', 'umd', 'es2015', or 'ESNext'. */
    "lib": [
      "ES2022",
      "dom"
    ], /* Specify library files to be included in the compilation. */
    // "allowJs": true,                       /* Allow javascript files to be compiled. */
    // "checkJs": true,                       /* Report errors in .js files. */
    // "jsx": "preserve",                     /* Specify JSX code generation: 'preserve', 'react-native', or 'react'. */
    "declaration": true, /* Generates corresponding '.d.ts' file. */
    // "declarationDir": "dist/types",
    // "declarationMap": true,                /* Generates a sourcemap for each corresponding '.d.ts' file. */
    // "sourceMap": true, /* Generates corresponding '.map' file. */
    // "outFile": "./",                       /* Concatenate and emit output to single file. */
    // "outDir": "./dist/lib/", 
    // "rootDir": "./",                       /* Specify the root directory of input files. Use to control the output directory structure with --outDir. */
    // "composite": true,                     /* Enable project compilation */
    // "tsBuildInfoFile": "./",               /* Specify file to store incremental compilation information */
    "removeComments": false,                /* Do not emit comments to output. */
    // "noEmit": true,                        /* Do not emit outputs. */
    // "importHelpers": true,                 /* Import emit helpers from 'tslib'. */
    // "downlevelIteration": true,            /* Provide full support for iterables in 'for-of', spread, and destructuring when targeting 'ES5' or 'ES3'. */
    // "isolatedModules": true,               /* Transpile each file as a separate module (similar to 'ts.transpileModule'). */
    /* Strict Type-Checking Options */
    "strict": true, /* Enable all strict type-checking options. */
    // "noImplicitAny": true,                 /* Raise error on expressions and declarations with an implied 'any' type. */
    // "strictNullChecks": true,              /* Enable strict null checks. */
    // "strictFunctionTypes": true,           /* Enable strict checking of function types. */
    // "strictBindCallApply": true,           /* Enable strict 'bind', 'call', and 'apply' methods on functions. */
    // "strictPropertyInitialization": true,  /* Enable strict checking of property initialization in classes. */
    // "noImplicitThis": true,                /* Raise error on 'this' expressions with an implied 'any' type. */
    // "alwaysStrict": true,                  /* Parse in strict mode and emit "use strict" for each source file. */
    /* Additional Checks */
    // "noUnusedLocals": true,                /* Report errors on unused locals. */
    // "noUnusedParameters": true,            /* Report errors on unused parameters. */
    // "noImplicitReturns": true,             /* Report error when not all code paths in function return a value. */
    // "noFallthroughCasesInSwitch": true,    /* Report errors for fallthrough cases in switch statement. */
    /* Module Resolution Options */
    "moduleResolution": "node", /* Specify module resolution strategy: 'node' (Node.js) or 'classic' (TypeScript pre-1.6). */
    "resolveJsonModule": true,            /* When true allows the importing of json files in Typescript code */
    // "baseUrl": "./",                       /* Base directory to resolve non-absolute module names. */
    // "paths": {},                           /* A series of entries which re-map imports to lookup locations relative to the 'baseUrl'. */
    // "rootDirs": [],                        /* List of root folders whose combined content represents the structure of the project at runtime. */
    "typeRoots": [
      "./node_modules/@types",
      "./typings"
    ],                                        /* List of folders to include type definitions from. */
    // "types": [],                           /* Type declaration files to be included in compilation. */
    // "allowSyntheticDefaultImports": true,  /* Allow default imports from modules with no default export. This does not affect code emit, just typechecking. */
    "esModuleInterop": true, /* Enables emit interoperability between CommonJS and ES Modules via creation of namespace objects for all imports. Implies 'allowSyntheticDefaultImports'. */
    // "preserveSymlinks": true,              /* Do not resolve the real path of symlinks. */
    // "allowUmdGlobalAccess": true,          /* Allow accessing UMD globals from modules. */
    /* Source Map Options */
    // "sourceRoot": "",                      /* Specify the location where debugger should locate TypeScript files instead of source locations. */
    // "mapRoot": "",                         /* Specify the location where debugger should locate map files instead of generated locations. */
    "inlineSourceMap": true,               /* Emit a single file with source maps instead of having a separate file. */
    // "inlineSources": true,                 /* Emit the source alongside the sourcemaps within a single file; requires '--inlineSourceMap' or '--sourceMap' to be set. */
    /* Experimental Options */
    // "experimentalDecorators": true,        /* Enables experimental support for ES7 decorators. */
    // "emitDecoratorMetadata": true,         /* Enables experimental support for emitting type metadata for decorators. */
    /* Advanced Options */
    "forceConsistentCasingInFileNames": true, /* Disallow inconsistently-cased references to the same file. */
    "skipLibCheck": true,
    "useUnknownInCatchVariables": false
  },
}
```


--- FILE: .github/actions/configure-repo/action.yaml ---
```yaml
name: Configure Action
description: "Sets up the repository with necessary configurations, caching dependencies and build outputs."

inputs:
  node_version:
    description: "Node.js version to use"
    required: true
  configure_desable:
    description: "Whether to run the configure step"
    required: false
    default: "false"
  yarn_hardened_mode:
    description: >-
      Whether to enable Yarn hardened mode,
      '1' to enable, '0' to disable.
      This is important to ensure cache integrity and defaults to '1'.
      See https://yarnpkg.com/features/security;
      it's recommended to enable it just once, when the CI pipeline runs multiple jobs.
    required: false
    default: "1"

runs:
  using: "composite"
  steps:
    # 1. Setup Node.js + yarn cache
    - name: Use Node.js ${{ inputs.node_version }}
      id: setup-node
      uses: actions/setup-node@6044e13b5dc448c55e2357c09f80417699197238 #v6.2.0
      with:
        cache: yarn
        cache-dependency-path: yarn.lock
        node-version: ${{ inputs.node_version }}

    # 2. Ensure Yarn exists (install only if it doesn't)
    - name: Ensure Yarn available (auto-install if missing)
      shell: bash
      run: |
        corepack enable

    - uses: actions/cache@v4
      with:
        path: ~/.cache/yarn
        key: ${{ runner.os }}-yarn-${{ hashFiles('yarn.lock') }}
        restore-keys: |
          ${{ runner.os }}-yarn-

    # 3. Install dependencies
    - name: Install dependencies
      run: YARN_ENABLE_HARDENED_MODE=${{ inputs.yarn_hardened_mode }} yarn install --immutable
      shell: bash

    # 4. Run configure command
    - name: Run configure (only if build cache not hit)
      if: ${{ inputs.configure_desable != 'true' }}
      run: YARN_ENABLE_HARDENED_MODE=${{ inputs.yarn_hardened_mode }} yarn configure
      shell: bash

```


--- FILE: .github/actions/jest-runner/action.yaml ---
```yaml
name: Jest Runner action
description: "Run Jest tests with optional code coverage"

inputs:
  run_code_coverage:
    description: "Whether to run tests with code coverage, 'true' or 'false'"
    required: true
  jest_test_pattern:
    description: "The Jest test pattern to run, e.g. 'packages/cactus-api-client/src/test/typescript/(unit|integration|benchmark)/.*/*.test.ts'"
    required: true
  jest_test_coverage_path:
    description: "The path to output Jest code coverage reports to, e.g. './code-coverage-ts/cactus-api-client'"
    required: false
  report_name:
    description: "The name of the report"
    required: false
    default: "jest-tests-report"
  github_secret:
    description: "GitHub secret for authentication"
    required: false

runs:
  using: "composite"
  steps:
    - name: Run Jest Tests (with coverage)
      if: ${{ inputs.run_code_coverage == 'true' }}
      shell: bash
      run: |
        yarn jest "${{ inputs.jest_test_pattern }}" \
          --coverage \
          --coverageDirectory="${{ inputs.jest_test_coverage_path }}" \
          --reporters=default \
          --reporters=jest-junit \
          --outputFile="reports/${{ inputs.report_name }}.xml" \
          --forceExit

    - name: Run Jest Tests (with coverage)
      if: ${{ inputs.run_code_coverage == 'true' }}
      shell: bash
      run: |
        mkdir -p reports
        export JEST_JUNIT_OUTPUT="reports/${{ inputs.report-name }}.xml"
        yarn jest "${{ inputs.jest_test_pattern }}" \
          --coverage \
          --coverageDirectory="${{ inputs.jest_test_coverage_path }}" \
          --reporters=default \
          --reporters=jest-junit \
          --forceExit
  
    - name: Report Jest test results
      if: >
        always() &&
        inputs.run_code_coverage == 'true' &&
        inputs.github_token != '' &&
        github.event.pull_request.head.repo.fork != true
      uses: dorny/test-reporter@v1
      with:
        name: "${{ inputs.report-name }}"
        path: "reports/${{ inputs.report-name }}.xml"  # matches JEST_JUNIT_OUTPUT
        reporter: jest-junit
        max-annotations: 0
        token: ${{ inputs.github_token }}              # passed in from the workflow
        fail-on-error: false
        fail-on-empty: true
        only-summary: false
        list-suites: failed
        list-tests: failed
        path-replace-backslashes: false

```


--- FILE: .github/instructions/workflows.instructions.md ---
```markdown
---
description: "Use when creating or modifying GitHub Actions workflows. Covers the CI call chain, reusable workflows, jest-runner action, test reporting, permissions model, and artifact conventions."
applyTo: ".github/workflows/**/*.yaml"
---
# GitHub Actions Workflow Conventions

## CI Architecture

Entry point is `ci.yaml`, triggered on PRs to `main`/`dev`, `workflow_dispatch`,
and a cron schedule. It fans out through reusable `workflow_call` workflows:

```
ci.yaml
├── checks-and-build.yaml        (lint, build, affected-package detection)
│   └── actionlint.yaml
├── code-quality-checks.yaml
├── packages-workflow.yaml        (fan-out by category)
│   ├── core-packages-workflow.yaml
│   ├── connector-packages-workflow.yaml
│   ├── keychain-packages-workflow.yaml
│   ├── other-packages-workflow.yaml
│   └── satp-hermes-workflow.yaml
├── examples-workflow.yaml
└── ghcr-workflow.yaml
```

Inputs propagated down the chain: `node_version`, `run_code_coverage`,
`run_trivy_scan`, `affected-packages`.

## Affected Package Detection

`checks-and-build.yaml` runs `tools/compute-affected-packages.cjs` against the
PR base ref and outputs a JSON array. Downstream jobs gate on it:

```yaml
if: contains(fromJson(inputs.affected-packages), 'packages/cactus-plugin-satp-hermes')
```

This skips unaffected packages. Always wire your new workflow into this pattern.

## Composite Actions (`.github/actions/`)

| Action | Purpose |
|--------|---------|
| `configure-repo` | Setup Node.js, Yarn install, `yarn configure` |
| `jest-runner` | Run Jest with optional coverage, JUnit XML, dorny/test-reporter |
| `docker-pull` | Pre-pull and cache Docker images for integration tests |
| `tape-runner` | Run Tape tests (legacy) |

## Test Reporting

`jest-runner` produces JUnit XML via `jest-junit` at `reports/<report_name>.xml`.
`dorny/test-reporter@v1` posts results to the PR Checks tab.

- Requires `checks: write` permission flowing from the top-level caller.
- Fork PRs are excluded (`github.event.pull_request.head.repo.fork != true`)
  because fork tokens lack write access.

## Permissions Model

Reusable workflows cannot escalate beyond what the caller grants. `ci.yaml`
must provide `actions: read`, `checks: write`, `contents: read` so downstream
workflows and composite actions can create check runs.

Propagation: `ci.yaml` → `packages-workflow` → `satp-hermes-workflow` → `jest-runner`.

## Action Pinning

Pin all third-party actions to full SHA. Comment the version tag for readability:

```yaml
uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 #v4.1.7
uses: actions/setup-node@6044e13b5dc448c55e2357c09f80417699197238 #v6.2.0
```

Never use floating tags like `@v4` or `@latest`.

## Artifact Conventions

- Upload with `actions/upload-artifact` (pinned SHA), use `if: always()` so
  reports survive failures.
- Coverage: `coverage-reports-<package-short>-<test-type>`
  (e.g., `coverage-reports-satp-hermes-unit`).
- JUnit: `reports/<report-name>.xml`.
- Foundry: `satp-foundry-report-<job>`.

## Concurrency

Every workflow must set `concurrency:` with a group key scoped to the workflow
and PR number, plus `cancel-in-progress: true`:

```yaml
concurrency:
  group: <workflow-slug>-${{ github.workflow }}-${{ github.event.pull_request.number || github.ref }}
  cancel-in-progress: true
```

## SATP Hermes Specifics

`satp-hermes-workflow.yaml` defines 8 parallel test jobs: unit, bridge, oracle,
gateway, docker, on-chain (Foundry), recovery, rollback. It also supports
`workflow_dispatch` for manual runs. Each integration job pre-pulls ledger
images with the `docker-pull` action and runs `./tools/ci-env-clean-up.sh`
before tests.

## Best Practices

- Use `continue-on-error: true` on test jobs to avoid blocking the pipeline.
- Use `if: always()` on artifact upload steps to preserve reports on failure.
- Pre-pull Docker images with `docker-pull` action to speed up integration tests.
- Run `./tools/ci-env-clean-up.sh` before Docker-based integration tests.
- Runner: `ubuntu-22.04` for all jobs.
- Node version is centrally defined in `ci.yaml` as `v20.20.0` and threaded
  through inputs — never hardcode it in downstream workflows.

```


--- FILE: tools/compute-affected-packages.cjs ---
```javascript
#!/usr/bin/env node
/**
 * Computes affected workspace packages for a PR/commit.
 * 1. Scans packages/ examples/ extensions/ for package.json files.
 * 2. Builds a reverse dependency graph (who depends on whom).
 * 3. Diffs the current HEAD against a base ref (default origin/main) and:
 *    - If .github/ changed -> all packages affected.
 *    - Ignores pure docs or comment/whitespace-only changes.
 * 4. Finds directly changed packages and recursively adds their dependents.
 * 5. Outputs a JSON array of affected package directories (for CI matrix).
 */
const os = require("os");

const fs = require("fs");

const path = require("path");

const { execSync } = require("child_process");

const WORKSPACE_DIR = ["packages", "examples", "extensions"]; // change if needed

// --- 1. Collect all workspace package.json files ---
function getAllPackages() {
  const packages = {};
  for (const dir of WORKSPACE_DIR) {
    const dirs = fs.readdirSync(dir);

    for (const name of dirs) {
      const pkgPath = path.join(dir, name, "package.json");
      if (!fs.existsSync(pkgPath)) continue;

      const json = JSON.parse(fs.readFileSync(pkgPath, "utf8"));
      packages[json.name] = {
        name: json.name,
        dir: path.join(dir, name),
        pkg: json,
      };
    }
  }

  return packages;
}

// --- 2. Build reverse dependency graph: package -> dependents[] ---
function buildDependentsGraph(packages) {
  const dependents = {};

  for (const pkg of Object.values(packages)) {
    dependents[pkg.name] = new Set();
  }

  for (const pkg of Object.values(packages)) {
    for (const depName of Object.keys(pkg.pkg.dependencies || {})) {
      if (packages[depName]) {
        dependents[depName].add(pkg.name);
      }
    }
    for (const depName of Object.keys(pkg.pkg.devDependencies || {})) {
      if (packages[depName]) {
        dependents[depName].add(pkg.name);
      }
    }
  }
  return dependents;
}

function detectChangedPackages(packages) {
  const baseRef = process.argv[2] || "origin/main";

  try {
    execSync(`git fetch origin ${baseRef.replace("origin/", "")}`, {
      stdio: "inherit",
    });
  } catch (err) {
    console.error("Failed to fetch base branch:", baseRef);
    throw err;
  }

  const tmpFile = path.join(os.tmpdir(), `changed-files-${process.pid}.txt`);

  execSync(`git diff --name-only origin/main...HEAD > "${tmpFile}"`, {
    stdio: ["ignore", "inherit", "inherit"],
  });

  const changedFiles = fs
    .readFileSync(tmpFile, "utf8")
    .split("\n")
    .filter(Boolean);
  fs.unlinkSync(tmpFile);

  if (changedFiles.some((f) => f.startsWith(".github/"))) {
    return Object.keys(packages);
  }

  // Docs-only detection
  const isDocFile = (f) =>
    f.endsWith(".md") ||
    f.endsWith(".mdx") ||
    f.includes("/docs/") ||
    f.startsWith("docs/") ||
    f.startsWith("documentation/");

  const onlyDocsFiles = changedFiles.every(isDocFile);

  // If all changed files are docs, ignore diff content entirely
  if (onlyDocsFiles) {
    console.warn("Only documentation changes detected.");
    return [];
  }

  // Full diff for comment detection (stream to file to avoid ENOBUFS)
  const tmpDiffFile = path.join(os.tmpdir(), `full-diff-${process.pid}.txt`);

  execSync(`git diff ${baseRef} HEAD > "${tmpDiffFile}"`, {
    stdio: ["ignore", "inherit", "inherit"],
  });

  const diff = fs.readFileSync(tmpDiffFile, "utf8");
  fs.unlinkSync(tmpDiffFile);

  /**
   * Regex: identifies added/removed lines that are REAL CODE.
   *
   * A real code line starts with + or - (but not ++ or -- from diff headers)
   **/

  const realCodeChangeRegex =
    /^[-+](?![-+])(?!\s*$|\s*\/\/.*$|\s*\/\*.*\*\/\s*$|\s*#.*$|\s*--.*$|\s*;.*$|\s*<!--.*?-->\s*$).+/m;

  const normalizedDiff = diff
    .split("\n")
    .map((line) => line.trimStart())
    .join("\n");

  const codeWasModified = realCodeChangeRegex.test(normalizedDiff);

  // If everything changed is docs, return []
  if (onlyDocsFiles) {
    console.warn("Only documentation changes detected.");
    return [];
  }

  // If code was not modified at all, return []
  if (!codeWasModified) {
    console.warn("Only comment/whitespace changes detected.");
    return [];
  }
  // Find changed packages
  const changed = new Set();

  for (const file of changedFiles) {
    for (const pkg of Object.values(packages)) {
      if (file.startsWith(pkg.dir)) {
        changed.add(pkg.name);
      }
    }
  }

  return [...changed];
}

// --- 4. Expand to dependent packages recursively ---
function findAllAffected(changed, dependents) {
  const affected = new Set(changed);
  const queue = [...changed];

  while (queue.length) {
    const current = queue.pop();

    for (const dep of dependents[current] || []) {
      if (!affected.has(dep)) {
        affected.add(dep);
        queue.push(dep);
      }
    }
  }

  return [...affected];
}

// --- MAIN ---
const packages = getAllPackages();

if (process.argv[2] === "true") {
  const affectedDirs = packages.map((pkgName) => packages[pkgName].dir);
  process.stdout.write(JSON.stringify(affectedDirs));
  process.exit(0);
}

console.warn("Detected packages:", Object.keys(packages));
const dependents = buildDependentsGraph(packages);
console.warn(
  "Built dependents graph.",
  Object.keys(dependents).length,
  "packages.",
);
const changed = detectChangedPackages(packages);
console.warn("Changed packages:", changed);
console.warn(Object.keys(dependents).length, "packages changed.");
const affected = findAllAffected(changed, dependents);
console.warn("Affected packages:", affected);
console.warn(affected.length, "packages affected.");

// --- Output dirs instead of package names ---
const affectedDirs = affected.map((pkgName) => packages[pkgName].dir);

// Output JSON for GitHub matrix
console.warn("Affected package dirs:", JSON.stringify(affectedDirs));
process.stdout.write(JSON.stringify(affectedDirs));
process.exit(0);

```
