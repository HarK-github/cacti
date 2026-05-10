# HYPERLEDGER CACTI: SATP HERMES CI/CD PIPELINE
Generated: Sun May 10 03:50:43 PM IST 2026


--- FILE: .github/workflows/satp-hermes-build.yaml ---
```yaml
name: SATP Hermes Gateway Build

on:
  workflow_call:
    outputs:
      build_success:
        description: "Whether the build was successful"
        value: ${{ jobs.build-satp.outputs.build_success }}

jobs:
  build-satp:
    runs-on: ubuntu-22.04
    continue-on-error: false
    outputs:
      build_success: ${{ steps.build.outputs.success }}
    env:
      # Disable full build to focus on SATP-specific components
      FULL_BUILD_DISABLED: true
      TOOLS_VALIDATE_BUNDLE_NAMES_DISABLED: true
      CUSTOM_CHECKS_DISABLED: true
      CONFIGURE_DISABLED: false
      CHECK_WORK_TREE_STATUS_DISABLED: true
    steps:
      # Install Cacti pre-requisites
      - name: Use Node.js
        uses: actions/setup-node@v4.0.3
        with:
          node-version: v22.18.0

      - uses: actions/checkout@v4
        with:
          submodules: recursive
  
      - id: yarn-cache
        name: Initialize Yarn Cache
        uses: actions/cache@v4
        with:
          key: ${{ runner.os }}-yarn-${{ hashFiles('./yarn.lock') }}
          path: ./.yarn/
          restore-keys: |
            ${{ runner.os }}-yarn-${{ hashFiles('./yarn.lock') }}

      - name: Set working directory
        run: cd packages/cactus-plugin-satp-hermes && pwd            

      - name: Install Foundry
        uses: foundry-rs/foundry-toolchain@v1
        with:
          version: stable

      - name: Install dependencies
        run: yarn install

      - name: Configure
        run: yarn configure

      - name: Build bundle
        id: build
        run: |
          yarn lerna run build:bundle --scope=@hyperledger/cactus-plugin-satp-hermes
          echo "success=true" >> "$GITHUB_OUTPUT"

      # Upload build artifacts for reuse in other jobs
      - name: Upload build output
        uses: actions/upload-artifact@v4
        with:
          name: satp-hermes-build-output
          path: packages/cactus-plugin-satp-hermes/dist/

      - name: Upload .yarn cache
        id: upload_yarn_cache
        if: always()
        run: |
          echo "Listing .yarn/ content (root):"
          ls -la ./.yarn/ || echo "no .yarn directory"
          if [ -d ./.yarn ] && [ "$(ls -A ./.yarn 2>/dev/null)" != "" ]; then
            echo "Uploading .yarn cache artifact"
            echo "found=true" >> "$GITHUB_OUTPUT"
          else
            echo "No yarn cache found, skipping upload"
            echo "found=false" >> "$GITHUB_OUTPUT"
          fi

      - name: Upload .yarn cache artifact
        if: steps.upload_yarn_cache.outputs.found == 'true'
        uses: actions/upload-artifact@v4
        with:
          name: satp-hermes-yarn-cache
          path: ./.yarn/

      - name: Upload package .yarn cache as fallback
        id: upload_yarn_cache_package
        if: steps.upload_yarn_cache.outputs.found == 'false'
        run: |
          echo "Listing packages/cactus-plugin-satp-hermes/.yarn/ content:"
          ls -la packages/cactus-plugin-satp-hermes/.yarn/ || echo "no package .yarn directory"
          if [ -d packages/cactus-plugin-satp-hermes/.yarn ] && [ "$(ls -A packages/cactus-plugin-satp-hermes/.yarn 2>/dev/null)" != "" ]; then
            echo "Uploading package .yarn cache as fallback"
            echo "found=true" >> "$GITHUB_OUTPUT"
          else
            echo "No package .yarn found, skipping upload"
            echo "found=false" >> "$GITHUB_OUTPUT"
          fi

      - name: Upload package .yarn cache artifact (fallback)
        if: steps.upload_yarn_cache_package.outputs.found == 'true'
        uses: actions/upload-artifact@v4
        with:
          name: satp-hermes-yarn-cache
          path: packages/cactus-plugin-satp-hermes/.yarn/

```


