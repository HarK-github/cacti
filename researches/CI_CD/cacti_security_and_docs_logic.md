# HYPERLEDGER CACTI: SECURITY, CUSTOM CHECKS, AND DOCS
Generated: Sun May 10 03:55:05 PM IST 2026


--- FILE: .github/workflows/actionlint.yaml ---
```yaml
name: Lint GitHub Actions workflows
on:
  workflow_call:

jobs:
  Lint_GitHub_Actions:
    runs-on: ubuntu-22.04
    steps:
    - name: git_clone
      uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 #v4.1.7

    # We need to wipe the root package.json file because the installation of actionlint fails otherwise like this:
    #
    # npm ERR! code ERESOLVE
    # npm ERR! ERESOLVE could not resolve
    # npm ERR! 
    # npm ERR! While resolving: react-scripts@5.0.1
    # npm ERR! Found: typescript@5.3.3
    # npm ERR! node_modules/typescript
    # npm ERR!   dev typescript@"5.3.3" from the root project
    # npm ERR!   peerOptional typescript@">=3.7.2" from tap@16.3.8
    # npm ERR!   node_modules/tap
    # npm ERR!     dev tap@"16.3.8" from the root project
    # npm ERR!   25 more (ts-jest, @hyperledger/cactus-plugin-satp-hermes, ...)
    # npm ERR! 
    # npm ERR! Could not resolve dependency:
    # npm ERR! peerOptional typescript@"^3.2.1 || ^4" from react-scripts@5.0.1
    # npm ERR! node_modules/react-scripts
    # npm ERR!   react-scripts@"5.0.1" from @hyperledger/cacti-example-cbdc-bridging-frontend
    # npm ERR!   examples/cactus-example-cbdc-bridging-frontend
    # npm ERR!     @hyperledger/cacti-example-cbdc-bridging-frontend
    # npm ERR!     node_modules/@hyperledger/cacti-example-cbdc-bridging-frontend
    # npm ERR!       workspace examples/cactus-example-cbdc-bridging-frontend from the root project
    # npm ERR! 
    # npm ERR! Conflicting peer dependency: typescript@4.9.5
    # npm ERR! node_modules/typescript
    # npm ERR!   peerOptional typescript@"^3.2.1 || ^4" from react-scripts@5.0.1
    # npm ERR!   node_modules/react-scripts
    # npm ERR!     react-scripts@"5.0.1" from @hyperledger/cacti-example-cbdc-bridging-frontend
    # npm ERR!     examples/cactus-example-cbdc-bridging-frontend
    # npm ERR!       @hyperledger/cacti-example-cbdc-bridging-frontend
    # npm ERR!       node_modules/@hyperledger/cacti-example-cbdc-bridging-frontend
    # npm ERR!         workspace examples/cactus-example-cbdc-bridging-frontend from the root project
    # npm ERR! 
    # npm ERR! Fix the upstream dependency conflict, or retry
    # npm ERR! this command with --force or --legacy-peer-deps
    # npm ERR! to accept an incorrect (and potentially broken) dependency resolution.
    - name: wipe_non_yaml_sources
      run: rm -rf packages/ examples/ extensions/ package.json weaver/ node_modules/

    # Shellcheck comlains that inside single quotes
    # the environment variables are not expanded, but that's exactly what we want here because
    # we are replacing environment variables inside the configuration file.
    # The only way we know how to ignore a file is to delete it...
    - name: wipe_files_with_false_positives
      run: rm .github/workflows/all-nodejs-packages-publish.yaml

    # We need to exclude these from the linting process for now because these files have 
    # hundreds of linter errors that we didn't yet have time to fix. Once the errors are fixed
    # we can add the files.
    - name: Set env.CACTI_ACTIONLINT_FILES_TO_LINT
      id: set_env_cacti_actionlint_files_to_lint
      run: |
          echo "CACTI_ACTIONLINT_FILES_TO_LINT=$(find .github/workflows/ -name "*.yml" -o -name "*.yaml" ! -name "*weaver*" -exec echo -n '{},' \;)" >> "$GITHUB_ENV"

    - name: Print env.CACTI_ACTIONLINT_FILES_TO_LINT
      id: print_env_cacti_actionlint_files_to_lint
      run: |
          echo "${{ env.CACTI_ACTIONLINT_FILES_TO_LINT }}" 

    - name: Print Line-byLine env.CACTI_ACTIONLINT_FILES_TO_LINT
      id: print_line_by_line_env_cacti_actionlint_files_to_lint
      run: |
          echo "${{ env.CACTI_ACTIONLINT_FILES_TO_LINT }}" | tr ',' '\n'

    - name: actionlint
      id: actionlint
      uses: raven-actions/actionlint@e01d1ea33dd6a5ed517d95b4c0c357560ac6f518 #v2.1.1
      with:
        cache: true
        files: ${{ env.CACTI_ACTIONLINT_FILES_TO_LINT }}
        flags: '--verbose'

    - name: actionlint_summary
      if: ${{ steps.actionlint.outputs.exit-code != 0 }} # example usage, do echo only when actionlint action failed
      run: |
        echo "Used actionlint version ${{ steps.actionlint.outputs.version-semver }}"
        echo "Used actionlint release ${{ steps.actionlint.outputs.version-tag }}"
        echo "actionlint ended with ${{ steps.actionlint.outputs.exit-code }} exit code"
        echo "actionlint ended because '${{ steps.actionlint.outputs.exit-message }}'"
        echo "actionlint found ${{ steps.actionlint.outputs.total-errors }} errors"
        echo "actionlint checked ${{ steps.actionlint.outputs.total-files }} files"
        echo "actionlint cache used: ${{ steps.actionlint.outputs.cache-hit }}"
        echo "${{ steps.actionlint.outputs.exit-code }}" >&2
        exit 1

```


