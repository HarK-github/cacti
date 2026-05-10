# GrimoireLab — Workflow Analysis

## Workflow Inventory
| File | Category | Trigger | Blocks PR? |
|------|----------|---------|------------|
| docker-image.yml | RELEASE | release, workflow_dispatch | No |
| grimoirelab-release.yml | RELEASE | workflow_dispatch | No |
| release-grimoirelab-component.yml | RELEASE | workflow_call | No |
| release.yml | RELEASE | push | No |

## Workflow Details

### `docker-image.yml` — RELEASE
**Triggers:** release, workflow_dispatch
**Branches/Paths:** release: types=published | workflow_dispatch: custom filters
**Contributor visible:** No

#### Jobs
1. **package-ready** — Workflow-specific automation
   - Step: Set up Python
   - Step: Wait for GrimoireLab package ready in PyPI
2. **build-image** — Build or packaging validation
   - Step: Install Cosign
   - Step: Docker metadata
   - Step: Set up QEMU
   - Step: Set up Docker Buildx
   - Step: Login to DockerHub
   - Step: Build and push
   - Step: Sign the images with GitHub OIDC Token

**Secrets required:** secret:DOCKERHUB_TOKEN, secret:DOCKERHUB_USERNAME, env:DOCKER_IMAGE_NAME
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** No

### `grimoirelab-release.yml` — RELEASE
**Triggers:** workflow_dispatch
**Branches/Paths:** workflow_dispatch: custom filters
**Contributor visible:** No

#### Jobs
1. **variables-job** — Workflow-specific automation
   - Step: variables
2. **grimoirelab-toolkit** — Workflow-specific automation
   - Step: No explicit steps in this job body
3. **grimoirelab-kidash** — Workflow-specific automation
   - Step: No explicit steps in this job body
4. **grimoirelab-sortinghat** — Workflow-specific automation
   - Step: No explicit steps in this job body
5. **grimoirelab-cereslib** — Workflow-specific automation
   - Step: No explicit steps in this job body
6. **grimoirelab-sigils** — Workflow-specific automation
   - Step: No explicit steps in this job body
7. **grimoirelab-perceval** — Workflow-specific automation
   - Step: No explicit steps in this job body
8. **grimoirelab-perceval-mozilla** — Workflow-specific automation
   - Step: No explicit steps in this job body
9. **grimoirelab-perceval-opnfv** — Workflow-specific automation
   - Step: No explicit steps in this job body
10. **grimoirelab-perceval-puppet** — Workflow-specific automation
   - Step: No explicit steps in this job body
11. **grimoirelab-perceval-weblate** — Workflow-specific automation
   - Step: No explicit steps in this job body
12. **grimoirelab-graal** — Workflow-specific automation
   - Step: No explicit steps in this job body
13. **grimoirelab-elk** — Workflow-specific automation
   - Step: No explicit steps in this job body
14. **grimoirelab-sirmordred** — Workflow-specific automation
   - Step: No explicit steps in this job body
15. **grimoirelab** — Release or publishing automation
   - Step: Use actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11
   - Step: Set up Python
   - Step: Set up Git config
   - Step: Install Poetry
   - Step: Install release-tools
   - Step: Check if package dependencies exist
   - Step: Update version number
   - Step: Update dependencies files

**Secrets required:** secret:GRIMOIRELAB_BUILD_TOKEN
**Estimated run time:** ~45+ minutes
**Blocks PR merge:** No

### `release-grimoirelab-component.yml` — RELEASE
**Triggers:** workflow_call
**Branches/Paths:** workflow_call: custom filters
**Contributor visible:** No

#### Jobs
1. **release** — Release or publishing automation
   - Step: Use actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11
   - Step: Set up Python
   - Step: Set up Git config
   - Step: Configure repository credentials
   - Step: Checkout submodule ${{ inputs.module_directory }}
   - Step: Install Poetry
   - Step: Install release-tools
   - Step: Get old version

**Secrets required:** secret:access_token
**Estimated run time:** ~5-10 minutes
**Blocks PR merge:** No

### `release.yml` — RELEASE
**Triggers:** push
**Branches/Paths:** push: tags=*.*.*, *.*.*-*
**Contributor visible:** No

#### Jobs
1. **build** — Build or packaging validation
   - Step: Build package using Poetry and store result
2. **tests** — Automated test execution
   - Step: Download distribution artifact
   - Step: Set up Python ${{ matrix.python-version }}
   - Step: Check package installed
3. **release** — Release or publishing automation
   - Step: Create a new release on the repository
4. **publish** — Artifact publishing
   - Step: Publish the package on PyPI

**Secrets required:** secret:GITHUB_TOKEN, secret:PYPI_API_TOKEN
**Estimated run time:** ~20-45 minutes
**Blocks PR merge:** No

## Contributor Summary

New contributors should expect these workflows to matter most on their pull requests: none directly from GitHub Actions. Workflows that are mainly for maintainers or release automation include docker-image.yml, grimoirelab-release.yml, release-grimoirelab-component.yml, release.yml. To stay ahead of CI, contributors should at minimum run tests, verify builds. Release, publishing, scheduled maintenance, scorecard, and documentation deployment workflows are usually not something a first-time contributor needs to optimize for unless their change touches that surface. If a PR-visible workflow fails, the quickest path is to compare the failing job steps with the local equivalent command and then re-run only after reproducing or understanding the issue. The contributor experience in this repository is fairly compact because the workflow files themselves expose most of the automation contract.

## Red Flags / Observations

- Potentially complex for newcomers: grimoirelab-release.yml.
- Some workflows need more in-file explanation because job intent is not obvious from names alone: docker-image.yml, grimoirelab-release.yml.