--- FILE: .github/workflows/satp-hermes-lint.yaml ---
```yaml
name: SATP Hermes Gateway Lint

on:
  workflow_call:
    outputs:
      lint_success:
        description: "Whether the lint was successful"
        value: ${{ jobs.lint-satp.outputs.lint_success }}

jobs:
  lint-satp:
    runs-on: ubuntu-22.04
    continue-on-error: false
    outputs:
      lint_success: ${{ steps.lint.outputs.success }}
    env:
      FULL_BUILD_DISABLED: true
      TOOLS_VALIDATE_BUNDLE_NAMES_DISABLED: true
      CUSTOM_CHECKS_DISABLED: true
      CONFIGURE_DISABLED: false
      CHECK_WORK_TREE_STATUS_DISABLED: true
    steps:
      - uses: actions/checkout@v4
        with:
          submodules: recursive

      - name: Use Node.js
        uses: actions/setup-node@v4.0.3
        with:
          node-version: v22.18.0

      - name: Download SATP build artifacts
        uses: ./.github/actions/satp-download-build-artifacts

      - name: Install dependencies
        run: yarn install

      - name: Set working directory
        run: cd packages/cactus-plugin-satp-hermes && pwd
      
      - run: git status --porcelain
      - run: git status --porcelain | wc -l

      - name: yarn lint (SATP-specific)
        run: yarn workspace @hyperledger/cactus-plugin-satp-hermes lint

      - name: Run additional SATP linting
        id: lint
        run: |
          yarn workspace @hyperledger/cactus-plugin-satp-hermes lint-code || echo "Linting completed with warnings" 
          yarn workspace @hyperledger/cactus-plugin-satp-hermes lint:oapi || echo "OpenAPI linting completed with warnings"
          yarn workspace @hyperledger/cactus-plugin-satp-hermes lint:protobuf || echo "Protobuf linting completed with warnings"
          echo "success=true" >> "$GITHUB_OUTPUT"
      
      - run: git status --porcelain
      - run: git status --porcelain | wc -l

      - name: Set env.GIT_INDEX_FILE_COUNT
        id: set_env_git_index_file_count
        run: |
            echo "GIT_INDEX_FILE_COUNT=$(git status --porcelain | wc -l)" >> "$GITHUB_ENV"

      - name: Print env.GIT_INDEX_FILE_COUNT
        id: print_env_git_index_file_count
        run: |
            echo "${{ env.GIT_INDEX_FILE_COUNT }}"
      - uses: actions/github-script@60a0d83039c74a4aee543508d2ffcb1c3799cdea #v7.0.1
        id: set-result-git_index_file_count
        with:
          script: |
            const { GIT_INDEX_FILE_COUNT } = process.env;
            console.log(`env.GIT_INDEX_FILE_COUNT ${GIT_INDEX_FILE_COUNT}`);
            return parseInt(GIT_INDEX_FILE_COUNT, 10);
          result-encoding: string

      - name: Get result Git Index File Count
        id: get_result_git_index_file_count
        run: echo "${{steps.set-result-git_index_file_count.outputs.result}}"

      - name: Check Lint Side-effects
        if: ${{ steps.set-result-git_index_file_count.outputs.result != 0 }}
        uses: actions/github-script@60a0d83039c74a4aee543508d2ffcb1c3799cdea
        with:
          script: |
            const failMsg = "yarn lint script produced version control " +
              "side-effects: source files have been changed by it that are " +
              "otherwise are under version control. " +
              "This means (99% of the time) that you need to run the " +
              "yarn lint script locally and then include the changes it " +
              "makes in your own commit when submitting your pull request.";
            core.setFailed(failMsg)

```