--- FILE: .github/workflows/codeql-analysis.yml ---
```yaml
name: "CodeQL"

on:
  push:
    branches: [main]
  pull_request:
    # The branches below must be a subset of the branches above
    branches: [main]
  schedule:
    - cron: '0 11 * * 1'

concurrency:
  group: ${{ github.workflow }}-${{ github.event.pull_request.number || github.ref }}
  cancel-in-progress: true

jobs:
  analyze:
    name: Analyze
    runs-on: ubuntu-22.04

    strategy:
      fail-fast: false
      matrix:
        # Override automatic language detection by changing the below list
        # Supported options are ['csharp', 'cpp', 'go', 'java', 'javascript', 'python']
        language: ['typescript']
        # Learn more...
        # https://docs.github.com/en/github/finding-security-vulnerabilities-and-errors-in-your-code/configuring-code-scanning#overriding-automatic-language-detection

    steps:
    - name: Checkout repository
      uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 #v4.1.7
      with:
        # We must fetch at least the immediate parents so that if this is
        # a pull request then we can checkout the head.
        fetch-depth: 2

    # If this run was triggered by a pull request event, then checkout
    # the head of the pull request instead of the merge commit.
    - run: git checkout HEAD^2
      if: ${{ github.event_name == 'pull_request' }}

    # Initializes the CodeQL tools for scanning.
    - name: Initialize CodeQL
      uses: github/codeql-action/init@b8d3b6e8af63cde30bdc382c0bc28114f4346c88 #v2
      with:
        languages: ${{ matrix.language }}
        # If you wish to specify custom queries, you can do so here or in a config file.
        # By default, queries listed here will override any specified in a config file.
        # Prefix the list here with "+" to use these queries and those in the config file.
        # queries: ./path/to/local/query, your-org/your-repo/queries@main

    # Autobuild attempts to build any compiled languages  (C/C++, C#, or Java).
    # If this step fails, then you should remove it and run the build manually (see below)
    - name: Autobuild
      uses: github/codeql-action/autobuild@b8d3b6e8af63cde30bdc382c0bc28114f4346c88 #v2

    # ℹ️ Command-line programs to run using the OS shell.
    # 📚 https://git.io/JvXDl

    # ✏️ If the Autobuild fails above, remove it and uncomment the following three lines
    #    and modify them (or add more) to build your code if your project
    #    uses a compiled language

    #- run: |
    #   make bootstrap
    #   make release

    - name: Perform CodeQL Analysis
      uses: github/codeql-action/analyze@b8d3b6e8af63cde30bdc382c0bc28114f4346c88 #v2

```


