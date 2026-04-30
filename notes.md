# Build Notes for Hyperledger Cacti

## Date: April 27, 2026

## Objective
Follow instructions in BUILD.md to build the Cacti application, ensure it runs, and summarize what was tried and where stuck.

## Steps Taken

### 1. Read BUILD.md
- Read the build instructions from BUILD.md to understand prerequisites and steps.

### 2. Prerequisites Check
- NodeJS v20.20.0: Attempted to install via nvm (from context, curl command ran successfully).
- Yarn: Attempted npm install -g yarn, failed with exit code 243, then sudo npm install -g yarn with exit code 130.

### 3. Enable Corepack
- Ran `npm run enable-corepack` successfully. It installed corepack globally, enabled it, and prepared yarn@4.3.1.

### 4. Configure Cacti
- Attempted `yarn run configure`, but terminal seems to interrupt long commands.
- Ran `yarn install` separately, output was large, likely succeeded.
- Attempted `yarn build:dev:backend`, but terminal issues persist.
- Tried running in bash explicitly, but same issue.
- Checked existing build: dist/ folders exist in packages, suggesting previous build.
- Attempted `npm run generate-api-server-config`, but no output from terminal.

## Issues Encountered
- Yarn installation initially failed (exit code 243, then 130 with sudo).
- Terminal appears to have issues with long-running commands, showing ^C or no output.
- Commands like yarn --version work for short commands, but build commands fail.
- Even bash -c commands don't produce output.

## Docker Setup for Persistent Dev Environment

### Completed Steps:

#### Step 1: Clone Repository ✅
- User has already completed this step.

#### Step 2: Create Docker Volume & Run Container
- Need to run: `docker volume create cacti_volume`
- Then run: `docker run -v cacti_volume:/workspace -w /workspace -it node:20.20.0 bash`

**Note**: Terminal appears to have output issues, preventing automated execution of long-running Docker commands.

#### Step 3: Add Docker Volume Configuration to devcontainer.json ✅
- Successfully updated `.devcontainer/devcontainer.json`
- Added mounts configuration:
  ```json
  "mounts": [
    "source=cacti_volume,target=/workspace,type=volume"
  ]
  ```
- This configuration allows the VS Code dev container to use the persistent Docker volume created in Step 2.

### File Changes:
- **Modified**: `.devcontainer/devcontainer.json`
  - Added "mounts" property with cacti_volume mount configuration

### User Instructions:
1. In a terminal (outside of VS Code), run:
   ```bash
   docker volume create cacti_volume
   docker run -v cacti_volume:/workspace -w /workspace -it node:20.20.0 bash
   ```

2. In VS Code:
   - Open command palette (`F1` or `Ctrl+Shift+P`)
   - Select "Reopen in Container"
   - Wait for container setup to complete
   - Start developing!

The devcontainer configuration is now ready with the persistent volume mount.

### 5. Test Build
- Run a test or start the API server to verify.

## Issues Encountered
- Yarn installation failed.
- Need to proceed with bash terminal only.

## Next Steps
- Continue with enabling corepack and configuration.