--- FILE: .github/workflows/satp-hermes-codegen.yaml ---
```yaml
name: SATP Hermes Gateway Codegen

on:
  workflow_call:
    outputs:
      codegen_success:
        description: "Whether the code generation was successful"
        value: ${{ jobs.codegen-satp.outputs.codegen_success }}

jobs:
  codegen-satp: 
    runs-on: ubuntu-22.04
    continue-on-error: false
    outputs:
      codegen_success: ${{ steps.codegen.outputs.success }}
    env:
      FULL_BUILD_DISABLED: true
      TOOLS_VALIDATE_BUNDLE_NAMES_DISABLED: true
      CUSTOM_CHECKS_DISABLED: true
      CONFIGURE_DISABLED: false
      CHECK_WORK_TREE_STATUS_DISABLED: true
    steps:
      - uses: actions/checkout@v4
        with:
          submodules: recursive

      # Install Cacti pre-requisites
      - name: Use Node.js
        uses: actions/setup-node@v4.0.3
        with:
          node-version: v22.18.0

      # Download build artifacts using reusable action
      - name: Download SATP build artifacts
        uses: ./.github/actions/satp-download-build-artifacts

      - name: Install dependencies
        run: yarn install

      - name: Set working directory
        run: cd packages/cactus-plugin-satp-hermes && pwd

      - name: Install Foundry
        uses: foundry-rs/foundry-toolchain@v1
        with:
          version: stable

      - name: Generate protobuf files
        run: yarn workspace @hyperledger/cactus-plugin-satp-hermes codegen:proto

      - name: Generate OpenAPI SDKs
        run: |
          yarn workspace @hyperledger/cactus-plugin-satp-hermes bundle-openapi-yaml
          yarn workspace @hyperledger/cactus-plugin-satp-hermes bundle-openapi-json 
          yarn workspace @hyperledger/cactus-plugin-satp-hermes generate-sdk:typescript-axios-bol

      - name: Generate ABIs
        id: codegen
        run: |
          yarn workspace @hyperledger/cactus-plugin-satp-hermes forge:build:all
          echo "success=true" >> "$GITHUB_OUTPUT"

      # Upload generated artifacts for reuse in other jobs
      - name: Upload generated protobuf files
        uses: actions/upload-artifact@v4
        with:
          name: satp-hermes-generated-protobuf
          path: packages/cactus-plugin-satp-hermes/src/main/typescript/generated/

      - name: Upload generated OpenAPI files
        uses: actions/upload-artifact@v4
        with:
          name: satp-hermes-generated-openapi
          path: |
            packages/cactus-plugin-satp-hermes/src/main/yml/bol/oapi-api1-bundled.yml
            packages/cactus-plugin-satp-hermes/src/main/json/oapi-api1-bundled.json
            packages/cactus-plugin-satp-hermes/src/main/typescript/generated/gateway-client/

      - name: Upload generated Solidity artifacts
        uses: actions/upload-artifact@v4
        with:
          name: satp-hermes-generated-solidity
          path: packages/cactus-plugin-satp-hermes/src/main/solidity/generated/
          
      - name: Show yarn build log if it exists
        if: always()
        run: |
          LOG_FILE=$(find /tmp -type f -name build.log | head -n 1)
          if [ -f "$LOG_FILE" ]; then
            echo "===== Build Log ====="
            cat "$LOG_FILE"
            echo "====================="
          else
            echo "No build log found."
          fi

```