--- FILE: .github/workflows/scorecard.yml ---
```yaml
# Copyright the Hyperledger Cacti contributors. All rights reserved.
#
# SPDX-License-Identifier: Apache-2.0

# This workflow uses actions that are not certified by GitHub. They are provided
# by a third-party and are governed by separate terms of service, privacy
# policy, and support documentation.

name: OpenSSF Scorecard
on:
  # For Branch-Protection check. Only the default branch is supported. See
  # https://github.com/ossf/scorecard/blob/main/docs/checks.md#branch-protection
  branch_protection_rule:
  # To guarantee Maintained check is occasionally updated. See
  # https://github.com/ossf/scorecard/blob/main/docs/checks.md#maintained
  schedule:
    - cron: '30 2 * * 6'
  push:
    branches: [ "main" ]

# Declare default permissions as read only.
permissions: read-all

jobs:
  analysis:
    name: Scorecard analysis
    runs-on: ubuntu-latest
    permissions:
      # Needed to upload the results to code-scanning dashboard.
      security-events: write
      # Needed to publish results and get a badge (see publish_results below).
      id-token: write
      # Uncomment the permissions below if installing in a private repository.
      # contents: read
      # actions: read

    steps:
      - name: "Checkout code"
        uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11 # v4.1.1
        with:
          persist-credentials: false

      - name: "Run analysis"
        uses: ossf/scorecard-action@0864cf19026789058feabb7e87baa5f140aac736 # v2.3.1
        with:
          results_file: results.sarif
          results_format: sarif
          # (Optional) "write" PAT token. Uncomment the `repo_token` line below if:
          # - you want to enable the Branch-Protection check on a *public* repository, or
          # - you are installing Scorecard on a *private* repository
          # To create the PAT, follow the steps in https://github.com/ossf/scorecard-action?tab=readme-ov-file#authentication-with-fine-grained-pat-optional.
          # repo_token: ${{ secrets.SCORECARD_TOKEN }}

          # Public repositories:
          #   - Publish results to OpenSSF REST API for easy access by consumers
          #   - Allows the repository to include the Scorecard badge.
          #   - See https://github.com/ossf/scorecard-action#publishing-results.
          # For private repositories:
          #   - `publish_results` will always be set to `false`, regardless
          #     of the value entered here.
          publish_results: true

      # Upload the results as artifacts (optional). Commenting out will disable uploads of run results in SARIF
      # format to the repository Actions tab.
      - name: "Upload artifact"
        uses: actions/upload-artifact@97a0fba1372883ab732affbe8f94b823f91727db # v3.pre.node20
        with:
          name: SARIF file
          path: results.sarif
          retention-days: 5

      # Upload the results to GitHub's code scanning dashboard (optional).
      # Commenting out will disable upload of results to your repo's Code Scanning dashboard
      - name: "Upload to code-scanning"
        uses: github/codeql-action/upload-sarif@1b1aada464948af03b950897e5eb522f92603cc2 # v3.24.9
        with:
          sarif_file: results.sarif


```


--- FILE: tools/custom-checks/run-custom-checks.ts ---
```typescript
import esMain from "es-main";
import { checkOpenApiJsonSpecs } from "./check-open-api-json-specs";
import { checkPackageJsonSort } from "./check-package-json-sort";
import { checkCommonPackageFields } from "./check-package-json-fields";
import { checkSiblingDepVersionConsistency } from "./check-sibling-dep-version-consistency";

import {
  ICheckMissingNodeDepsRequest,
  checkMissingNodeDeps,
} from "./check-missing-node-deps";
import { getAllPkgDirs } from "./get-all-pkg-dirs";
import { runAttwOnTgz } from "./run-attw-on-tgz";
import { checkDependencyVersionConsistency } from "./check-dependency-version-consistency";

export async function runCustomChecks(
  argv: string[],
  env: NodeJS.ProcessEnv,
  version: string,
): Promise<void> {
  const TAG = "[tools/custom-checks/run-custom-checks.ts]";
  let overallSuccess = true;
  let overallErrors: string[] = [];

  console.log(`${TAG} Current NodeJS version is v${version}`);

  {
    const [success, errors] = await checkOpenApiJsonSpecs({ argv, env });
    overallErrors = overallErrors.concat(errors);
    overallSuccess = overallSuccess && success;
  }

  {
    const req = { argv, env };
    const [success, errors] = await checkSiblingDepVersionConsistency(req);
    overallErrors = overallErrors.concat(errors);
    overallSuccess = overallSuccess && success;
  }

  {
    const req = { argv, env };
    const [success, errors] = await checkPackageJsonSort(req);
    overallErrors = overallErrors.concat(errors);
    overallSuccess = overallSuccess && success;
  }

  {
    const [success, errors] = await checkCommonPackageFields({ argv, env });
    overallErrors = overallErrors.concat(errors);
    overallSuccess = overallSuccess && success;
  }

  {
    const { absolutePaths: pkgDirsToCheck } = await getAllPkgDirs();

    const req: ICheckMissingNodeDepsRequest = {
      pkgDirsToCheck,
    };
    const [success, errors] = await checkMissingNodeDeps(req);
    overallErrors = overallErrors.concat(errors);
    overallSuccess = overallSuccess && success;
  }

  {
    const [success, errors] = await checkDependencyVersionConsistency();
    overallErrors = overallErrors.concat(errors);
    overallSuccess = overallSuccess && success;
  }

  {
    const [success, errors] = await runAttwOnTgz();
    overallErrors = overallErrors.concat(errors);
    overallSuccess = overallSuccess && success;
  }

  if (!overallSuccess) {
    overallErrors.forEach((it) => console.error(it));
  } else {
    console.log(`${TAG} All Checks Passed OK.`);
  }
  const exitCode = overallSuccess ? 0 : 100;
  process.exit(exitCode);
}

if (esMain(import.meta)) {
  runCustomChecks(process.argv, process.env, process.versions.node);
}

```


--- FILE: .github/workflows/deploy_docs.yml ---
```yaml
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: CC-BY-4.0

name: Deploy Docs (Github Pages)

on:
  push:
    branches:
      - main

    paths:
      - 'docs/**'
      - 'packages/cactus-plugin-satp-hermes/docs/**'

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:
  
env:
  SITE_URL: https://${{ github.repository_owner }}.github.io/cacti
  NODEJS_VERSION: v20.20.0
  GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}


jobs:
  deploy-docs:
    runs-on: ubuntu-22.04
    permissions:
      contents: write
      pages: write
    steps:
      - name: Use Node.js ${{ env.NODEJS_VERSION }}
        uses: actions/setup-node@1e60f620b9541d16bece96c5465dc8ee9832be0b #v4.0.3
        with:
          node-version: ${{ env.NODEJS_VERSION }}

      # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
      - uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 #v4.1.7

      - name: Use Python 3.x
        uses: actions/setup-python@d09bd5e6005b175076f227b13d9730d56e9dcfcb #v4
        with:
          python-version: '3.10'
          cache: 'pip' # caching pip dependencies

      - name: Install dependencies
        run: pip install -r requirements.txt
        working-directory: docs

      - name: Install system dependencies for Mermaid diagrams
        run: |
          sudo apt-get update
          sudo apt-get install -y \
            libnss3 \
            libatk-bridge2.0-0 \
            libdrm2 \
            libxkbcommon0 \
            libxcomposite1 \
            libxdamage1 \
            libxfixes3 \
            libxrandr2 \
            libgbm1 \
            libasound2

      - name: Build packages
        run: npm run configure

      - name: Build SATP Hermes diagrams
        run: yarn docs:diagrams
        working-directory: packages/cactus-plugin-satp-hermes

      - name: Copy SATP Hermes docs to mkdocs
        run: |
          mkdir -p docs/docs/satp-hermes/assets
          cp -r packages/cactus-plugin-satp-hermes/docs/architecture docs/docs/satp-hermes/
          cp -r packages/cactus-plugin-satp-hermes/assets/diagrams docs/docs/satp-hermes/assets/

      - name: Build markdown for openapi specs
        run: 'python3 docs/scripts/publish_openapi.py'
        
      - name: Build and publish
        run: git pull && mkdocs gh-deploy
        working-directory: docs

```