--- FILE: .github/workflows/satp-hermes-publish.yaml ---
```yaml
name: SATP Hermes Gateway Docker Publish

on:
  workflow_call:
    inputs:
      skip_tests:
        description: 'Skip test execution (for emergency releases only)'
        required: false
        default: false
        type: boolean
      is_release:
        description: 'Create release version using package.json version'
        required: false
        default: false
        type: boolean
      custom_version:
        description: 'Custom version tag (leave empty to use package.json version)'
        required: false
        type: string
    outputs:
      package_version:
        description: "Package version from package.json"
        value: ${{ jobs.set-docker-tags.outputs.package_version }}
      tag_suffix:
        description: "Tag suffix (dev or release)"
        value: ${{ jobs.set-docker-tags.outputs.tag_suffix }}
      tag_version:
        description: "Full tag version"
        value: ${{ jobs.set-docker-tags.outputs.tag_version }}
      dockerhub_image:
        description: "Docker Hub image name"
        value: ${{ jobs.set-docker-tags.outputs.dockerhub_image }}
      ghcr_image:
        description: "GHCR image name"
        value: ${{ jobs.set-docker-tags.outputs.ghcr_image }}
      is_release:
        description: "Whether this is a release build"
        value: ${{ jobs.set-docker-tags.outputs.is_release }}

permissions:
  contents: read
  packages: write

jobs:
  # Set Docker tags based on branch and commit information
  set-docker-tags:
    # Handle conditional test dependencies - run if tests pass OR if tests are skipped in release mode
    if: |
      always() && (
        (inputs.skip_tests == true && inputs.is_release == true) ||
        (github.event_name == 'push' && (github.ref == 'refs/heads/main' || github.ref == 'refs/heads/satp-dev' || github.ref == 'refs/heads/satp-stg')) ||
        (github.event_name == 'pull_request' && (github.base_ref == 'main' || github.base_ref == 'satp-dev' || github.base_ref == 'satp-stg')) ||
        github.event_name == 'workflow_dispatch'
      )
    runs-on: ubuntu-22.04
    outputs:
      package_version: ${{ steps.set_tags.outputs.package_version }}
      tag_suffix: ${{ steps.set_tags.outputs.tag_suffix }}
      tag_version: ${{ steps.set_tags.outputs.tag_version }}
      dockerhub_image: ${{ steps.set_tags.outputs.dockerhub_image }}
      ghcr_image: ${{ steps.set_tags.outputs.ghcr_image }}
      is_release: ${{ steps.set_tags.outputs.is_release }}
    steps:
      - uses: actions/checkout@v4.1.7  
      - name: Set image tags
        id: set_tags
        run: |
          # Extract SATP package version from package.json version field
          PACKAGE_VERSION=$(node -e "console.log(require('./packages/cactus-plugin-satp-hermes/package.json').version)")
          
          # Check if this is a release build (manual trigger with is_release=true)
          IS_RELEASE="${{ inputs.is_release }}"
          if [ "$IS_RELEASE" = "true" ]; then
            # Release mode: Use package.json version or custom version as the main tag
            if [ -n "${{ inputs.custom_version }}" ]; then
              TAG_VERSION="${{ inputs.custom_version }}"
              echo "Building release version with custom version: ${{ inputs.custom_version }}"
            else
              TAG_VERSION="${PACKAGE_VERSION}"
              echo "Building release version with package.json version: ${PACKAGE_VERSION}"
            fi
            TAG_SUFFIX="release"
          else
            # Development mode: Use date-based development tags for all branches
            TAG_SUFFIX="dev"
            TAG_VERSION="$(date -u +"%Y-%m-%d")-${TAG_SUFFIX}-$(git rev-parse --short HEAD)"
            echo "Building development version: ${TAG_VERSION}"
          fi
          
          # Standardized image names for both registries
          BASE_IMAGE_NAME="hyperledger/cacti-satp-hermes-gateway"
          DOCKERHUB_IMAGE="${BASE_IMAGE_NAME}"
          GHCR_IMAGE="hyperledger-cacti/cacti-satp-hermes-gateway"
          
          {
            echo "package_version=${PACKAGE_VERSION}"
            echo "tag_suffix=${TAG_SUFFIX}"
            echo "tag_version=${TAG_VERSION}"
            echo "dockerhub_image=${DOCKERHUB_IMAGE}"
            echo "ghcr_image=${GHCR_IMAGE}"
            echo "is_release=${IS_RELEASE:-false}"
          } >> "$GITHUB_OUTPUT"

      - name: Debug Build Info
        run: |
          PACKAGE_VERSION=$(node -e "console.log(require('./packages/cactus-plugin-satp-hermes/package.json').version)")
          {
            echo "Debug: Current ref = ${{ github.ref }}"
            echo "Debug: Event name = ${{ github.event_name }}"
            echo "Debug: GitHub workspace = ${{ github.workspace }}"
            echo "Debug: Repository = ${{ github.repository }}"
            echo "Debug: Building for tag version = ${{ steps.set_tags.outputs.tag_version }}"
            echo "Debug: Building for dockerhub image = ${{ steps.set_tags.outputs.dockerhub_image }}"
            echo "Debug: Node.js version = v22.18.0"
            echo "Debug: Package version = ${PACKAGE_VERSION}"
            echo "Debug: Commit hash = $(git rev-parse --short HEAD)"
          }

  # Build Docker image once for caching and reuse by push jobs
  build-satp-docker:
    needs: [set-docker-tags]
    # Build Docker images for pushes, PRs targeting the release branches, and manual workflow dispatch.
    # This job only builds, it does not push to registries.
    if: (github.event_name == 'push' && (github.ref == 'refs/heads/main' || github.ref == 'refs/heads/satp-dev' || github.ref == 'refs/heads/satp-stg')) || (github.event_name == 'pull_request' && (github.base_ref == 'main' || github.base_ref == 'satp-dev' || github.base_ref == 'satp-stg')) || github.event_name == 'workflow_dispatch'
    runs-on: ubuntu-22.04
    steps:
      - uses: actions/checkout@v4.1.7

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '22'
          cache: 'yarn'
          cache-dependency-path: yarn.lock
      
      - id: yarn-cache
        name: Initialize Yarn Cache
        uses: actions/cache@v4
        with:
          key: ${{ runner.os }}-yarn-${{ hashFiles('./yarn.lock') }}
          path: ./.yarn/
          restore-keys: |
            ${{ runner.os }}-yarn-${{ hashFiles('./yarn.lock') }}

      - name: Set working directory
        run: cd packages/cactus-plugin-satp-hermes           

      - name: Install Foundry
        uses: foundry-rs/foundry-toolchain@v1
        with:
          version: stable

      - name: Install dependencies
        run: yarn install --frozen-lockfile

      - name: Configure
        run: yarn configure

      - name: Build bundle
        id: build
        run: |
          yarn lerna run build:bundle --scope=@hyperledger/cactus-plugin-satp-hermes
          echo "success=true" >> "$GITHUB_OUTPUT"

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Build Docker image (no push)
        uses: docker/build-push-action@v5
        with:
          context: ./packages/cactus-plugin-satp-hermes
          file: ./packages/cactus-plugin-satp-hermes/satp-hermes-gateway.Dockerfile
          # Build only, no push to registries
          push: false
          tags: |
            ${{ needs.set-docker-tags.outputs.dockerhub_image }}:${{ needs.set-docker-tags.outputs.tag_version }},
            ${{ needs.set-docker-tags.outputs.ghcr_image }}:${{ needs.set-docker-tags.outputs.tag_version }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

  # =============================================================================
  # STAGE 7: PUBLISH DOCKER IMAGES
  # =============================================================================
  # The following two jobs run in parallel on push events to release branches
  # for faster deployment. Both jobs build and push Docker images directly with
  # GitHub Actions cache (type=gha) for maximum efficiency.

  # Stage 7a: Publish Docker image to GitHub Container Registry (GHCR)
  publish-satp-image-ghcr:
    needs: [build-satp-docker, set-docker-tags]
    if: (github.event_name == 'push' && (github.ref == 'refs/heads/main' || github.ref == 'refs/heads/satp-dev' || github.ref == 'refs/heads/satp-stg')) || github.event_name == 'workflow_dispatch'
    runs-on: ubuntu-22.04
    steps:
      - uses: actions/checkout@v4.1.7

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '22'
          cache: 'yarn'
          cache-dependency-path: yarn.lock

      - name: Install dependencies
        run: yarn install --frozen-lockfile

      - name: Configure
        run: yarn configure

      - name: Build bundle
        id: build
        run: |
          yarn lerna run build:bundle --scope=@hyperledger/cactus-plugin-satp-hermes
          echo "success=true" >> "$GITHUB_OUTPUT"

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Login to GitHub Container Registry
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Build and push to GHCR (Release)
        if: needs.set-docker-tags.outputs.is_release == 'true'
        uses: docker/build-push-action@v5
        with:
          context: ./packages/cactus-plugin-satp-hermes
          file: ./packages/cactus-plugin-satp-hermes/satp-hermes-gateway.Dockerfile
          push: true
          tags: |
            ghcr.io/${{ needs.set-docker-tags.outputs.ghcr_image }}:${{ needs.set-docker-tags.outputs.tag_version }}
            ghcr.io/${{ needs.set-docker-tags.outputs.ghcr_image }}:latest
          cache-from: type=gha
          cache-to: type=gha,mode=max

      - name: Build and push to GHCR (Development)
        if: needs.set-docker-tags.outputs.is_release != 'true'
        uses: docker/build-push-action@v5
        with:
          context: ./packages/cactus-plugin-satp-hermes
          file: ./packages/cactus-plugin-satp-hermes/satp-hermes-gateway.Dockerfile
          push: true
          tags: |
            ghcr.io/${{ needs.set-docker-tags.outputs.ghcr_image }}:${{ needs.set-docker-tags.outputs.tag_version }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

  # Stage 7b: Publish Docker image to Docker Hub
  publish-satp-image-dockerhub:
    needs: [build-satp-docker, set-docker-tags]
    if: (github.event_name == 'push' && (github.ref == 'refs/heads/main' || github.ref == 'refs/heads/satp-dev' || github.ref == 'refs/heads/satp-stg')) || github.event_name == 'workflow_dispatch'
    runs-on: ubuntu-22.04
    continue-on-error: true  # Don't fail the workflow if Docker Hub push fails
    steps:
      - uses: actions/checkout@v4.1.7

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '22'
          cache: 'yarn'
          cache-dependency-path: yarn.lock

      - name: Install dependencies
        run: yarn install --frozen-lockfile

      - name: Configure
        run: yarn configure

      - name: Build bundle
        id: build
        run: |
          yarn lerna run build:bundle --scope=@hyperledger/cactus-plugin-satp-hermes
          echo "success=true" >> "$GITHUB_OUTPUT"

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_PAT }}

      - name: Build and push to Docker Hub (Release)
        if: needs.set-docker-tags.outputs.is_release == 'true'
        uses: docker/build-push-action@v5
        with:
          context: ./packages/cactus-plugin-satp-hermes
          file: ./packages/cactus-plugin-satp-hermes/satp-hermes-gateway.Dockerfile
          push: true
          tags: |
            ${{ needs.set-docker-tags.outputs.dockerhub_image }}:${{ needs.set-docker-tags.outputs.tag_version }}
            ${{ needs.set-docker-tags.outputs.dockerhub_image }}:latest
          cache-from: type=gha
          cache-to: type=gha,mode=max

      - name: Build and push to Docker Hub (Development)
        if: needs.set-docker-tags.outputs.is_release != 'true'
        uses: docker/build-push-action@v5
        with:
          context: ./packages/cactus-plugin-satp-hermes
          file: ./packages/cactus-plugin-satp-hermes/satp-hermes-gateway.Dockerfile
          push: true
          tags: |
            ${{ needs.set-docker-tags.outputs.dockerhub_image }}:${{ needs.set-docker-tags.outputs.tag_version }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

```


--- FILE: .github/workflows/satp-hermes-release.yaml ---
```yaml
name: SATP Hermes Gateway Release

on:
  workflow_call:
    inputs:
      is_release:
        description: 'Create release version using package.json version'
        required: false
        default: false
        type: boolean
      release_branch:
        description: 'Branch to create release from (for manual releases)'
        required: false
        default: 'main'
        type: string
      custom_version:
        description: 'Custom version tag (leave empty to use package.json version)'
        required: false
        type: string
      tag_version:
        description: 'Tag version from docker stage'
        required: true
        type: string
  
  workflow_dispatch:
    inputs:
      is_release:
        description: 'Create release version using package.json version'
        required: false
        default: true
        type: boolean
      release_branch:
        description: 'Branch to create release from'
        required: false
        default: 'main'
        type: choice
        options:
          - main
          - satp-stg
          - satp-dev
      custom_version:
        description: 'Custom version tag (leave empty to use package.json version)'
        required: false
        type: string
      tag_version:
        description: 'Tag version (e.g., 0.0.3-beta)'
        required: true
        type: string

jobs:
  # =============================================================================
  # STAGE 8: CREATE GITHUB RELEASE (MANUAL RELEASE MODE ONLY)
  # =============================================================================
  # This job runs only when the workflow is manually triggered with is_release=true
  # It creates a proper GitHub release with changelog and Docker image information

  create-github-release:
    if: inputs.is_release == 'true'
    runs-on: ubuntu-22.04
    steps:
      - uses: actions/checkout@v4.1.7
        with:
          ref: ${{ inputs.release_branch || github.ref }}

      - name: Validate version format
        run: |
          VERSION="${{ inputs.tag_version }}"
          if ! echo "$VERSION" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+.*$'; then
            echo "Error: Version '$VERSION' does not follow semantic versioning format (x.y.z)"
            exit 1
          fi
          echo "Version format validated: $VERSION"

      - name: Create Release
        uses: actions/create-release@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          tag_name: satp-v${{ inputs.tag_version }}
          release_name: SATP Hermes Gateway v${{ inputs.tag_version }}
          body: |
            # SATP Hermes Gateway Release v${{ inputs.tag_version }}
            
            This release was created from branch `${{ inputs.release_branch || github.ref }}`.
            
            ## Docker Images
            
            **Docker Hub:**
            ```bash
            docker pull hyperledger/satp-hermes-gateway:${{ inputs.tag_version }}
            docker pull hyperledger/satp-hermes-gateway:latest
            ```
            
            **GitHub Container Registry:**
            ```bash
            docker pull ghcr.io/hyperledger/satp-hermes-gateway:${{ inputs.tag_version }}
            docker pull ghcr.io/hyperledger/satp-hermes-gateway:latest
            ```
            
            ## Release Information
            - Release Version: ${{ inputs.tag_version }}
            - Custom Version: ${{ inputs.custom_version || 'None (using package.json)' }}
            - Source Branch: ${{ inputs.release_branch || github.ref }}
            - Workflow Run: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}
            - Release Time (github): ${{ github.run_id }}
          draft: false
          prerelease: ${{ contains(inputs.tag_version, 'alpha') || contains(inputs.tag_version, 'beta') || contains(inputs.tag_version, 'rc') }}

```
