# HYPERLEDGER CACTI WORKFLOW & PACKAGE LOGIC
Generated: Sun May 10 03:42:02 PM IST 2026


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


--- FILE: .github/workflows/packages-workflow.yaml ---
```yaml
name: Run All Pacakges workflows

# Controls when the workflow will run
on:
  # Triggers the workflow on push or pull request events but only for the main branch
  workflow_call:
    inputs:
      node_version:
        required: true
        type: string
      run_code_coverage:
        required: true
        type: string
      run_trivy_scan:
        required: true
        type: string
      affected-packages:
        required: false
        type: string
  
concurrency:
  group: packages-workflows-${{ github.workflow }}-${{ github.event.pull_request.number || github.ref }}
  cancel-in-progress: true

jobs:
  core-packages:
    uses: ./.github/workflows/core-packages-workflow.yaml
    with:
      node_version: ${{ inputs.node_version }}
      run_code_coverage:  ${{ inputs.run_code_coverage }}
      run_trivy_scan:  ${{ inputs.run_trivy_scan }}
      affected-packages: ${{ inputs.affected-packages }}

  connector-packages:
    uses: ./.github/workflows/connector-packages-workflow.yaml
    with:
      node_version: ${{ inputs.node_version }}
      run_code_coverage:  ${{ inputs.run_code_coverage }}
      run_trivy_scan:  ${{ inputs.run_trivy_scan }}
      affected-packages: ${{ inputs.affected-packages }}

  keychain-packages:
    uses: ./.github/workflows/keychain-packages-workflow.yaml
    with:
      node_version: ${{ inputs.node_version }}
      run_code_coverage:  ${{ inputs.run_code_coverage }}
      run_trivy_scan:  ${{ inputs.run_trivy_scan }}
      affected-packages: ${{ inputs.affected-packages }}

  other-packages:
    uses: ./.github/workflows/other-packages-workflow.yaml
    with:
      node_version: ${{ inputs.node_version }}
      run_code_coverage:  ${{ inputs.run_code_coverage }}
      run_trivy_scan:  ${{ inputs.run_trivy_scan }}
      affected-packages: ${{ inputs.affected-packages }}
      
  satp-hermes-workflow:
    if: contains(fromJson(inputs.affected-packages), 'packages/cactus-plugin-satp-hermes')
    uses: ./.github/workflows/satp-hermes-workflow.yaml
    with:
      node_version: ${{ inputs.node_version }}
      run_code_coverage:  ${{ inputs.run_code_coverage }}
  


  
```


--- FILE: .github/workflows/test_weaver-data-sharing.yaml ---
```yaml
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: CC-BY-4.0

# This is a basic workflow to help you get started with Actions

name: Test Data Sharing

env:
  NODEJS_VERSION: v22.18.0

# Controls when the workflow will run
on:
  workflow_call:
    inputs:
      run_all:
        required: true
        type: string


concurrency:
  group: data-sharing-${{ github.workflow }}-${{ github.event.pull_request.number || github.ref }}
  cancel-in-progress: true

# A workflow run is made up of one or more jobs that can run sequentially or in parallel
jobs:
  check_code_changed:
    outputs:
      status: ${{ steps.changes.outputs.weaver_code_changed }}
    runs-on: ubuntu-22.04
    steps:
      - uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 #v4.1.7

      - uses: dorny/paths-filter@4512585405083f25c027a35db413c2b3b9006d50 #v2.11.1
        id: changes
        with:
          filters: |
            weaver_code_changed:
              - './weaver/**'
              - '.github/workflows/test_weaver-data-sharing.yaml'

  data-sharing:
    needs: check_code_changed
    if: ${{ false && needs.check_code_changed.outputs.status == 'true' }}
    # The type of runner that the job will run on
    runs-on: ubuntu-22.04

    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
      # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
      - uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 #v4.1.7

      - name: Set up JDK 17
        uses: actions/setup-java@5ffc13f4174014e2d4d4572b3d74c3fa61aeb2c2 #v3.11.0
        with:
          java-version: '17'
          distribution: 'adopt'

      - name: Set up Go
        uses: actions/setup-go@4d34df0c2316fe8122ab82dc22947d607c0c91f9 #v4.0.0
        with:
          go-version: '1.20.2'

      - name: Use Node.js ${{ env.NODEJS_VERSION }}
        uses: actions/setup-node@1e60f620b9541d16bece96c5465dc8ee9832be0b #v4.0.3
        with:
          node-version: ${{ env.NODEJS_VERSION }}

      # CORDA NETWORK
      - name: Generate github.properties
        run: |
          echo "Using ${GITHUB_ACTOR} user."
          echo "username=${GITHUB_ACTOR}" >> github.properties
          echo "password=${{ secrets.GITHUB_TOKEN }}" >> github.properties
          echo "url=https://maven.pkg.github.com/${GITHUB_ACTOR}/cacti" >> github.properties

          echo "Using ${GITHUB_ACTOR} user."
          echo "username=${GITHUB_ACTOR}" >> github.main.properties
          echo "password=${{ secrets.GITHUB_TOKEN }}" >> github.main.properties
          echo "url=https://maven.pkg.github.com/hyperledger-cacti/cacti" >> github.main.properties

          ./scripts/get-cordapps.sh || mv github.main.properties github.properties

          cat github.properties
        working-directory: weaver/tests/network-setups/corda

      - name: Start Corda Network
        run: make start &> corda-net.out &
        working-directory: weaver/tests/network-setups/corda

      # FABRIC NETWORK
      - name: Start Fabric Network
        run: make start-interop PROFILE='2-nodes'
        working-directory: weaver/tests/network-setups/fabric/dev

      - name: Corda Network logs
        run: |
          cat tests/network-setups/corda/corda-net.out
          docker logs corda_partya_1
        working-directory: weaver

      # RELAY
      - name: Edit Relay docker compose
        run: make convert-compose-method2
        working-directory: weaver/core/relay

      - name: Start Relay for network1
        run: make start-server COMPOSE_ARG='--env-file docker/testnet-envs/.env.n1'
        working-directory: weaver/core/relay

      - name: Start Relay for network2
        run: make start-server COMPOSE_ARG='--env-file docker/testnet-envs/.env.n2'
        working-directory: weaver/core/relay

      - name: Start Relay for Corda_Network
        run: make start-server COMPOSE_ARG='--env-file docker/testnet-envs/.env.corda'
        working-directory: weaver/core/relay

      - name: Start Relay for Corda_Network2
        run: make start-server COMPOSE_ARG='--env-file docker/testnet-envs/.env.corda2'
        working-directory: weaver/core/relay

      # FABRIC DRIVER
      - name: Setup Fabric Driver .env
        run: |
          sed -i "s#<PATH-TO-WEAVER>#${GITHUB_WORKSPACE}/weaver#g" docker-testnet-envs/.env.n1
          sed -i "s#<PATH-TO-WEAVER>#${GITHUB_WORKSPACE}/weaver#g" docker-testnet-envs/.env.n2
        working-directory: weaver/core/drivers/fabric-driver

      - name: Start Fabric Driver for network1
        run: make deploy COMPOSE_ARG='--env-file docker-testnet-envs/.env.n1' NETWORK_NAME=$(grep NETWORK_NAME docker-testnet-envs/.env.n1 | cut -d '=' -f 2)
        working-directory: weaver/core/drivers/fabric-driver

      - name: Start Fabric Driver for network2
        run: make deploy COMPOSE_ARG='--env-file docker-testnet-envs/.env.n2' NETWORK_NAME=$(grep NETWORK_NAME docker-testnet-envs/.env.n2 | cut -d '=' -f 2)
        working-directory: weaver/core/drivers/fabric-driver

      # IIN AGENT
      - name: Setup Fabric IIN Env
        run: |
          sed -i "s#<PATH-TO-WEAVER>#${GITHUB_WORKSPACE}/weaver#g" docker-testnet/envs/.env.n1.org1
          sed -i "s#^AUTO_SYNC=true#AUTO_SYNC=false#g" docker-testnet/envs/.env.n1.org1
          sed -i "s#^DNS_CONFIG_PATH=.*#DNS_CONFIG_PATH=./docker-testnet/configs/dnsconfig-2-nodes.json#g" docker-testnet/envs/.env.n1.org1
          sed -i "s#<PATH-TO-WEAVER>#${GITHUB_WORKSPACE}/weaver#g" docker-testnet/envs/.env.n1.org2
          sed -i "s#^AUTO_SYNC=true#AUTO_SYNC=false#g" docker-testnet/envs/.env.n1.org2
          sed -i "s#^DNS_CONFIG_PATH=.*#DNS_CONFIG_PATH=./docker-testnet/configs/dnsconfig-2-nodes.json#g" docker-testnet/envs/.env.n1.org2
          sed -i "s#<PATH-TO-WEAVER>#${GITHUB_WORKSPACE}/weaver#g" docker-testnet/envs/.env.n2.org1
          sed -i "s#^AUTO_SYNC=true#AUTO_SYNC=false#g" docker-testnet/envs/.env.n2.org1
          sed -i "s#^DNS_CONFIG_PATH=.*#DNS_CONFIG_PATH=./docker-testnet/configs/dnsconfig-2-nodes.json#g" docker-testnet/envs/.env.n2.org1
          sed -i "s#<PATH-TO-WEAVER>#${GITHUB_WORKSPACE}/weaver#g" docker-testnet/envs/.env.n2.org2
          sed -i "s#^AUTO_SYNC=true#AUTO_SYNC=false#g" docker-testnet/envs/.env.n2.org2
          sed -i "s#^DNS_CONFIG_PATH=.*#DNS_CONFIG_PATH=./docker-testnet/configs/dnsconfig-2-nodes.json#g" docker-testnet/envs/.env.n2.org2
        working-directory: weaver/core/identity-management/iin-agent

      - name: Start Fabric IIN Agent for network1
        run: |
          make deploy COMPOSE_ARG='--env-file docker-testnet/envs/.env.n1.org1' DLT_SPECIFIC_DIR=$(grep DLT_SPECIFIC_DIR docker-testnet/envs/.env.n1.org1 | cut -d '=' -f 2)
          make deploy COMPOSE_ARG='--env-file docker-testnet/envs/.env.n1.org2' DLT_SPECIFIC_DIR=$(grep DLT_SPECIFIC_DIR docker-testnet/envs/.env.n1.org2 | cut -d '=' -f 2)
        working-directory: weaver/core/identity-management/iin-agent

      - name: Start Fabric IIN Agent for network2
        run: |
          make deploy COMPOSE_ARG='--env-file docker-testnet/envs/.env.n2.org1' DLT_SPECIFIC_DIR=$(grep DLT_SPECIFIC_DIR docker-testnet/envs/.env.n2.org1 | cut -d '=' -f 2)
          make deploy COMPOSE_ARG='--env-file docker-testnet/envs/.env.n2.org2' DLT_SPECIFIC_DIR=$(grep DLT_SPECIFIC_DIR docker-testnet/envs/.env.n2.org2 | cut -d '=' -f 2)
        working-directory: weaver/core/identity-management/iin-agent

      # CORDA DRIVER
      - name: Start Corda Driver
        run: make deploy COMPOSE_ARG='--env-file docker-testnet-envs/.env.corda'
        working-directory: weaver/core/drivers/corda-driver

      - name: Start Corda_Network2 Driver
        run: make deploy COMPOSE_ARG='--env-file docker-testnet-envs/.env.corda2'
        working-directory: weaver/core/drivers/corda-driver

      # FABRIC CLI
      - name: Setup Fabric CLI .npmrc
        run: |
          cp .npmrc.template .npmrc
          sed -i "s/<personal-access-token>/${{ secrets.GITHUB_TOKEN }}/g" .npmrc
          cat .npmrc
        working-directory: weaver/samples/fabric/fabric-cli

      - name: Build Fabric CLI
        run: |
          npm install --global yarn
          make build
        working-directory: weaver/samples/fabric/fabric-cli

      - name: Setup Fabric CLI Config
        run: |
          echo ${GITHUB_WORKSPACE}
          cp config.template.json config.json
          sed -i "s#<PATH-TO-WEAVER>#${GITHUB_WORKSPACE}/weaver#g" config.json
        working-directory: weaver/samples/fabric/fabric-cli

      - name: Setup Fabric CLI ENV
        run: |
          echo ${GITHUB_WORKSPACE}
          cp .env.template .env
          sed -i "s/CHAINCODE_PATH=.*/CHAINCODE_PATH=\.\/chaincode\.json/g" .env
          ./bin/fabric-cli env set MEMBER_CREDENTIAL_FOLDER ${GITHUB_WORKSPACE}/weaver/samples/fabric/fabric-cli/src/data/credentials_docker
          ./bin/fabric-cli env set CONFIG_PATH ${GITHUB_WORKSPACE}/weaver/samples/fabric/fabric-cli/config.json
          cat .env
        working-directory: weaver/samples/fabric/fabric-cli

      - name: Fabric CLI Configure ALL
        run: ./bin/fabric-cli configure all network1 network2 --num-orgs=2
        working-directory: weaver/samples/fabric/fabric-cli

      - name: Fabric Sync Membership using IIN Agent
        run: |
          ./bin/fabric-cli configure membership --local-network=network1 --target-network=network2 --iin-agent-endpoint=localhost:9500
          sleep 30
          docker logs iin-agent-Org1MSP-network1
          docker logs iin-agent-Org1MSP-network2
          ./bin/fabric-cli configure membership --local-network=network2 --target-network=network1 --iin-agent-endpoint=localhost:9501
          sleep 30
          docker logs iin-agent-Org1MSP-network1
          docker logs iin-agent-Org1MSP-network2
        working-directory: weaver/samples/fabric/fabric-cli

      # CORDA CLIENT
      - name: Corda CLI Initialize Vault
        run: make initialise-vault-docker
        working-directory: weaver/samples/corda/corda-simple-application

      - name: Data Transfer Corda Client Tests
        run: |
          COUNT=0
          TOTAL=8

          # CORDA-CORDA2
          ./clients/build/install/clients/bin/clients request-state localhost:9081 relay-corda2:9082/Corda_Network2/corda_network2_partya_1:10003#com.cordaSimpleApplication.flow.GetStateByKey:H 1> tmp.out
          cat tmp.out | grep "SimpleState(key=H, value=\[SimpleState(key=H, value=1" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./clients/build/install/clients/bin/clients get-state H 1> tmp.out
          cat tmp.out | grep "SimpleState(key=H, value=\[SimpleState(key=H, value=1" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # CORDA2-CORDA

          NETWORK_NAME=Corda_Network2 CORDA_PORT=30006 ./clients/build/install/clients/bin/clients request-state localhost:9082 relay-corda:9081/Corda_Network/corda_partya_1:10003#com.cordaSimpleApplication.flow.GetStateByKey:C 1> tmp.out
          cat tmp.out | grep "SimpleState(key=C, value=\[SimpleState(key=C, value=6" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          NETWORK_NAME=Corda_Network2 CORDA_PORT=30006 ./clients/build/install/clients/bin/clients get-state C 1> tmp.out
          cat tmp.out | grep "SimpleState(key=C, value=\[SimpleState(key=C, value=6" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # CORDA - FABRIC1
          ./clients/build/install/clients/bin/clients request-state localhost:9081 relay-network1:9080/network1/mychannel:simplestate:Read:a 1> tmp.out
          cat tmp.out | grep "SimpleState(key=a, value=Arcturus" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./clients/build/install/clients/bin/clients get-state a 1> tmp.out
          cat tmp.out | grep "SimpleState(key=a, value=Arcturus" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # CORDA - FABRIC2
          ./clients/build/install/clients/bin/clients request-state localhost:9081 relay-network2:9083/network2/mychannel:simplestate:Read:Arcturus 1> tmp.out
          cat tmp.out | grep "SimpleState(key=Arcturus, value=17.671" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./clients/build/install/clients/bin/clients get-state Arcturus 1> tmp.out
          cat tmp.out | grep "SimpleState(key=Arcturus, value=17.671" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # RESULT
          echo "Passed $COUNT/$TOTAL Tests."

          if [ $COUNT == $TOTAL ]; then
              exit 0
          else
              exit 1
          fi
        working-directory: weaver/samples/corda/corda-simple-application

      # FABRIC CLI
      - name: Data Transfer Fabric CLI Tests
        run: |
          COUNT=0
          TOTAL=12

          # FABRIC2 - FABRIC1
          cp chaincode.json.template chaincode.json
          ./bin/fabric-cli interop --local-network=network2 --requesting-org=Org1MSP relay-network1:9080/network1/mychannel:simplestate:Read:a &> tmp.out
          tail -n 1 tmp.out | grep "Args: a, Arcturus" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query mychannel simplestate read '["a"]' --local-network=network2 &> tmp.out
          tail -n 1 tmp.out | grep "Result from network query: Arcturus" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # FABRIC1 - FABRIC2
          sed -i "s/\"args\"\: \[\"a\"/\"args\"\: \[\"Arcturus\"/g" chaincode.json
          ./bin/fabric-cli interop --local-network=network1 --requesting-org=Org1MSP relay-network2:9083/network2/mychannel:simplestate:Read:Arcturus &> tmp.out
          tail -n 1 tmp.out | grep "Args: Arcturus, 17.671" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # FABRIC2 - FABRIC1 - CONFIDENTIAL
          sed -i "s/\"args\"\: \[\"Arcturus\"/\"args\"\: \[\"b\"/g" chaincode.json
          ./bin/fabric-cli interop --local-network=network2 --requesting-org=Org1MSP --e2e-confidentiality=true relay-network1:9080/network1/mychannel:simplestate:Read:b &> tmp.out
          tail -n 1 tmp.out | grep "Args: b, Betelgeuse" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query mychannel simplestate read '["b"]' --local-network=network2 &> tmp.out
          tail -n 1 tmp.out | grep "Result from network query: Betelgeuse" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # FABRIC1 - FABRIC2 - CONFIDENTIAL
          sed -i "s/\"args\"\: \[\"b\"/\"args\"\: \[\"Betelgeuse\"/g" chaincode.json
          ./bin/fabric-cli interop --local-network=network1 --requesting-org=Org1MSP --e2e-confidentiality=true relay-network2:9083/network2/mychannel:simplestate:Read:Betelgeuse &> tmp.out
          tail -n 1 tmp.out | grep "Args: Betelgeuse, 617.1" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query mychannel simplestate read '["Betelgeuse"]' --local-network=network1 &> tmp.out
          tail -n 1 tmp.out | grep "Result from network query: 617.1" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query mychannel simplestate read '["Arcturus"]' --local-network=network1 &> tmp.out
          tail -n 1 tmp.out | grep "Result from network query: 17.671" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # FABRIC1 - CORDA
          cp chaincode.json.template chaincode.json
          sed -i "s/\"args\"\: \[\"a\"/\"args\"\: \[\"H\"/g" chaincode.json
          ./bin/fabric-cli interop --local-network=network1 --sign=true --requesting-org=Org1MSP relay-corda:9081/Corda_Network/corda_partya_1:10003#com.cordaSimpleApplication.flow.GetStateByKey:H --debug=true &> tmp.out
          tail -n 1 tmp.out | grep "Args: H, \[SimpleState(key=H, value=1" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query mychannel simplestate read '["H"]' --local-network=network1 &> tmp.out
          tail -n 1 tmp.out | grep "Result from network query: \[SimpleState(key=H, value=1" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # FABRIC2 - CORDA
          cp chaincode.json.template chaincode.json
          sed -i "s/\"args\"\: \[\"a\"/\"args\"\: \[\"C\"/g" chaincode.json
          ./bin/fabric-cli interop --local-network=network2 --sign=true --requesting-org=Org1MSP relay-corda:9081/Corda_Network/corda_partya_1:10003#com.cordaSimpleApplication.flow.GetStateByKey:C --debug=true &> tmp.out
          tail -n 1 tmp.out | grep "Args: C, \[SimpleState(key=C, value=6" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query mychannel simplestate read '["C"]' --local-network=network2 &> tmp.out
          tail -n 1 tmp.out | grep "Result from network query: \[SimpleState(key=C, value=6" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out


          # RESULT
          echo "Passed $COUNT/$TOTAL Tests."

          if [ $COUNT == $TOTAL ]; then
              exit 0
          else
              exit 1
          fi
        working-directory: weaver/samples/fabric/fabric-cli

      - if: failure()
        name: DEBUG Logs - corda partya
        run: docker logs corda_partya_1

      - if: failure()
        name: DEBUG Logs - corda network2 partya
        run: docker logs corda_network2_partya_1

      - if: failure()
        name: DEBUG Logs - fabric n1 relay
        run: docker logs relay-network1

      - if: failure()
        name: DEBUG Logs - fabric n2 relay
        run: docker logs relay-network2

      - if: failure()
        name: DEBUG Logs - corda relay
        run: docker logs relay-corda

      - if: failure()
        name: DEBUG Logs - corda2 relay
        run: docker logs relay-corda2

      - if: failure()
        name: DEBUG Logs - fabric n1 driver
        run: docker logs driver-fabric-network1

      - if: failure()
        name: DEBUG Logs - fabric n2 driver
        run: docker logs driver-fabric-network2

      - if: failure()
        name: DEBUG Logs - corda driver
        run: docker logs driver-corda-Corda_Network

      - if: failure()
        name: DEBUG Logs - corda2 driver
        run: docker logs driver-corda-Corda_Network2

      - if: failure()
        name: DEBUG Logs - iin agent n1 org1
        run: docker logs iin-agent-Org1MSP-network1

      - if: failure()
        name: DEBUG Logs - iin agent n2 org1
        run: docker logs iin-agent-Org1MSP-network2

  data-sharing-docker-local:
    needs: check_code_changed
    if:  inputs.run_all == 'true' || needs.check_code_changed.outputs.status == 'true'
    env:
      FREE_UP_GITHUB_RUNNER_DISK_SPACE_DISABLED: false
      CONFIGURE_DISABLED: true
      TOOLS_VALIDATE_BUNDLE_NAMES_DISABLED: true
      CUSTOM_CHECKS_DISABLED: true
      JEST_TEST_RUNNER_DISABLED: true
      TAPE_TEST_RUNNER_DISABLED: true
      DUMP_DISK_USAGE_INFO_DISABLED: true
      FULL_BUILD_DISABLED: true
      CHECK_WORK_TREE_STATUS_DISABLED: true

    # The type of runner that the job will run on
    runs-on: ubuntu-22.04

    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
      # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
      - uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 #v4.1.7

      - uses: dorny/paths-filter@4512585405083f25c027a35db413c2b3b9006d50 #v2.11.1
        id: changes
        with:
          filters: |
            weaver_code_changed:
              - './weaver/**'
              - '.github/workflows/test_weaver-data-sharing.yaml'

      - name: Set up JDK 17
        uses: actions/setup-java@5ffc13f4174014e2d4d4572b3d74c3fa61aeb2c2 #v3.11.0
        with:
          java-version: '17'
          distribution: 'adopt'

      - name: Set up Go
        uses: actions/setup-go@4d34df0c2316fe8122ab82dc22947d607c0c91f9 #v4.0.0
        with:
          go-version: '1.20.2'

      - name: Use Node.js ${{ env.NODEJS_VERSION }}
        uses: actions/setup-node@1e60f620b9541d16bece96c5465dc8ee9832be0b #v4.0.3
        with:
          node-version: ${{ env.NODEJS_VERSION }}

      - name: Use Protoc 3.15
        run: |
          curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v3.15.6/protoc-3.15.6-linux-x86_64.zip
          unzip protoc-3.15.6-linux-x86_64.zip -d protoc
          rm -rf protoc-3.15.6-linux-x86_64.zip
          go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.34.2
          go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.4.0

      - name: CI script for cleanup
        run: ./tools/ci.sh

      # PROTOS
      - name: Build GO Protos
        run: |
          export PATH="$PATH:${GITHUB_WORKSPACE}/protoc/bin"
          make build
        working-directory: weaver/common/protos-go

      # PROTOS
      - name: Build JS Protos
        run: |
          export PATH="$PATH:${GITHUB_WORKSPACE}/protoc/bin"
          make build
        working-directory: weaver/common/protos-js

      - name: Build Java Protos
        run: make build
        working-directory: weaver/common/protos-java-kt

      # Build Dependencies
      - name: Build Corda Interop App
        run: make build-local
        working-directory: weaver/core/network/corda-interop-app

      - name: Build Corda Interop SDK
        run: make build
        working-directory: weaver/sdks/corda

      - name: Build Corda SimpleApplication
        run: make build-local
        working-directory: weaver/samples/corda/corda-simple-application

      - name: Build Fabric Interop SDK
        run: make build-local
        working-directory: weaver/sdks/fabric/interoperation-node-sdk

      - name: Build Fabric CLI
        run: make build-local
        working-directory: weaver/samples/fabric/fabric-cli

      - name: Build Relay
        run: make build-server-local
        working-directory: weaver/core/relay

      - name: Build Fabric Driver
        run: make build-image-local
        working-directory: weaver/core/drivers/fabric-driver

      - name: Build Corda Driver
        run: make image-local
        working-directory: weaver/core/drivers/corda-driver

      - name: Build IIN Agent
        run: make build-image-local
        working-directory: weaver/core/identity-management/iin-agent

      - name: Start Corda Network
        run: make start-local &> corda-net.out &
        working-directory: weaver/tests/network-setups/corda

      # FABRIC NETWORK
      - name: Start Fabric Network
        run: make start-interop-local PROFILE='2-nodes'
        working-directory: weaver/tests/network-setups/fabric/dev

      - name: Corda Network logs
        run: |
          cat tests/network-setups/corda/corda-net.out
          docker logs corda_partya_1
        working-directory: weaver

      # RELAY
      - name: Edit Relay docker compose
        run: make convert-compose-method2
        working-directory: weaver/core/relay

      - name: Start Relay for network1
        run: |
          sed -i "s#^DOCKER_IMAGE_NAME=.*#DOCKER_IMAGE_NAME=cacti-weaver-relay-server#g" docker/testnet-envs/.env.n1
          make start-server COMPOSE_ARG='--env-file docker/testnet-envs/.env.n1'
        working-directory: weaver/core/relay

      - name: Start Relay for network2
        run: |
          sed -i "s#^DOCKER_IMAGE_NAME=.*#DOCKER_IMAGE_NAME=cacti-weaver-relay-server#g" docker/testnet-envs/.env.n2
          make start-server COMPOSE_ARG='--env-file docker/testnet-envs/.env.n2'
        working-directory: weaver/core/relay

      - name: Start Relay for Corda_Network
        run: |
          sed -i "s#^DOCKER_IMAGE_NAME=.*#DOCKER_IMAGE_NAME=cacti-weaver-relay-server#g" docker/testnet-envs/.env.corda
          make start-server COMPOSE_ARG='--env-file docker/testnet-envs/.env.corda'
        working-directory: weaver/core/relay

      - name: Start Relay for Corda_Network2
        run: |
          sed -i "s#^DOCKER_IMAGE_NAME=.*#DOCKER_IMAGE_NAME=cacti-weaver-relay-server#g" docker/testnet-envs/.env.corda2
          make start-server COMPOSE_ARG='--env-file docker/testnet-envs/.env.corda2'
        working-directory: weaver/core/relay

      # FABRIC DRIVER
      - name: Setup Fabric Driver .env
        run: |
          sed -i "s#^DOCKER_IMAGE_NAME=.*#DOCKER_IMAGE_NAME=cacti-weaver-driver-fabric#g" docker-testnet-envs/.env.n1
          sed -i "s#<PATH-TO-WEAVER>#${GITHUB_WORKSPACE}/weaver#g" docker-testnet-envs/.env.n1
          sed -i "s#^DOCKER_IMAGE_NAME=.*#DOCKER_IMAGE_NAME=cacti-weaver-driver-fabric#g" docker-testnet-envs/.env.n2
          sed -i "s#<PATH-TO-WEAVER>#${GITHUB_WORKSPACE}/weaver#g" docker-testnet-envs/.env.n2
        working-directory: weaver/core/drivers/fabric-driver

      - name: Start Fabric Driver for network1
        run: make deploy COMPOSE_ARG='--env-file docker-testnet-envs/.env.n1' NETWORK_NAME=$(grep NETWORK_NAME docker-testnet-envs/.env.n1 | cut -d '=' -f 2)
        working-directory: weaver/core/drivers/fabric-driver

      - name: Start Fabric Driver for network2
        run: make deploy COMPOSE_ARG='--env-file docker-testnet-envs/.env.n2' NETWORK_NAME=$(grep NETWORK_NAME docker-testnet-envs/.env.n2 | cut -d '=' -f 2)
        working-directory: weaver/core/drivers/fabric-driver

      # IIN AGENT
      - name: Setup Fabric IIN Env
        run: |
          sed -i "s#^DOCKER_IMAGE_NAME=.*#DOCKER_IMAGE_NAME=cacti-weaver-iin-agent#g" docker-testnet/envs/.env.n1.org1
          sed -i "s#<PATH-TO-WEAVER>#${GITHUB_WORKSPACE}/weaver#g" docker-testnet/envs/.env.n1.org1
          sed -i "s#^AUTO_SYNC=true#AUTO_SYNC=false#g" docker-testnet/envs/.env.n1.org1
          sed -i "s#^DNS_CONFIG_PATH=.*#DNS_CONFIG_PATH=./docker-testnet/configs/dnsconfig-2-nodes.json#g" docker-testnet/envs/.env.n1.org1
          sed -i "s#^DOCKER_IMAGE_NAME=.*#DOCKER_IMAGE_NAME=cacti-weaver-iin-agent#g" docker-testnet/envs/.env.n1.org2
          sed -i "s#<PATH-TO-WEAVER>#${GITHUB_WORKSPACE}/weaver#g" docker-testnet/envs/.env.n1.org2
          sed -i "s#^AUTO_SYNC=true#AUTO_SYNC=false#g" docker-testnet/envs/.env.n1.org2
          sed -i "s#^DNS_CONFIG_PATH=.*#DNS_CONFIG_PATH=./docker-testnet/configs/dnsconfig-2-nodes.json#g" docker-testnet/envs/.env.n1.org2
          sed -i "s#^DOCKER_IMAGE_NAME=.*#DOCKER_IMAGE_NAME=cacti-weaver-iin-agent#g" docker-testnet/envs/.env.n2.org1
          sed -i "s#<PATH-TO-WEAVER>#${GITHUB_WORKSPACE}/weaver#g" docker-testnet/envs/.env.n2.org1
          sed -i "s#^AUTO_SYNC=true#AUTO_SYNC=false#g" docker-testnet/envs/.env.n2.org1
          sed -i "s#^DNS_CONFIG_PATH=.*#DNS_CONFIG_PATH=./docker-testnet/configs/dnsconfig-2-nodes.json#g" docker-testnet/envs/.env.n2.org1
          sed -i "s#^DOCKER_IMAGE_NAME=.*#DOCKER_IMAGE_NAME=cacti-weaver-iin-agent#g" docker-testnet/envs/.env.n2.org2
          sed -i "s#<PATH-TO-WEAVER>#${GITHUB_WORKSPACE}/weaver#g" docker-testnet/envs/.env.n2.org2
          sed -i "s#^AUTO_SYNC=true#AUTO_SYNC=false#g" docker-testnet/envs/.env.n2.org2
          sed -i "s#^DNS_CONFIG_PATH=.*#DNS_CONFIG_PATH=./docker-testnet/configs/dnsconfig-2-nodes.json#g" docker-testnet/envs/.env.n2.org2
        working-directory: weaver/core/identity-management/iin-agent

      - name: Start Fabric IIN Agent for network1
        run: |
          make deploy COMPOSE_ARG='--env-file docker-testnet/envs/.env.n1.org1' DLT_SPECIFIC_DIR=$(grep DLT_SPECIFIC_DIR docker-testnet/envs/.env.n1.org1 | cut -d '=' -f 2)
          make deploy COMPOSE_ARG='--env-file docker-testnet/envs/.env.n1.org2' DLT_SPECIFIC_DIR=$(grep DLT_SPECIFIC_DIR docker-testnet/envs/.env.n1.org2 | cut -d '=' -f 2)
        working-directory: weaver/core/identity-management/iin-agent

      - name: Start Fabric IIN Agent for network2
        run: |
          make deploy COMPOSE_ARG='--env-file docker-testnet/envs/.env.n2.org1' DLT_SPECIFIC_DIR=$(grep DLT_SPECIFIC_DIR docker-testnet/envs/.env.n2.org1 | cut -d '=' -f 2)
          make deploy COMPOSE_ARG='--env-file docker-testnet/envs/.env.n2.org2' DLT_SPECIFIC_DIR=$(grep DLT_SPECIFIC_DIR docker-testnet/envs/.env.n2.org2 | cut -d '=' -f 2)
        working-directory: weaver/core/identity-management/iin-agent

      # CORDA DRIVER
      - name: Start Corda Driver
        run: |
          sed -i "s#^DOCKER_IMAGE_NAME=.*#DOCKER_IMAGE_NAME=cacti-weaver-driver-corda#g" docker-testnet-envs/.env.corda
          make deploy COMPOSE_ARG='--env-file docker-testnet-envs/.env.corda'
        working-directory: weaver/core/drivers/corda-driver

      - name: Start Corda_Network2 Driver
        run: |
          sed -i "s#^DOCKER_IMAGE_NAME=.*#DOCKER_IMAGE_NAME=cacti-weaver-driver-corda#g" docker-testnet-envs/.env.corda2
          make deploy COMPOSE_ARG='--env-file docker-testnet-envs/.env.corda2'
        working-directory: weaver/core/drivers/corda-driver

      # FABRIC CLI
      - name: Setup Fabric CLI Config
        run: |
          echo ${GITHUB_WORKSPACE}
          cp config.template.json config.json
          sed -i "s#<PATH-TO-WEAVER>#${GITHUB_WORKSPACE}/weaver#g" config.json
        working-directory: weaver/samples/fabric/fabric-cli

      - name: Setup Fabric CLI ENV
        run: |
          echo ${GITHUB_WORKSPACE}
          cp .env.template .env
          sed -i "s/CHAINCODE_PATH=.*/CHAINCODE_PATH=\.\/chaincode\.json/g" .env
          ./bin/fabric-cli env set MEMBER_CREDENTIAL_FOLDER ${GITHUB_WORKSPACE}/weaver/samples/fabric/fabric-cli/src/data/credentials_docker
          ./bin/fabric-cli env set CONFIG_PATH ${GITHUB_WORKSPACE}/weaver/samples/fabric/fabric-cli/config.json
          cat .env
        working-directory: weaver/samples/fabric/fabric-cli

      - name: Fabric CLI Configure ALL
        run: ./bin/fabric-cli configure all network1 network2 --num-orgs=2
        working-directory: weaver/samples/fabric/fabric-cli

      - name: Fabric Sync Membership using IIN Agent
        run: |
          ./bin/fabric-cli configure membership --local-network=network1 --target-network=network2 --iin-agent-endpoint=localhost:9500
          sleep 30
          docker logs --tail 5 iin-agent-Org1MSP-network1
          docker logs --tail 5 iin-agent-Org1MSP-network2
          ./bin/fabric-cli configure membership --local-network=network2 --target-network=network1 --iin-agent-endpoint=localhost:9501
          sleep 30
          docker logs --tail 5 iin-agent-Org1MSP-network1
          docker logs --tail 5 iin-agent-Org1MSP-network2
        working-directory: weaver/samples/fabric/fabric-cli

      - name: Free up Space
        run: |
          df -h .
          docker system prune -a -f
          df -h .
        working-directory: weaver

      # CORDA CLIENT
      - name: Corda CLI Initialize Vault
        run: make initialise-vault-docker
        working-directory: weaver/samples/corda/corda-simple-application

      - name: Data Transfer Corda Client Tests
        run: |
          COUNT=0
          TOTAL=8

          # CORDA-CORDA2
          ./clients/build/install/clients/bin/clients request-state --wkey=H localhost:9081 relay-corda2:9082/Corda_Network2/corda_network2_partya_1:10003#com.cordaSimpleApplication.flow.GetStateByKey:H 1> tmp.out
          cat tmp.out | grep "SimpleState(key=H, value=\[SimpleState(key=H, value=1" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./clients/build/install/clients/bin/clients get-state H 1> tmp.out
          cat tmp.out | grep "SimpleState(key=H, value=\[SimpleState(key=H, value=1" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # CORDA2-CORDA

          NETWORK_NAME=Corda_Network2 CORDA_PORT=30006 ./clients/build/install/clients/bin/clients request-state --wkey=C localhost:9082 relay-corda:9081/Corda_Network/corda_partya_1:10003#com.cordaSimpleApplication.flow.GetStateByKey:C 1> tmp.out
          cat tmp.out | grep "SimpleState(key=C, value=\[SimpleState(key=C, value=6" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          NETWORK_NAME=Corda_Network2 CORDA_PORT=30006 ./clients/build/install/clients/bin/clients get-state C 1> tmp.out
          cat tmp.out | grep "SimpleState(key=C, value=\[SimpleState(key=C, value=6" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # CORDA - FABRIC1
          ./clients/build/install/clients/bin/clients request-state --wkey=a localhost:9081 relay-network1:9080/network1/mychannel:simplestate:Read:a 1> tmp.out
          cat tmp.out | grep "SimpleState(key=a, value=Arcturus" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./clients/build/install/clients/bin/clients get-state a 1> tmp.out
          cat tmp.out | grep "SimpleState(key=a, value=Arcturus" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # CORDA - FABRIC2
          ./clients/build/install/clients/bin/clients request-state --wkey=Arcturus localhost:9081 relay-network2:9083/network2/mychannel:simplestate:Read:Arcturus 1> tmp.out
          cat tmp.out | grep "SimpleState(key=Arcturus, value=17.671" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./clients/build/install/clients/bin/clients get-state Arcturus 1> tmp.out
          cat tmp.out | grep "SimpleState(key=Arcturus, value=17.671" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # RESULT
          echo "Passed $COUNT/$TOTAL Tests."

          if [ $COUNT == $TOTAL ]; then
              exit 0
          else
              exit 1
          fi
        working-directory: weaver/samples/corda/corda-simple-application

      # FABRIC CLI
      - name: Data Transfer Fabric CLI Tests
        run: |
          COUNT=0
          TOTAL=12

          # FABRIC2 - FABRIC1
          cp chaincode.json.template chaincode.json
          ./bin/fabric-cli interop --local-network=network2 --requesting-org=Org1MSP relay-network1:9080/network1/mychannel:simplestate:Read:a &> tmp.out
          tail -n 1 tmp.out | grep "Args: a, Arcturus" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query mychannel simplestate read '["a"]' --local-network=network2 &> tmp.out
          tail -n 1 tmp.out | grep "Result from network query: Arcturus" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # FABRIC1 - FABRIC2
          sed -i "s/\"args\"\: \[\"a\"/\"args\"\: \[\"Arcturus\"/g" chaincode.json
          ./bin/fabric-cli interop --local-network=network1 --requesting-org=Org1MSP relay-network2:9083/network2/mychannel:simplestate:Read:Arcturus &> tmp.out
          tail -n 1 tmp.out | grep "Args: Arcturus, 17.671" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query mychannel simplestate read '["Arcturus"]' --local-network=network1 &> tmp.out
          tail -n 1 tmp.out | grep "Result from network query: 17.671" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # FABRIC2 - FABRIC1 - CONFIDENTIAL
          sed -i "s/\"args\"\: \[\"Arcturus\"/\"args\"\: \[\"b\"/g" chaincode.json
          ./bin/fabric-cli interop --local-network=network2 --requesting-org=Org1MSP --e2e-confidentiality=true relay-network1:9080/network1/mychannel:simplestate:Read:b &> tmp.out
          tail -n 1 tmp.out | grep "Args: b, Betelgeuse" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query mychannel simplestate read '["b"]' --local-network=network2 &> tmp.out
          tail -n 1 tmp.out | grep "Result from network query: Betelgeuse" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # FABRIC1 - FABRIC2 - CONFIDENTIAL
          sed -i "s/\"args\"\: \[\"b\"/\"args\"\: \[\"Betelgeuse\"/g" chaincode.json
          ./bin/fabric-cli interop --local-network=network1 --requesting-org=Org1MSP --e2e-confidentiality=true relay-network2:9083/network2/mychannel:simplestate:Read:Betelgeuse &> tmp.out
          tail -n 1 tmp.out | grep "Args: Betelgeuse, 617.1" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query mychannel simplestate read '["Betelgeuse"]' --local-network=network1 &> tmp.out
          tail -n 1 tmp.out | grep "Result from network query: 617.1" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # FABRIC1 - CORDA
          cp chaincode.json.template chaincode.json
          sed -i "s/\"args\"\: \[\"a\"/\"args\"\: \[\"H\"/g" chaincode.json
          ./bin/fabric-cli interop --local-network=network1 --sign=true --requesting-org=Org1MSP relay-corda:9081/Corda_Network/corda_partya_1:10003#com.cordaSimpleApplication.flow.GetStateByKey:H --debug=true &> tmp.out
          tail -n 1 tmp.out | grep "Args: H, \[SimpleState(key=H, value=1" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query mychannel simplestate read '["H"]' --local-network=network1 &> tmp.out
          tail -n 1 tmp.out | grep "Result from network query: \[SimpleState(key=H, value=1" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # FABRIC2 - CORDA
          cp chaincode.json.template chaincode.json
          sed -i "s/\"args\"\: \[\"a\"/\"args\"\: \[\"C\"/g" chaincode.json
          ./bin/fabric-cli interop --local-network=network2 --sign=true --requesting-org=Org1MSP relay-corda:9081/Corda_Network/corda_partya_1:10003#com.cordaSimpleApplication.flow.GetStateByKey:C --debug=true &> tmp.out
          tail -n 1 tmp.out | grep "Args: C, \[SimpleState(key=C, value=6" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query mychannel simplestate read '["C"]' --local-network=network2 &> tmp.out
          tail -n 1 tmp.out | grep "Result from network query: \[SimpleState(key=C, value=6" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out


          # RESULT
          echo "Passed $COUNT/$TOTAL Tests."

          if [ $COUNT == $TOTAL ]; then
              exit 0
          else
              exit 1
          fi
        working-directory: weaver/samples/fabric/fabric-cli

      - if: failure()
        name: DEBUG Logs - corda partya
        run: docker logs corda_partya_1

      - if: failure()
        name: DEBUG Logs - corda network2 partya
        run: docker logs corda_network2_partya_1

      - if: failure()
        name: DEBUG Logs - fabric n1 relay
        run: docker logs relay-network1

      - if: failure()
        name: DEBUG Logs - fabric n2 relay
        run: docker logs relay-network2

      - if: failure()
        name: DEBUG Logs - corda relay
        run: docker logs relay-corda

      - if: failure()
        name: DEBUG Logs - corda2 relay
        run: docker logs relay-corda2

      - if: failure()
        name: DEBUG Logs - fabric n1 driver
        run: docker logs driver-fabric-network1

      - if: failure()
        name: DEBUG Logs - fabric n2 driver
        run: docker logs driver-fabric-network2

      - if: failure()
        name: DEBUG Logs - corda driver
        run: docker logs driver-corda-Corda_Network

      - if: failure()
        name: DEBUG Logs - corda2 driver
        run: docker logs driver-corda-Corda_Network2

      - if: failure()
        name: DEBUG Logs - iin agent n1 org1
        run: docker logs iin-agent-Org1MSP-network1

      - if: failure()
        name: DEBUG Logs - iin agent n2 org1
        run: docker logs iin-agent-Org1MSP-network2

  data-sharing-local:
    needs: check_code_changed
    if:  inputs.run_all == 'true' || needs.check_code_changed.outputs.status == 'true'
    # if: ${{ false }}
    # The type of runner that the job will run on
    runs-on: ubuntu-22.04

    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
      # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
      - uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 #v4.1.7

      - uses: dorny/paths-filter@4512585405083f25c027a35db413c2b3b9006d50 #v2.11.1
        id: changes
        with:
          filters: |
            weaver_code_changed:
              - './weaver/**'
              - '.github/workflows/test_weaver-data-sharing.yaml'

      - name: Set up JDK 17
        uses: actions/setup-java@5ffc13f4174014e2d4d4572b3d74c3fa61aeb2c2 #v3.11.0
        with:
          java-version: '17'
          distribution: 'adopt'

      - name: Set up Go
        uses: actions/setup-go@4d34df0c2316fe8122ab82dc22947d607c0c91f9 #v4.0.0
        with:
          go-version: '1.20.2'

      - name: Use Node.js ${{ env.NODEJS_VERSION }}
        uses: actions/setup-node@1e60f620b9541d16bece96c5465dc8ee9832be0b #v4.0.3
        with:
          node-version: ${{ env.NODEJS_VERSION }}

      - name: Install RUST Toolchain minimal stable with clippy and rustfmt
        uses: actions-rs/toolchain@b2417cde72dcf67f306c0ae8e0828a81bf0b189f #v1.0.6
        with:
          profile: minimal
          toolchain: stable
          components: rustfmt, clippy

      - name: Get Latest Relay Dependencies
        run: |
          make protos-local
          cargo update -p nom
          cargo update -p lexical-core
        working-directory: weaver/core/relay

      - name: Use Protoc 3.15
        run: |
          curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v3.15.6/protoc-3.15.6-linux-x86_64.zip
          unzip protoc-3.15.6-linux-x86_64.zip -d protoc
          go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.34.2
          go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.4.0

      # PROTOS
      - name: Build GO Protos
        run: |
          export PATH="$PATH:${GITHUB_WORKSPACE}/protoc/bin"
          make build
        working-directory: weaver/common/protos-go

      # PROTOS
      - name: Build JS Protos
        run: |
          export PATH="$PATH:${GITHUB_WORKSPACE}/protoc/bin"
          make build
        working-directory: weaver/common/protos-js

      - name: Build Java Protos
        run: make build
        working-directory: weaver/common/protos-java-kt

      # Build Dependencies
      - name: Build Corda Interop App
        run: make build-local
        working-directory: weaver/core/network/corda-interop-app

      - name: Build Corda Interop SDK
        run: make build
        working-directory: weaver/sdks/corda

      - name: Build Corda SimpleApplication
        run: make build-local
        working-directory: weaver/samples/corda/corda-simple-application

      - name: Build Fabric Interop SDK
        run: make build-local
        working-directory: weaver/sdks/fabric/interoperation-node-sdk

      - name: Build Fabric CLI
        run: make build-local
        working-directory: weaver/samples/fabric/fabric-cli

      - name: Build Relay
        run: make
        working-directory: weaver/core/relay

      - name: Build Fabric Driver
        run: make build-local
        working-directory: weaver/core/drivers/fabric-driver

      - name: Build Corda Driver
        run: make build-local
        working-directory: weaver/core/drivers/corda-driver

      - name: Build IIN Agent
        run: make build-local
        working-directory: weaver/core/identity-management/iin-agent

      # CORDA NETWORK
      - name: Start Corda Network
        run: make start-local &> corda-net.out &
        working-directory: weaver/tests/network-setups/corda

      # FABRIC NETWORK

      - name: Start Fabric Network
        run: make start-interop-local
        working-directory: weaver/tests/network-setups/fabric/dev

      - name: Corda Network logs
        run: |
          cat tests/network-setups/corda/corda-net.out
          docker logs corda_partya_1
        working-directory: weaver

      - name: Free up Space
        run: |
          df -h .
          docker system prune -a -f
          rm -rf ~/.cargo/registry
          df -h .
        working-directory: weaver

      # RELAY
      - name: Start Relay for network1
        run: RELAY_CONFIG=config/Fabric_Relay.toml cargo run --bin server &> relay-n1.out &
        working-directory: weaver/core/relay

      - name: Start Relay for network2
        run: RELAY_CONFIG=config/Fabric_Relay2.toml cargo run --bin server &> relay-n2.out &
        working-directory: weaver/core/relay

      - name: Start Relay for Corda_Network
        run: RELAY_CONFIG=config/Corda_Relay.toml cargo run --bin server &> relay-corda.out &
        working-directory: weaver/core/relay

      - name: Start Relay for Corda_Network2
        run: RELAY_CONFIG=config/Corda_Relay2.toml cargo run --bin server &> relay-corda2.out &
        working-directory: weaver/core/relay

      # FABRIC DRIVER
      - name: Setup Fabric Driver .env
        run: |
          cp .env.template .env
          CCP_PATH=${GITHUB_WORKSPACE}/weaver/tests/network-setups/fabric/shared/network1/peerOrganizations/org1.network1.com/connection-org1.json
          sed -i "s#path_to_connection_profile#${CCP_PATH}#g" .env
        working-directory: weaver/core/drivers/fabric-driver

      - name: Start Fabric Driver for network1
        run: npm run dev &> fdriver-n1.out &
        working-directory: weaver/core/drivers/fabric-driver

      - name: Start Fabric Driver for network2
        run: CONNECTION_PROFILE=${GITHUB_WORKSPACE}/weaver/tests/network-setups/fabric/shared/network2/peerOrganizations/org1.network2.com/connection-org1.json NETWORK_NAME=network2 RELAY_ENDPOINT=localhost:9083 DRIVER_ENDPOINT=localhost:9095 npm run dev &> fdriver-n2.out &
        working-directory: weaver/core/drivers/fabric-driver

      # IIN AGENT
      - name: Setup Fabric IIN Config
        run: |
          # FABRIC CONFIG
          cp src/fabric-ledger/config.json.template src/fabric-ledger/config-n1.json
          CCP_PATH=${GITHUB_WORKSPACE}/weaver/tests/network-setups/fabric/shared/network1/peerOrganizations/org1.network1.com/connection-org1.json
          sed -i "s#<path-to-connection-profile>#${CCP_PATH}#g" src/fabric-ledger/config-n1.json
          cat src/fabric-ledger/config-n1.json
          cp src/fabric-ledger/config.json.template src/fabric-ledger/config-n2.json
          CCP_PATH=${GITHUB_WORKSPACE}/weaver/tests/network-setups/fabric/shared/network2/peerOrganizations/org1.network2.com/connection-org1.json
          sed -i "s#<path-to-connection-profile>#${CCP_PATH}#g" src/fabric-ledger/config-n2.json
          cat src/fabric-ledger/config-n2.json
          # DNS CONFIG
          sed -i "s#iin-agent-Org1MSP-network1#localhost#g" docker-testnet/configs/dnsconfig.json
          sed -i "s#iin-agent-Org1MSP-network2#localhost#g" docker-testnet/configs/dnsconfig.json
          cat docker-testnet/configs/dnsconfig.json
        working-directory: weaver/core/identity-management/iin-agent

      - name: Setup Fabric IIN Env
        run: |
          cp .env.template .env
          sed -i "s#<name-of-iin-agent/org-name>#Org1MSP#g" .env
          sed -i "s#^DLT_TYPE=.*#DLT_TYPE=fabric#g" .env
          sed -i "s#<weaver-contract-name>#interop#g" .env
          sed -i "s#^DNS_CONFIG_PATH=#DNS_CONFIG_PATH=./docker-testnet/configs/dnsconfig.json#g" .env
          sed -i "s#^SECURITY_DOMAIN_CONFIG_PATH=#SECURITY_DOMAIN_CONFIG_PATH=./docker-testnet/configs/security-domain-config.json#g" .env
          sed -i "s#^CONFIG_PATH=#CONFIG_PATH=./src/fabric-ledger/config-n1.json#g" .env
          sed -i "s#^AUTO_SYNC=#AUTO_SYNC=false#g" .env
          cat .env
        working-directory: weaver/core/identity-management/iin-agent

      - name: Start Fabric IIN Agent for network1
        run: npm run dev &> iinagent-n1.out &
        working-directory: weaver/core/identity-management/iin-agent

      - name: Start Fabric IIN Agent for network2
        run: IIN_AGENT_ENDPOINT=localhost:9501 SECURITY_DOMAIN=network2 CONFIG_PATH=./src/fabric-ledger/config-n2.json npm run dev &> iinagent-n2.out &
        working-directory: weaver/core/identity-management/iin-agent

      # CORDA DRIVER
      - name: Start Corda_Network Driver
        run: ./build/install/driver-corda/bin/driver-corda &> corda-driver.out &
        working-directory: weaver/core/drivers/corda-driver

      - name: Start Corda_Network2 Driver
        run: DRIVER_PORT=9098 ./build/install/driver-corda/bin/driver-corda &> corda2-driver.out &
        working-directory: weaver/core/drivers/corda-driver

      # FABRIC CLI
      - name: Setup Fabric CLI Config
        run: |
          echo ${GITHUB_WORKSPACE}
          cp config.template.json config.json
          sed -i "s#<PATH-TO-WEAVER>#${GITHUB_WORKSPACE}/weaver#g" config.json
        working-directory: weaver/samples/fabric/fabric-cli
      - name: Setup Fabric CLI ENV
        run: |
          echo ${GITHUB_WORKSPACE}
          cp .env.template .env
          sed -i "s/CHAINCODE_PATH=.*/CHAINCODE_PATH=\.\/chaincode\.json/g" .env
          ./bin/fabric-cli env set MEMBER_CREDENTIAL_FOLDER ${GITHUB_WORKSPACE}/weaver/samples/fabric/fabric-cli/src/data/credentials
          ./bin/fabric-cli env set CONFIG_PATH ${GITHUB_WORKSPACE}/weaver/samples/fabric/fabric-cli/config.json
          cat .env
          cp chaincode.json.template chaincode.json
        working-directory: weaver/samples/fabric/fabric-cli

      - name: Fabric CLI Configure ALL
        run: ./bin/fabric-cli configure all network1 network2
        working-directory: weaver/samples/fabric/fabric-cli

      - name: Fabric Sync Membership using IIN Agent
        run: |
          ./bin/fabric-cli configure membership --local-network=network1 --target-network=network2 --iin-agent-endpoint=localhost:9500
          sleep 10
          tail -5 ../../../core/identity-management/iin-agent/iinagent-n1.out
          ./bin/fabric-cli configure membership --local-network=network2 --target-network=network1 --iin-agent-endpoint=localhost:9501
          sleep 10
          tail -5 ../../../core/identity-management/iin-agent/iinagent-n2.out
        working-directory: weaver/samples/fabric/fabric-cli

      # CORDA CLIENT
      - name: Corda CLI Initialize Vault
        run: make initialise-vault
        working-directory: weaver/samples/corda/corda-simple-application

      - name: Data Transfer Corda Client Tests
        run: |
          COUNT=0
          TOTAL=8

          # CORDA-CORDA2
          ./clients/build/install/clients/bin/clients request-state --wkey=H localhost:9081 localhost:9082/Corda_Network2/localhost:30006#com.cordaSimpleApplication.flow.GetStateByKey:H 1> tmp.out
          cat tmp.out | grep "SimpleState(key=H, value=\[SimpleState(key=H, value=1" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./clients/build/install/clients/bin/clients get-state H 1> tmp.out
          cat tmp.out | grep "SimpleState(key=H, value=\[SimpleState(key=H, value=1" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # CORDA2-CORDA

          NETWORK_NAME=Corda_Network2 CORDA_PORT=30006 ./clients/build/install/clients/bin/clients request-state --wkey=C localhost:9082 localhost:9081/Corda_Network/localhost:10006#com.cordaSimpleApplication.flow.GetStateByKey:C 1> tmp.out
          cat tmp.out | grep "SimpleState(key=C, value=\[SimpleState(key=C, value=6" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          NETWORK_NAME=Corda_Network2 CORDA_PORT=30006 ./clients/build/install/clients/bin/clients get-state C 1> tmp.out
          cat tmp.out | grep "SimpleState(key=C, value=\[SimpleState(key=C, value=6" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # CORDA - FABRIC1
          ./clients/build/install/clients/bin/clients request-state --wkey=a localhost:9081 localhost:9080/network1/mychannel:simplestate:Read:a 1> tmp.out
          cat tmp.out | grep "SimpleState(key=a, value=Arcturus" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./clients/build/install/clients/bin/clients get-state a 1> tmp.out
          cat tmp.out | grep "SimpleState(key=a, value=Arcturus" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # CORDA - FABRIC2
          ./clients/build/install/clients/bin/clients request-state --wkey=Arcturus localhost:9081 localhost:9083/network2/mychannel:simplestate:Read:Arcturus 1> tmp.out
          cat tmp.out | grep "SimpleState(key=Arcturus, value=17.671" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./clients/build/install/clients/bin/clients get-state Arcturus 1> tmp.out
          cat tmp.out | grep "SimpleState(key=Arcturus, value=17.671" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # RESULT
          echo "Passed $COUNT/$TOTAL Tests."

          if [ $COUNT == $TOTAL ]; then
              exit 0
          else
              exit 1
          fi
        working-directory: weaver/samples/corda/corda-simple-application

      # FABRIC CLI
      - name: Data Transfer Fabric CLI Tests
        run: |
          COUNT=0
          TOTAL=12

          # FABRIC2 - FABRIC1
          cp chaincode.json.template chaincode.json
          ./bin/fabric-cli interop --local-network=network2 --requesting-org=Org1MSP localhost:9080/network1/mychannel:simplestate:Read:a &> tmp.out
          tail -n 1 tmp.out | grep "Args: a, Arcturus" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query mychannel simplestate read '["a"]' --local-network=network2 &> tmp.out
          tail -n 1 tmp.out | grep "Result from network query: Arcturus" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # FABRIC2 - FABRIC1 - CONFIDENTIAL
          sed -i "s/\"args\"\: \[\"a\"/\"args\"\: \[\"b\"/g" chaincode.json
          ./bin/fabric-cli interop --local-network=network2 --requesting-org=Org1MSP --e2e-confidentiality=true localhost:9080/network1/mychannel:simplestate:Read:b &> tmp.out
          tail -n 1 tmp.out | grep "Args: b, Betelgeuse" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query mychannel simplestate read '["b"]' --local-network=network2 &> tmp.out
          tail -n 1 tmp.out | grep "Result from network query: Betelgeuse" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # FABRIC1 - FABRIC2
          sed -i "s/\"args\"\: \[\"b\"/\"args\"\: \[\"Arcturus\"/g" chaincode.json
          ./bin/fabric-cli interop --local-network=network1 --requesting-org=Org1MSP localhost:9083/network2/mychannel:simplestate:Read:Arcturus &> tmp.out
          tail -n 1 tmp.out | grep "Args: Arcturus, 17.671" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query mychannel simplestate read '["Arcturus"]' --local-network=network1 &> tmp.out
          tail -n 1 tmp.out | grep "Result from network query: 17.671" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # FABRIC1 - FABRIC2 - CONFIDENTIAL
          sed -i "s/\"args\"\: \[\"Arcturus\"/\"args\"\: \[\"Betelgeuse\"/g" chaincode.json
          ./bin/fabric-cli interop --local-network=network1 --requesting-org=Org1MSP --e2e-confidentiality=true localhost:9083/network2/mychannel:simplestate:Read:Betelgeuse &> tmp.out
          tail -n 1 tmp.out | grep "Args: Betelgeuse, 617.1" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query mychannel simplestate read '["Betelgeuse"]' --local-network=network1 &> tmp.out
          tail -n 1 tmp.out | grep "Result from network query: 617.1" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # FABRIC1 - CORDA
          cp chaincode.json.template chaincode.json
          sed -i "s/\"args\"\: \[\"a\"/\"args\"\: \[\"H\"/g" chaincode.json
          ./bin/fabric-cli interop --local-network=network1 --sign=true --requesting-org=Org1MSP localhost:9081/Corda_Network/localhost:10006#com.cordaSimpleApplication.flow.GetStateByKey:H --debug=true &> tmp.out
          tail -n 1 tmp.out | grep "Args: H, \[SimpleState(key=H, value=1" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query mychannel simplestate read '["H"]' --local-network=network1 &> tmp.out
          tail -n 1 tmp.out | grep "Result from network query: \[SimpleState(key=H, value=1" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # FABRIC2 - CORDA
          cp chaincode.json.template chaincode.json
          sed -i "s/\"args\"\: \[\"a\"/\"args\"\: \[\"C\"/g" chaincode.json
          ./bin/fabric-cli interop --local-network=network2 --sign=true --requesting-org=Org1MSP localhost:9081/Corda_Network/localhost:10006#com.cordaSimpleApplication.flow.GetStateByKey:C --debug=true --debug=true &> tmp.out
          tail -n 1 tmp.out | grep "Args: C, \[SimpleState(key=C, value=6" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query mychannel simplestate read '["C"]' --local-network=network2 &> tmp.out
          tail -n 1 tmp.out | grep "Result from network query: \[SimpleState(key=C, value=6" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out


          # RESULT
          echo "Passed $COUNT/$TOTAL Tests."

          if [ $COUNT == $TOTAL ]; then
              exit 0
          else
              exit 1
          fi
        working-directory: weaver/samples/fabric/fabric-cli

      - if: failure()
        name: DEBUG Logs - corda partya
        run: docker logs corda_partya_1

      - if: failure()
        name: DEBUG Logs - corda network2 partya
        run: docker logs corda_network2_partya_1

      - if: failure()
        name: DEBUG Logs - fabric n1 relay
        run: cat weaver/core/relay/relay-n1.out

      - if: failure()
        name: DEBUG Logs - fabric n2 relay
        run: cat weaver/core/relay/relay-n2.out

      - if: failure()
        name: DEBUG Logs - corda relay
        run: cat weaver/core/relay/relay-corda.out

      - if: failure()
        name: DEBUG Logs - corda2 relay
        run: cat weaver/core/relay/relay-corda2.out

      - if: failure()
        name: DEBUG Logs - fabric n1 driver
        run: cat weaver/core/drivers/fabric-driver/fdriver-n1.out

      - if: failure()
        name: DEBUG Logs - fabric n2 driver
        run: cat weaver/core/drivers/fabric-driver/fdriver-n2.out

      - if: failure()
        name: DEBUG Logs - corda driver
        run: cat weaver/core/drivers/corda-driver/corda-driver.out

      - if: failure()
        name: DEBUG Logs - corda2 driver
        run: cat weaver/core/drivers/corda-driver/corda2-driver.out

      - if: failure()
        name: DEBUG Logs - iin agent n1 org1
        run: cat weaver/core/identity-management/iin-agent/iinagent-n1.out

      - if: failure()
        name: DEBUG Logs - iin agent n2 org1
        run: cat weaver/core/identity-management/iin-agent/iinagent-n2.out

```


--- FILE: .github/workflows/test_weaver-asset-transfer.yaml ---
```yaml
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: CC-BY-4.0

# This is a basic workflow to help you get started with Actions

name: Test Asset Transfer

env:
  NODEJS_VERSION: v22.18.0

# Controls when the workflow will run
on:
  # Triggers the workflow on push or pull request events but only for the main branch
  workflow_call:
    inputs:
      run_all:
        required: true
        type: string

concurrency:
  group: asset-transfer-${{ github.workflow }}-${{ github.event.pull_request.number || github.ref }}
  cancel-in-progress: true

# A workflow run is made up of one or more jobs that can run sequentially or in parallel
jobs:
  check_code_changed:
    outputs:
      status: ${{ steps.changes.outputs.weaver_code_changed }}
    runs-on: ubuntu-22.04
    steps:
      - uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 #v4.1.7

      - uses: dorny/paths-filter@4512585405083f25c027a35db413c2b3b9006d50 #v2.11.1
        id: changes
        with:
          filters: |
            weaver_code_changed:
              - './weaver/**'
              - '.github/workflows/test_weaver-asset-transfer.yaml'

  asset-transfer:
    needs: check_code_changed
    if: ${{ false && needs.check_code_changed.outputs.status == 'true' }}
    # The type of runner that the job will run on
    runs-on: ubuntu-22.04

    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
      # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
      - uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 #v4.1.7

      - name: Set up JDK 17
        uses: actions/setup-java@5ffc13f4174014e2d4d4572b3d74c3fa61aeb2c2 #v3.11.0
        with:
          java-version: '17'
          distribution: 'adopt'

      - name: Set up Go
        uses: actions/setup-go@4d34df0c2316fe8122ab82dc22947d607c0c91f9 #v4.0.0
        with:
          go-version: '1.20.2'

      - name: Use Node.js ${{ env.NODEJS_VERSION }}
        uses: actions/setup-node@1e60f620b9541d16bece96c5465dc8ee9832be0b #v4.0.3
        with:
          node-version: ${{ env.NODEJS_VERSION }}

      # CORDA NETWORK
      - name: Generate github.properties
        run: |
          echo "Using ${GITHUB_ACTOR} user."
          echo "username=${GITHUB_ACTOR}" >> github.properties
          echo "password=${{ secrets.GITHUB_TOKEN }}" >> github.properties
          echo "url=https://maven.pkg.github.com/${GITHUB_ACTOR}/cacti" >> github.properties

          echo "Using ${GITHUB_ACTOR} user."
          echo "username=${GITHUB_ACTOR}" >> github.main.properties
          echo "password=${{ secrets.GITHUB_TOKEN }}" >> github.main.properties
          echo "url=https://maven.pkg.github.com/hyperledger-cacti/cacti" >> github.main.properties

          ./scripts/get-cordapps.sh || mv github.main.properties github.properties

          cat github.properties
        working-directory: weaver/tests/network-setups/corda

      - name: Start Corda Network
        run: make start &> corda-net.out &
        working-directory: weaver/tests/network-setups/corda

      # FABRIC NETWORK
      - name: Start Fabric Network
        run: make start-interop CHAINCODE_NAME=simpleassettransfer PROFILE='2-nodes'
        working-directory: weaver/tests/network-setups/fabric/dev

      - name: Corda Network logs
        run: |
          cat tests/network-setups/corda/corda-net.out
          docker logs corda_partya_1
          docker logs corda_network2_partya_1
        working-directory: weaver

      # RELAY
      - name: Edit Relay docker compose
        run: make convert-compose-method2
        working-directory: weaver/core/relay

      - name: Start Relay for network1
        run: make start-server COMPOSE_ARG='--env-file docker/testnet-envs/.env.n1'
        working-directory: weaver/core/relay

      - name: Start Relay for network2
        run: make start-server COMPOSE_ARG='--env-file docker/testnet-envs/.env.n2'
        working-directory: weaver/core/relay

      - name: Start Relay for Corda_Network
        run: make start-server COMPOSE_ARG='--env-file docker/testnet-envs/.env.corda'
        working-directory: weaver/core/relay

      - name: Start Relay for Corda_Network2
        run: make start-server COMPOSE_ARG='--env-file docker/testnet-envs/.env.corda2'
        working-directory: weaver/core/relay

      # FABRIC DRIVER
      - name: Setup Fabric Driver .env
        run: |
          sed -i "s#<PATH-TO-WEAVER>#${GITHUB_WORKSPACE}/weaver#g" docker-testnet-envs/.env.n1
          sed -i "s#<PATH-TO-WEAVER>#${GITHUB_WORKSPACE}/weaver#g" docker-testnet-envs/.env.n2
        working-directory: weaver/core/drivers/fabric-driver

      - name: Start Fabric Driver for network1
        run: make deploy COMPOSE_ARG='--env-file docker-testnet-envs/.env.n1' NETWORK_NAME=$(grep NETWORK_NAME docker-testnet-envs/.env.n1 | cut -d '=' -f 2)
        working-directory: weaver/core/drivers/fabric-driver

      - name: Start Fabric Driver for network2
        run: make deploy COMPOSE_ARG='--env-file docker-testnet-envs/.env.n2' NETWORK_NAME=$(grep NETWORK_NAME docker-testnet-envs/.env.n2 | cut -d '=' -f 2)
        working-directory: weaver/core/drivers/fabric-driver

      # IIN AGENT
      - name: Setup Fabric IIN Env
        run: |
          sed -i "s#<PATH-TO-WEAVER>#${GITHUB_WORKSPACE}/weaver#g" docker-testnet/envs/.env.n1.org1
          sed -i "s#^AUTO_SYNC=true#AUTO_SYNC=false#g" docker-testnet/envs/.env.n1.org1
          sed -i "s#^DNS_CONFIG_PATH=.*#DNS_CONFIG_PATH=./docker-testnet/configs/dnsconfig-2-nodes.json#g" docker-testnet/envs/.env.n1.org1
          sed -i "s#<PATH-TO-WEAVER>#${GITHUB_WORKSPACE}/weaver#g" docker-testnet/envs/.env.n1.org2
          sed -i "s#^AUTO_SYNC=true#AUTO_SYNC=false#g" docker-testnet/envs/.env.n1.org2
          sed -i "s#^DNS_CONFIG_PATH=.*#DNS_CONFIG_PATH=./docker-testnet/configs/dnsconfig-2-nodes.json#g" docker-testnet/envs/.env.n1.org2
          sed -i "s#<PATH-TO-WEAVER>#${GITHUB_WORKSPACE}/weaver#g" docker-testnet/envs/.env.n2.org1
          sed -i "s#^AUTO_SYNC=true#AUTO_SYNC=false#g" docker-testnet/envs/.env.n2.org1
          sed -i "s#^DNS_CONFIG_PATH=.*#DNS_CONFIG_PATH=./docker-testnet/configs/dnsconfig-2-nodes.json#g" docker-testnet/envs/.env.n2.org1
          sed -i "s#<PATH-TO-WEAVER>#${GITHUB_WORKSPACE}/weaver#g" docker-testnet/envs/.env.n2.org2
          sed -i "s#^AUTO_SYNC=true#AUTO_SYNC=false#g" docker-testnet/envs/.env.n2.org2
          sed -i "s#^DNS_CONFIG_PATH=.*#DNS_CONFIG_PATH=./docker-testnet/configs/dnsconfig-2-nodes.json#g" docker-testnet/envs/.env.n2.org2
        working-directory: weaver/core/identity-management/iin-agent

      - name: Start Fabric IIN Agent for network1
        run: |
          make deploy COMPOSE_ARG='--env-file docker-testnet/envs/.env.n1.org1' DLT_SPECIFIC_DIR=$(grep DLT_SPECIFIC_DIR docker-testnet/envs/.env.n1.org1 | cut -d '=' -f 2)
          make deploy COMPOSE_ARG='--env-file docker-testnet/envs/.env.n1.org2' DLT_SPECIFIC_DIR=$(grep DLT_SPECIFIC_DIR docker-testnet/envs/.env.n1.org2 | cut -d '=' -f 2)
        working-directory: weaver/core/identity-management/iin-agent

      - name: Start Fabric IIN Agent for network2
        run: |
          make deploy COMPOSE_ARG='--env-file docker-testnet/envs/.env.n2.org1' DLT_SPECIFIC_DIR=$(grep DLT_SPECIFIC_DIR docker-testnet/envs/.env.n2.org1 | cut -d '=' -f 2)
          make deploy COMPOSE_ARG='--env-file docker-testnet/envs/.env.n2.org2' DLT_SPECIFIC_DIR=$(grep DLT_SPECIFIC_DIR docker-testnet/envs/.env.n2.org2 | cut -d '=' -f 2)
        working-directory: weaver/core/identity-management/iin-agent

      # CORDA DRIVER
      - name: Start Corda Driver
        run: make deploy COMPOSE_ARG='--env-file docker-testnet-envs/.env.corda'
        working-directory: weaver/core/drivers/corda-driver

      - name: Start Corda_Network2 Driver
        run: make deploy COMPOSE_ARG='--env-file docker-testnet-envs/.env.corda2'
        working-directory: weaver/core/drivers/corda-driver

      # FABRIC CLI
      - name: Setup Fabric CLI .npmrc
        run: |
          cp .npmrc.template .npmrc
          sed -i "s/<personal-access-token>/${{ secrets.GITHUB_TOKEN }}/g" .npmrc
          cat .npmrc
        working-directory: weaver/samples/fabric/fabric-cli

      - name: Build Fabric CLI
        run: |
          npm install --global yarn
          make build
        working-directory: weaver/samples/fabric/fabric-cli

      # FABRIC CLI
      - name: Setup Fabric CLI ENV
        run: |
          echo ${GITHUB_WORKSPACE}
          cp .env.template .env
          ./bin/fabric-cli env set-file ./.env
          ./bin/fabric-cli env set MEMBER_CREDENTIAL_FOLDER ${GITHUB_WORKSPACE}/weaver/samples/fabric/fabric-cli/src/data/credentials_docker
          ./bin/fabric-cli env set CONFIG_PATH ${GITHUB_WORKSPACE}/weaver/samples/fabric/fabric-cli/config.json
          ./bin/fabric-cli env set DEFAULT_APPLICATION_CHAINCODE simpleassettransfer
          ./bin/fabric-cli env set REMOTE_CONFIG_PATH ${GITHUB_WORKSPACE}/weaver/samples/fabric/fabric-cli/remote-network-config.json
          ./bin/fabric-cli env set CHAINCODE_PATH ${GITHUB_WORKSPACE}/weaver/samples/fabric/fabric-cli/chaincode.json
          cat .env
        working-directory: weaver/samples/fabric/fabric-cli

      - name: Setup Fabric CLI Config
        run: |
          echo ${GITHUB_WORKSPACE}
          cp config.template.json config.json
          sed -i "s#<PATH-TO-WEAVER>#${GITHUB_WORKSPACE}/weaver#g" config.json
          ./bin/fabric-cli config set network2 aclPolicyPrincipalType ca
          ./bin/fabric-cli config set network1 chaincode simpleassettransfer
          ./bin/fabric-cli config set network2 chaincode simpleassettransfer
          cp chaincode.json.template chaincode.json
          cp remote-network-config.json.template remote-network-config.json
          sed -i "s#localhost:9080#relay-network1:9080#g" remote-network-config.json
          sed -i "s#localhost:9081#relay-corda:9081#g" remote-network-config.json
          sed -i "s#localhost:9082#relay-corda2:9082#g" remote-network-config.json
          sed -i "s#localhost:9083#relay-network2:9083#g" remote-network-config.json
          sed -i "s#localhost:10006#corda_partya_1:10003#g" remote-network-config.json
          sed -i "s#localhost:30006#corda_network2_partya_1:10003#g" remote-network-config.json
        working-directory: weaver/samples/fabric/fabric-cli

      - name: Fabric CLI Init
        run: |
          ./bin/fabric-cli configure create all --local-network=network1
          ./bin/fabric-cli configure create all --local-network=network2
          ./bin/fabric-cli configure network --local-network=network1 --num-orgs=2
          ./bin/fabric-cli configure network --local-network=network2 --num-orgs=2
          ./scripts/initAssetsForTransfer.sh
        working-directory: weaver/samples/fabric/fabric-cli

      - name: Fabric Sync Membership using IIN Agent
        run: |
          ./bin/fabric-cli configure membership --local-network=network1 --target-network=network2 --iin-agent-endpoint=localhost:9500
          sleep 30
          docker logs iin-agent-Org1MSP-network1
          docker logs iin-agent-Org1MSP-network2
          ./bin/fabric-cli configure membership --local-network=network2 --target-network=network1 --iin-agent-endpoint=localhost:9501
          sleep 30
          docker logs iin-agent-Org1MSP-network1
          docker logs iin-agent-Org1MSP-network2
        working-directory: weaver/samples/fabric/fabric-cli

      # CORDA CLIENT
      - name: Corda CLI Setup
        run: |
          cp remote-network-config.json.template remote-network-config.json
          sed -i "s#localhost:9080#relay-network1:9080#g" remote-network-config.json
          sed -i "s#localhost:9081#relay-corda:9081#g" remote-network-config.json
          sed -i "s#localhost:9082#relay-corda2:9082#g" remote-network-config.json
          sed -i "s#localhost:9083#relay-network2:9083#g" remote-network-config.json
          sed -i "s#localhost:10006#corda_partya_1:10003#g" remote-network-config.json
          sed -i "s#localhost:30006#corda_network2_partya_1:10003#g" remote-network-config.json
        working-directory: weaver/samples/corda/corda-simple-application/clients/src/main/resources/config

      - name: Corda CLI Initialize Vault
        run: make initialise-vault-asset-transfer-docker
        working-directory: weaver/samples/corda/corda-simple-application

      - name: Asset Transfer Corda Client Tests
        run: |
          COUNT=0
          TOTAL=9

          # Issue t1:5 tokens to partyA
          NETWORK_NAME='Corda_Network' CORDA_PORT=10006 ./clients/build/install/clients/bin/clients issue-asset-state 5 t1 1> tmp.out
          cat tmp.out | grep "AssetState(quantity=5, tokenType=t1, owner=O=PartyA" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # CORDA2-CORDA
          # Pledge Asset
          NETWORK_NAME='Corda_Network' CORDA_PORT=10006 ./clients/build/install/clients/bin/clients transfer pledge-asset --fungible --timeout="3600" --import-network-id='Corda_Network2' --recipient='O=PartyA, L=London, C=GB' --param='t1:5' 1> tmp.out
          cat tmp.out | grep "AssetPledgeState created with pledge-id" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          PID=$(cat tmp.out | grep "AssetPledgeState created with pledge-id " | awk -F "'" '{print $2}')

          # Is Asset Pledged
          CORDA_PORT=10006 ./clients/build/install/clients/bin/clients transfer is-asset-pledged -pid $PID 1> tmp.out
          cat tmp.out | grep "Is asset pledged for transfer response: true" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # Claim Remote Asset
          NETWORK_NAME='Corda_Network2' CORDA_PORT=30006 ./clients/build/install/clients/bin/clients transfer claim-remote-asset --pledge-id=$PID --locker='O=PartyA, L=London, C=GB' --transfer-category='token.corda' --export-network-id='Corda_Network' --param='t1:5' --import-relay-address='localhost:9082' 1> tmp.out
          cat tmp.out | grep "Pledged asset claim response: Right(b=SignedTransaction(id=" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          CORDA_PORT=10006 ./clients/build/install/clients/bin/clients get-asset-states-by-type t1 1> tmp.out
          cat tmp.out | grep "\[\]" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out
          CORDA_PORT=30006 ./clients/build/install/clients/bin/clients get-asset-states-by-type t1 1> tmp.out
          cat tmp.out | grep "AssetState(quantity=5, tokenType=t1, owner=O=PartyA, L=London, C=GB, " && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # CORDA-CORDA2

          # Issue and Pledge t2:5 tokens
          NETWORK_NAME='Corda_Network' CORDA_PORT=10006 ./clients/build/install/clients/bin/clients issue-asset-state 5 t2 1> tmp.out
          NETWORK_NAME='Corda_Network' CORDA_PORT=10006 ./clients/build/install/clients/bin/clients transfer pledge-asset --fungible --timeout="20" --import-network-id='Corda_Network2' --recipient='O=PartyA, L=London, C=GB' --param='t2:5' 1> tmp.out
          PID=$(cat tmp.out | grep "AssetPledgeState created with pledge-id " | awk -F "'" '{print $2}')
          sleep 20

          # Is Asset Pledged
          CORDA_PORT=10006 ./clients/build/install/clients/bin/clients transfer is-asset-pledged -pid $PID 1> tmp.out
          cat tmp.out | grep "Is asset pledged for transfer response: false" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          NETWORK_NAME=Corda_Network CORDA_PORT=10006 ./clients/build/install/clients/bin/clients transfer reclaim-pledged-asset --pledge-id=$PID --export-relay-address='localhost:9081' --transfer-category='token.corda' --import-network-id='Corda_Network2' --param='t2:5' 1> tmp.out
          cat tmp.out | grep "Pledged Asset Reclaim Response: Right(b=SignedTransaction(id=" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          CORDA_PORT=10006 ./clients/build/install/clients/bin/clients get-asset-states-by-type t2 1> tmp.out
          cat tmp.out | grep "AssetState(quantity=5, tokenType=t2, owner=O=PartyA, L=London, C=GB, " && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # RESULT
          echo "Passed $COUNT/$TOTAL Tests."

          if [ $COUNT == $TOTAL ]; then
              exit 0
          else
              exit 1
          fi
        working-directory: weaver/samples/corda/corda-simple-application

      # FABRIC CLI
      - name: Asset Transfer Fabric CLI Non-Fungible Tests
        run: |
          COUNT=0
          TOTAL=8

          # FABRIC2 - FABRIC1
          ./bin/fabric-cli asset transfer pledge --source-network=network1 --dest-network=network2 --recipient=bob --expiry-secs=3600 --type=bond --ref=a03 --data-file=src/data/assetsForTransfer.json &> tmp.out
          tail -n 1 tmp.out | grep "Asset pledged with ID" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          CID=$(cat tmp.out | grep "Asset pledged with ID " | sed -e 's/Asset pledged with ID //')

          # FABRIC1 - FABRIC2
          ./bin/fabric-cli asset transfer claim --source-network=network1 --dest-network=network2 --user=bob --owner=alice --type=bond.fabric --pledge-id=$CID --param=bond01:a03 &> tmp.out
          tail -n 1 tmp.out | grep "Called Function ClaimRemoteAsset. With Args: $CID" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query --user=alice mychannel simpleassettransfer ReadAsset '["bond01","a03"]' --local-network=network1 &> tmp.out
          tail -n 2 tmp.out | grep "Error: the asset a03 does not exist" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query --user=bob mychannel simpleassettransfer ReadAsset '["bond01","a03"]' --local-network=network2 &> tmp.out
          #tail -n 1 tmp.out | grep "Result from network query: {\"type\":\"bond01\",\"id\":\"a03\"" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out | tr '\n' ' ' | grep "Result from network query: {     \"type\": \"bond01\",     \"id\": \"a03\"" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli asset transfer pledge --source-network=network1 --dest-network=network2 --recipient=bob --expiry-secs=20 --type=bond --ref=a04 --data-file=src/data/assetsForTransfer.json &> tmp.out
          cat tmp.out

          CID=$(cat tmp.out | grep "Asset pledged with ID " | sed -e 's/Asset pledged with ID //')
          sleep 20

          ./bin/fabric-cli asset transfer claim --source-network=network1 --dest-network=network2 --user=bob --owner=alice --type=bond.fabric --pledge-id=$CID --param=bond01:a04 &> tmp.out
          tail -n 1 tmp.out | grep "cannot claim asset with pledgeId $CID as the expiry time has elapsed" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli asset transfer reclaim --source-network=network1 --user=alice --type=bond.fabric --pledge-id=$CID --param=bond01:a04 &> tmp.out
          tail -n 1 tmp.out | grep "Called Function ReclaimAsset. With Args: $CID" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query --user=alice mychannel simpleassettransfer ReadAsset '["bond01","a04"]' --local-network=network1 &> tmp.out
          #tail -n 1 tmp.out | grep "Result from network query: {\"type\":\"bond01\",\"id\":\"a04\"" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out | tr '\n' ' ' | grep "Result from network query: {     \"type\": \"bond01\",     \"id\": \"a04\"" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query --user=bob mychannel simpleassettransfer ReadAsset '["bond01","a04"]' --local-network=network2 &> tmp.out
          tail -n 2 tmp.out | grep "Error: the asset a04 does not exist" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # RESULT
          echo "Passed $COUNT/$TOTAL Tests."

          if [ $COUNT == $TOTAL ]; then
              exit 0
          else
              exit 1
          fi
        working-directory: weaver/samples/fabric/fabric-cli

      # FABRIC CLI
      - name: Asset Transfer Fabric CLI Fungible Tests
        run: |
          COUNT=0
          TOTAL=8

          # FABRIC2 - FABRIC1
          ./bin/fabric-cli asset transfer pledge --source-network=network1 --dest-network=network2 --recipient=bob --expiry-secs=3600 --type=token --units=50 --owner=alice --data-file=src/data/tokensForTransfer.json &> tmp.out
          tail -n 1 tmp.out | grep "Asset pledged with ID" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          CID=$(cat tmp.out | grep "Asset pledged with ID " | sed -e 's/Asset pledged with ID //')

          # FABRIC1 - FABRIC2
          ./bin/fabric-cli asset transfer claim --source-network=network1 --dest-network=network2 --user=bob --owner=alice --type=token.fabric --pledge-id=$CID --param=token1:50 &> tmp.out
          tail -n 1 tmp.out | grep "Called Function ClaimRemoteTokenAsset. With Args: $CID" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query --user=alice mychannel simpleassettransfer GetMyWallet '[]' --local-network=network1 &> tmp.out
          tail -n 2 tmp.out | grep "Result from network query: token1=\"9950\"" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query --user=bob mychannel simpleassettransfer GetMyWallet '[]' --local-network=network2 &> tmp.out
          tail -n 2 tmp.out | grep "Result from network query: token1=\"50\"" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli asset transfer pledge --source-network=network1 --dest-network=network2 --recipient=bob --expiry-secs=20 --type=token --units=100 --owner=alice --data-file=src/data/tokensForTransfer.json &> tmp.out
          cat tmp.out

          CID=$(cat tmp.out | grep "Asset pledged with ID " | sed -e 's/Asset pledged with ID //')
          sleep 20

          ./bin/fabric-cli asset transfer claim --source-network=network1 --dest-network=network2 --user=bob --owner=alice --type=token.fabric --pledge-id=$CID --param=token1:100 &> tmp.out
          tail -n 1 tmp.out | grep "cannot claim asset with pledgeId $CID as the expiry time has elapsed" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli asset transfer reclaim --source-network=network1 --user=alice --type=token.fabric --pledge-id=$CID --param=token1:100 &> tmp.out
          tail -n 1 tmp.out | grep "Called Function ReclaimTokenAsset. With Args: $CID" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query --user=alice mychannel simpleassettransfer GetMyWallet '[]' --local-network=network1 &> tmp.out
          tail -n 2 tmp.out | grep "Result from network query: token1=\"9950\"" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query --user=bob mychannel simpleassettransfer GetMyWallet '[]' --local-network=network2 &> tmp.out
          tail -n 2 tmp.out | grep "Result from network query: token1=\"50\"" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # RESULT
          echo "Passed $COUNT/$TOTAL Tests."

          if [ $COUNT == $TOTAL ]; then
              exit 0
          else
              exit 1
          fi
        working-directory: weaver/samples/fabric/fabric-cli


      # CORDA - FABRIC
      - name: Corda - Fabric Asset Transfer test 1 - Pledge
        run: |
          COUNT=0
          TOTAL=2

          # CORDA - FABRIC1
          # Issue and Pledge token1:5 tokens to partyA
          NETWORK_NAME='Corda_Network' CORDA_PORT=10006 ./clients/build/install/clients/bin/clients issue-asset-state 5 token1 1> tmp.out
          CORDA_PORT=10006 ./clients/build/install/clients/bin/clients transfer pledge-asset --fungible --timeout="3600" --import-network-id='network1' --recipient='alice' --param='token1:5' 1> tmp.out
          cat tmp.out | grep "AssetPledgeState created with pledge-id" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          PID=$(cat tmp.out | grep "AssetPledgeState created with pledge-id " | awk -F "'" '{print $2}')

          # Is Asset Pledged
          CORDA_PORT=10006 ./clients/build/install/clients/bin/clients transfer is-asset-pledged -pid $PID 1> tmp.out
          cat tmp.out | grep "Is asset pledged for transfer response: true" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # RESULT
          echo "Passed $COUNT/$TOTAL Tests."

          echo "CF_PID=$PID" >> $GITHUB_ENV

          if [ $COUNT == $TOTAL ]; then
              exit 0
          else
              exit 1
          fi

        working-directory: weaver/samples/corda/corda-simple-application

      - name: Corda - Fabric Asset Transfer test 2 - Claim
        run: |
          COUNT=0
          TOTAL=3

          PID=${{ env.CF_PID }}

          # CORDA - FABRIC1
          # Claim in Fabric (pledged in Corda)
          ./bin/fabric-cli chaincode query --user=alice mychannel simpleassettransfer GetMyWallet '[]' --local-network=network1 &> tmp.out
          tail -n 2 tmp.out | grep "Result from network query: token1=\"9950\"" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli asset transfer claim --source-network='Corda_Network' --dest-network=network1 --user='alice' --owner='O=PartyA, L=London, C=GB' --type='token.corda' --pledge-id=$PID --param=token1:5 &> tmp.out
          tail -n 1 tmp.out | grep "Called Function ClaimRemoteTokenAsset. With Args: $PID" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query --user=alice mychannel simpleassettransfer GetMyWallet '[]' --local-network=network1 &> tmp.out
          tail -n 2 tmp.out | grep "Result from network query: token1=\"9955\"" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # RESULT
          echo "Passed $COUNT/$TOTAL Tests."

          if [ $COUNT == $TOTAL ]; then
              exit 0
          else
              exit 1
          fi

        working-directory: weaver/samples/fabric/fabric-cli

      - name: Corda - Fabric Asset Transfer test 3 - Reclaim
        run: |
          COUNT=0
          TOTAL=3

          # CORDA - FABRIC1
          # Issue and Pledge token1:10 tokens to partyA
          NETWORK_NAME='Corda_Network' CORDA_PORT=10006 ./clients/build/install/clients/bin/clients issue-asset-state 10 token1 1> tmp.out
          CORDA_PORT=10006 ./clients/build/install/clients/bin/clients transfer pledge-asset --fungible --timeout="20" --import-network-id='network1' --recipient='alice' --param='token1:10' 1> tmp.out
          sleep 20

          PID=$(cat tmp.out | grep "AssetPledgeState created with pledge-id " | awk -F "'" '{print $2}')

          # Is Asset Pledged
          CORDA_PORT=10006 ./clients/build/install/clients/bin/clients transfer is-asset-pledged -pid $PID 1> tmp.out
          cat tmp.out | grep "Is asset pledged for transfer response: false" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          NETWORK_NAME=Corda_Network CORDA_PORT=10006 ./clients/build/install/clients/bin/clients transfer reclaim-pledged-asset --pledge-id=$PID --export-relay-address='localhost:9081' --transfer-category='token.fabric' --import-network-id='network1' --param='token1:10' 1> tmp.out
          cat tmp.out | grep "Pledged Asset Reclaim Response: Right(b=SignedTransaction(id=" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          CORDA_PORT=10006 ./clients/build/install/clients/bin/clients get-asset-states-by-type token1 1> tmp.out
          cat tmp.out | grep "AssetState(quantity=10, tokenType=token1, owner=O=PartyA, L=London, C=GB, " && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # RESULT
          echo "Passed $COUNT/$TOTAL Tests."

          if [ $COUNT == $TOTAL ]; then
              exit 0
          else
              exit 1
          fi

        working-directory: weaver/samples/corda/corda-simple-application

      - name: Fabric - Corda Asset Transfer test 1 - Pledge
        run: |
          COUNT=0
          TOTAL=1

          ./bin/fabric-cli asset transfer pledge --source-network='network1' --dest-network='Corda_Network' --recipient='O=PartyA, L=London, C=GB' --expiry-secs=3600 --type='token' --units=50 --owner=alice --data-file=src/data/tokensForTransfer.json &> tmp.out

          PID=$(cat tmp.out | grep "Asset pledged with ID " | sed -e 's/Asset pledged with ID //')

          ./bin/fabric-cli chaincode query --user=alice mychannel simpleassettransfer GetMyWallet '[]' --local-network=network1 &> tmp.out
          tail -n 2 tmp.out | grep "Result from network query: token1=\"9905\"" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          sleep 30

          # RESULT
          echo "Passed $COUNT/$TOTAL Tests."

          echo "FC_PID=$PID" >> $GITHUB_ENV

          if [ $COUNT == $TOTAL ]; then
              exit 0
          else
              exit 1
          fi

        working-directory: weaver/samples/fabric/fabric-cli

      - name: Fabric - Corda Asset Transfer test 2 - Claim
        run: |
          COUNT=0
          TOTAL=2

          PID=${{ env.FC_PID }}

          # FABRIC - CORDA
          # Claim Remote Asset
          CORDA_PORT=10006 ./clients/build/install/clients/bin/clients transfer claim-remote-asset --pledge-id=$PID --locker='alice' --transfer-category='token.fabric' --export-network-id='network1' --param='token1:50' --import-relay-address='localhost:9082' 1> tmp.out
          cat tmp.out | grep "Pledged asset claim response: Right(b=SignedTransaction(id=" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          CORDA_PORT=10006 ./clients/build/install/clients/bin/clients get-asset-states-by-type token1 1> tmp.out
          cat tmp.out | grep "AssetState(quantity=50, tokenType=token1, owner=O=PartyA, L=London, C=GB, " && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # RESULT
          echo "Passed $COUNT/$TOTAL Tests."

          if [ $COUNT == $TOTAL ]; then
              exit 0
          else
              exit 1
          fi

        working-directory: weaver/samples/corda/corda-simple-application

      - name: Fabric - Corda Asset Transfer test 3 - Reclaim
        run: |
          COUNT=0
          TOTAL=3

          ./bin/fabric-cli asset transfer pledge --source-network='network1' --dest-network='Corda_Network' --recipient='O=PartyA, L=London, C=GB' --expiry-secs=30 --type='token' --units=50 --owner=alice --data-file=src/data/tokensForTransfer.json &> tmp.out
          PID=$(cat tmp.out | grep "Asset pledged with ID " | sed -e 's/Asset pledged with ID //')

          ./bin/fabric-cli chaincode query --user=alice mychannel simpleassettransfer GetMyWallet '[]' --local-network=network1 &> tmp.out
          tail -n 2 tmp.out | grep "Result from network query: token1=\"9855\"" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          sleep 30

          ./bin/fabric-cli asset transfer reclaim --source-network='network1' --user='alice' --type='token.corda' --pledge-id=$PID --param=token1:50 &> tmp.out
          tail -n 1 tmp.out | grep "Called Function ReclaimTokenAsset. With Args: $PID" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query --user=alice mychannel simpleassettransfer GetMyWallet '[]' --local-network=network1 &> tmp.out
          tail -n 2 tmp.out | grep "Result from network query: token1=\"9905\"" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # RESULT
          echo "Passed $COUNT/$TOTAL Tests."

          if [ $COUNT == $TOTAL ]; then
              exit 0
          else
              exit 1
          fi

        working-directory: weaver/samples/fabric/fabric-cli

      - if: failure()
        name: DEBUG Logs - corda partya
        run: docker logs corda_partya_1

      - if: failure()
        name: DEBUG Logs - corda network2 partya
        run: docker logs corda_network2_partya_1

      - if: failure()
        name: DEBUG Logs - fabric n1 relay
        run: docker logs relay-network1

      - if: failure()
        name: DEBUG Logs - fabric n2 relay
        run: docker logs relay-network2

      - if: failure()
        name: DEBUG Logs - corda relay
        run: docker logs relay-corda

      - if: failure()
        name: DEBUG Logs - corda2 relay
        run: docker logs relay-corda2

      - if: failure()
        name: DEBUG Logs - fabric n1 driver
        run: docker logs driver-fabric-network1

      - if: failure()
        name: DEBUG Logs - fabric n2 driver
        run: docker logs driver-fabric-network2

      - if: failure()
        name: DEBUG Logs - corda driver
        run: docker logs driver-corda-Corda_Network

      - if: failure()
        name: DEBUG Logs - corda2 driver
        run: docker logs driver-corda-Corda_Network2

      - if: failure()
        name: DEBUG Logs - iin agent n1 org1
        run: docker logs iin-agent-Org1MSP-network1

      - if: failure()
        name: DEBUG Logs - iin agent n2 org1
        run: docker logs iin-agent-Org1MSP-network2

  asset-transfer-local:
    needs: check_code_changed
    if:  inputs.run_all == 'true' || needs.check_code_changed.outputs.status == 'true'
    # if: ${{ false }}
    # The type of runner that the job will run on
    runs-on: ubuntu-22.04

    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
      # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
      - uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 #v4.1.7

      - name: Set up JDK 17
        uses: actions/setup-java@5ffc13f4174014e2d4d4572b3d74c3fa61aeb2c2 #v3.11.0
        with:
          java-version: '17'
          distribution: 'adopt'

      - name: Set up Go
        uses: actions/setup-go@4d34df0c2316fe8122ab82dc22947d607c0c91f9 #v4.0.0
        with:
          go-version: '1.20.2'

      - name: Use Node.js ${{ env.NODEJS_VERSION }}
        uses: actions/setup-node@1e60f620b9541d16bece96c5465dc8ee9832be0b #v4.0.3
        with:
          node-version: ${{ env.NODEJS_VERSION }}

      - name: Install RUST Toolchain minimal stable with clippy and rustfmt
        uses: actions-rs/toolchain@b2417cde72dcf67f306c0ae8e0828a81bf0b189f #v1.0.6
        with:
          profile: minimal
          toolchain: stable
          components: rustfmt, clippy

      - name: Get Latest Relay Dependencies
        run: |
          make protos-local
          cargo update -p nom
          cargo update -p lexical-core
        working-directory: weaver/core/relay

      - name: Use Protoc 3.15
        run: |
          curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v3.15.6/protoc-3.15.6-linux-x86_64.zip
          unzip protoc-3.15.6-linux-x86_64.zip -d protoc
          go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.34.2
          go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.4.0

      # PROTOS
      - name: Build GO Protos
        run: |
          export PATH="$PATH:${GITHUB_WORKSPACE}/protoc/bin"
          make build
        working-directory: weaver/common/protos-go

      # PROTOS
      - name: Build JS Protos
        run: |
          export PATH="$PATH:${GITHUB_WORKSPACE}/protoc/bin"
          make build
        working-directory: weaver/common/protos-js

      - name: Build Java Protos
        run: make build
        working-directory: weaver/common/protos-java-kt

      # Build Dependencies
      - name: Build Corda Interop App
        run: make build-local
        working-directory: weaver/core/network/corda-interop-app

      - name: Build Corda Interop SDK
        run: make build
        working-directory: weaver/sdks/corda

      - name: Build Corda SimpleApplication
        run: make build-local
        working-directory: weaver/samples/corda/corda-simple-application

      - name: Build Fabric Interop SDK
        run: make build-local
        working-directory: weaver/sdks/fabric/interoperation-node-sdk

      - name: Build Fabric CLI
        run: make build-local
        working-directory: weaver/samples/fabric/fabric-cli

      - name: Build Relay
        run: make
        working-directory: weaver/core/relay

      - name: Build Fabric Driver
        run: make build-local
        working-directory: weaver/core/drivers/fabric-driver

      - name: Build IIN Agent
        run: make build-local
        working-directory: weaver/core/identity-management/iin-agent

      - name: Build Corda Driver
        run: make build-local
        working-directory: weaver/core/drivers/corda-driver

      # CORDA NETWORK
      - name: Start Corda Network
        run: make start-local &> corda-net.out &
        working-directory: weaver/tests/network-setups/corda

      # FABRIC NETWORK

      - name: Start Fabric Network
        run: make start-interop-local CHAINCODE_NAME=simpleassettransfer
        working-directory: weaver/tests/network-setups/fabric/dev

      - name: Corda Network logs
        run: |
          cat tests/network-setups/corda/corda-net.out
          docker logs corda_partya_1
          docker logs corda_network2_partya_1
        working-directory: weaver

      - name: Free up Space
        run: |
          df -h .
          docker system prune -a -f
          rm -rf ~/.cargo/registry
          df -h .
        working-directory: weaver

      # RELAY
      - name: Start Relay for network1
        run: RELAY_CONFIG=config/Fabric_Relay.toml cargo run --bin server &> relay-n1.out &
        working-directory: weaver/core/relay

      - name: Start Relay for network2
        run: RELAY_CONFIG=config/Fabric_Relay2.toml cargo run --bin server &> relay-n2.out &
        working-directory: weaver/core/relay

      - name: Start Relay for Corda_Network
        run: RELAY_CONFIG=config/Corda_Relay.toml cargo run --bin server &> relay-corda.out &
        working-directory: weaver/core/relay

      - name: Start Relay for Corda_Network2
        run: RELAY_CONFIG=config/Corda_Relay2.toml cargo run --bin server &> relay-corda2.out &
        working-directory: weaver/core/relay

      # FABRIC DRIVER
      - name: Setup Fabric Driver .env
        run: |
          cp .env.template .env
          CCP_PATH=${GITHUB_WORKSPACE}/weaver/tests/network-setups/fabric/shared/network1/peerOrganizations/org1.network1.com/connection-org1.json
          sed -i "s#path_to_connection_profile#${CCP_PATH}#g" .env
        working-directory: weaver/core/drivers/fabric-driver

      - name: Start Fabric Driver for network1
        run: npm run dev &> fdriver-n1.out &
        working-directory: weaver/core/drivers/fabric-driver

      - name: Start Fabric Driver for network2
        run: CONNECTION_PROFILE=${GITHUB_WORKSPACE}/weaver/tests/network-setups/fabric/shared/network2/peerOrganizations/org1.network2.com/connection-org1.json NETWORK_NAME=network2 RELAY_ENDPOINT=localhost:9083 DRIVER_ENDPOINT=localhost:9095 npm run dev &> fdriver-n2.out &
        working-directory: weaver/core/drivers/fabric-driver

      # IIN AGENT
      - name: Setup Fabric IIN Config
        run: |
          # FABRIC CONFIG
          cp src/fabric-ledger/config.json.template src/fabric-ledger/config-n1.json
          CCP_PATH=${GITHUB_WORKSPACE}/weaver/tests/network-setups/fabric/shared/network1/peerOrganizations/org1.network1.com/connection-org1.json
          sed -i "s#<path-to-connection-profile>#${CCP_PATH}#g" src/fabric-ledger/config-n1.json
          cat src/fabric-ledger/config-n1.json
          cp src/fabric-ledger/config.json.template src/fabric-ledger/config-n2.json
          CCP_PATH=${GITHUB_WORKSPACE}/weaver/tests/network-setups/fabric/shared/network2/peerOrganizations/org1.network2.com/connection-org1.json
          sed -i "s#<path-to-connection-profile>#${CCP_PATH}#g" src/fabric-ledger/config-n2.json
          cat src/fabric-ledger/config-n2.json
          # DNS CONFIG
          sed -i "s#iin-agent-Org1MSP-network1#localhost#g" docker-testnet/configs/dnsconfig.json
          sed -i "s#iin-agent-Org1MSP-network2#localhost#g" docker-testnet/configs/dnsconfig.json
          cat docker-testnet/configs/dnsconfig.json
        working-directory: weaver/core/identity-management/iin-agent

      - name: Setup Fabric IIN Env
        run: |
          cp .env.template .env
          sed -i "s#<name-of-iin-agent/org-name>#Org1MSP#g" .env
          sed -i "s#^DLT_TYPE=.*#DLT_TYPE=fabric#g" .env
          sed -i "s#<weaver-contract-name>#interop#g" .env
          sed -i "s#^DNS_CONFIG_PATH=#DNS_CONFIG_PATH=./docker-testnet/configs/dnsconfig.json#g" .env
          sed -i "s#^SECURITY_DOMAIN_CONFIG_PATH=#SECURITY_DOMAIN_CONFIG_PATH=./docker-testnet/configs/security-domain-config.json#g" .env
          sed -i "s#^CONFIG_PATH=#CONFIG_PATH=./src/fabric-ledger/config-n1.json#g" .env
          sed -i "s#^AUTO_SYNC=#AUTO_SYNC=false#g" .env
          cat .env
        working-directory: weaver/core/identity-management/iin-agent

      - name: Start Fabric IIN Agent for network1
        run: npm run dev &> iinagent-n1.out &
        working-directory: weaver/core/identity-management/iin-agent

      - name: Start Fabric IIN Agent for network2
        run: IIN_AGENT_ENDPOINT=localhost:9501 SECURITY_DOMAIN=network2 CONFIG_PATH=./src/fabric-ledger/config-n2.json npm run dev &> iinagent-n2.out &
        working-directory: weaver/core/identity-management/iin-agent

      # CORDA DRIVER
      - name: Start Corda_Network Driver
        run: ./build/install/driver-corda/bin/driver-corda &> corda-driver.out &
        working-directory: weaver/core/drivers/corda-driver

      - name: Start Corda_Network2 Driver
        run: DRIVER_PORT=9098 ./build/install/driver-corda/bin/driver-corda &> corda2-driver.out &
        working-directory: weaver/core/drivers/corda-driver

      # FABRIC CLI
      - name: Setup Fabric CLI ENV
        run: |
          echo ${GITHUB_WORKSPACE}
          cp .env.template .env
          ./bin/fabric-cli env set-file ./.env
          ./bin/fabric-cli env set MEMBER_CREDENTIAL_FOLDER ${GITHUB_WORKSPACE}/weaver/samples/fabric/fabric-cli/src/data/credentials
          ./bin/fabric-cli env set CONFIG_PATH ${GITHUB_WORKSPACE}/weaver/samples/fabric/fabric-cli/config.json
          ./bin/fabric-cli env set DEFAULT_APPLICATION_CHAINCODE simpleassettransfer
          ./bin/fabric-cli env set REMOTE_CONFIG_PATH ${GITHUB_WORKSPACE}/weaver/samples/fabric/fabric-cli/remote-network-config.json
          ./bin/fabric-cli env set CHAINCODE_PATH ${GITHUB_WORKSPACE}/weaver/samples/fabric/fabric-cli/chaincode.json
          cat .env
        working-directory: weaver/samples/fabric/fabric-cli

      - name: Setup Fabric CLI Config
        run: |
          echo ${GITHUB_WORKSPACE}
          cp config.template.json config.json
          sed -i "s#<PATH-TO-WEAVER>#${GITHUB_WORKSPACE}/weaver#g" config.json
          ###### Change line number in following commands if config is modified #####
          ./bin/fabric-cli config set network2 aclPolicyPrincipalType ca
          ./bin/fabric-cli config set network1 chaincode simpleassettransfer
          ./bin/fabric-cli config set network2 chaincode simpleassettransfer
          cp chaincode.json.template chaincode.json
          cp remote-network-config.json.template remote-network-config.json
        working-directory: weaver/samples/fabric/fabric-cli


      - name: Fabric CLI Init
        run: |
          ./bin/fabric-cli configure create all --local-network=network1
          ./bin/fabric-cli configure create all --local-network=network2
          ./bin/fabric-cli configure network --local-network=network1
          ./bin/fabric-cli configure network --local-network=network2
          ./scripts/initAssetsForTransfer.sh
        working-directory: weaver/samples/fabric/fabric-cli

      - name: Fabric Sync Membership using IIN Agent
        run: |
          ./bin/fabric-cli configure membership --local-network=network1 --target-network=network2 --iin-agent-endpoint=localhost:9500
          sleep 10
          tail -10 ../../../core/identity-management/iin-agent/iinagent-n1.out
          ./bin/fabric-cli configure membership --local-network=network2 --target-network=network1 --iin-agent-endpoint=localhost:9501
          sleep 10
          tail -10 ../../../core/identity-management/iin-agent/iinagent-n2.out
        working-directory: weaver/samples/fabric/fabric-cli

      # CORDA CLIENT
      - name: Corda CLI Setup
        run: |
          cp remote-network-config.json.template remote-network-config.json
        working-directory: weaver/samples/corda/corda-simple-application/clients/src/main/resources/config

      - name: Corda CLI Initialize Vault
        run: make initialise-vault-asset-transfer
        working-directory: weaver/samples/corda/corda-simple-application

      - name: Asset Transfer Corda Client Tests
        run: |
          COUNT=0
          TOTAL=9

          # Issue t1:5 tokens to partyA
          NETWORK_NAME='Corda_Network' CORDA_PORT=10006 ./clients/build/install/clients/bin/clients issue-asset-state 5 t1 1> tmp.out
          cat tmp.out | grep "AssetState(quantity=5, tokenType=t1, owner=O=PartyA" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # CORDA2-CORDA
          # Pledge Asset
          NETWORK_NAME='Corda_Network' CORDA_PORT=10006 ./clients/build/install/clients/bin/clients transfer pledge-asset --fungible --timeout="3600" --import-network-id='Corda_Network2' --recipient='O=PartyA, L=London, C=GB' --param='t1:5' 1> tmp.out
          cat tmp.out | grep "AssetPledgeState created with pledge-id" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          PID=$(cat tmp.out | grep "AssetPledgeState created with pledge-id " | awk -F "'" '{print $2}')

          # Is Asset Pledged
          CORDA_PORT=10006 ./clients/build/install/clients/bin/clients transfer is-asset-pledged -pid $PID 1> tmp.out
          cat tmp.out | grep "Is asset pledged for transfer response: true" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # Claim Remote Asset
          NETWORK_NAME='Corda_Network2' CORDA_PORT=30006 ./clients/build/install/clients/bin/clients transfer claim-remote-asset --pledge-id=$PID --locker='O=PartyA, L=London, C=GB' --transfer-category='token.corda' --export-network-id='Corda_Network' --param='t1:5' --import-relay-address='localhost:9082' 1> tmp.out
          cat tmp.out | grep "Pledged asset claim response: Right(b=SignedTransaction(id=" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          CORDA_PORT=10006 ./clients/build/install/clients/bin/clients get-asset-states-by-type t1 1> tmp.out
          cat tmp.out | grep "\[\]" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out
          CORDA_PORT=30006 ./clients/build/install/clients/bin/clients get-asset-states-by-type t1 1> tmp.out
          cat tmp.out | grep "AssetState(quantity=5, tokenType=t1, owner=O=PartyA, L=London, C=GB, " && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # CORDA-CORDA2

          # Issue and Pledge t2:5 tokens
          NETWORK_NAME='Corda_Network' CORDA_PORT=10006 ./clients/build/install/clients/bin/clients issue-asset-state 5 t2 1> tmp.out
          NETWORK_NAME='Corda_Network' CORDA_PORT=10006 ./clients/build/install/clients/bin/clients transfer pledge-asset --fungible --timeout="20" --import-network-id='Corda_Network2' --recipient='O=PartyA, L=London, C=GB' --param='t2:5' 1> tmp.out
          PID=$(cat tmp.out | grep "AssetPledgeState created with pledge-id " | awk -F "'" '{print $2}')
          sleep 20

          # Is Asset Pledged
          CORDA_PORT=10006 ./clients/build/install/clients/bin/clients transfer is-asset-pledged -pid $PID 1> tmp.out
          cat tmp.out | grep "Is asset pledged for transfer response: false" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          NETWORK_NAME=Corda_Network CORDA_PORT=10006 ./clients/build/install/clients/bin/clients transfer reclaim-pledged-asset --pledge-id=$PID --export-relay-address='localhost:9081' --transfer-category='token.corda' --import-network-id='Corda_Network2' --param='t2:5' 1> tmp.out
          cat tmp.out | grep "Pledged Asset Reclaim Response: Right(b=SignedTransaction(id=" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          CORDA_PORT=10006 ./clients/build/install/clients/bin/clients get-asset-states-by-type t2 1> tmp.out
          cat tmp.out | grep "AssetState(quantity=5, tokenType=t2, owner=O=PartyA, L=London, C=GB, " && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # RESULT
          echo "Passed $COUNT/$TOTAL Tests."

          if [ $COUNT == $TOTAL ]; then
              exit 0
          else
              exit 1
          fi
        working-directory: weaver/samples/corda/corda-simple-application

      # FABRIC CLI
      - name: Asset Transfer Fabric CLI Non-Fungible Tests
        run: |
          COUNT=0
          TOTAL=8

          # FABRIC2 - FABRIC1
          ./bin/fabric-cli asset transfer pledge --source-network=network1 --dest-network=network2 --recipient=bob --expiry-secs=3600 --type=bond --ref=a03 --data-file=src/data/assetsForTransfer.json &> tmp.out
          tail -n 1 tmp.out | grep "Asset pledged with ID" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          CID=$(cat tmp.out | grep "Asset pledged with ID " | sed -e 's/Asset pledged with ID //')

          # FABRIC1 - FABRIC2
          ./bin/fabric-cli asset transfer claim --source-network=network1 --dest-network=network2 --user=bob --owner=alice --type=bond.fabric --pledge-id=$CID --param=bond01:a03 &> tmp.out
          tail -n 1 tmp.out | grep "Called Function ClaimRemoteAsset. With Args: $CID" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query --user=alice mychannel simpleassettransfer ReadAsset '["bond01","a03"]' --local-network=network1 &> tmp.out
          tail -n 2 tmp.out | grep "Error: the asset a03 does not exist" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query --user=bob mychannel simpleassettransfer ReadAsset '["bond01","a03"]' --local-network=network2 &> tmp.out
          #tail -n 1 tmp.out | grep "Result from network query: {\"type\":\"bond01\",\"id\":\"a03\"" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out | tr '\n' ' ' | grep "Result from network query: {     \"type\": \"bond01\",     \"id\": \"a03\"" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli asset transfer pledge --source-network=network1 --dest-network=network2 --recipient=bob --expiry-secs=20 --type=bond --ref=a04 --data-file=src/data/assetsForTransfer.json &> tmp.out
          cat tmp.out

          CID=$(cat tmp.out | grep "Asset pledged with ID " | sed -e 's/Asset pledged with ID //')
          sleep 20

          ./bin/fabric-cli asset transfer claim --source-network=network1 --dest-network=network2 --user=bob --owner=alice --type=bond.fabric --pledge-id=$CID --param=bond01:a04 &> tmp.out
          tail -n 1 tmp.out | grep "cannot claim asset with pledgeId $CID as the expiry time has elapsed" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli asset transfer reclaim --source-network=network1 --user=alice --type=bond.fabric --pledge-id=$CID --param=bond01:a04 &> tmp.out
          tail -n 1 tmp.out | grep "Called Function ReclaimAsset. With Args: $CID" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query --user=alice mychannel simpleassettransfer ReadAsset '["bond01","a04"]' --local-network=network1 &> tmp.out
          #tail -n 1 tmp.out | grep "Result from network query: {\"type\":\"bond01\",\"id\":\"a04\"" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out | tr '\n' ' ' | grep "Result from network query: {     \"type\": \"bond01\",     \"id\": \"a04\"" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query --user=bob mychannel simpleassettransfer ReadAsset '["bond01","a04"]' --local-network=network2 &> tmp.out
          tail -n 2 tmp.out | grep "Error: the asset a04 does not exist" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # RESULT
          echo "Passed $COUNT/$TOTAL Tests."

          if [ $COUNT == $TOTAL ]; then
              exit 0
          else
              exit 1
          fi
        working-directory: weaver/samples/fabric/fabric-cli

      # FABRIC CLI
      - name: Asset Transfer Fabric CLI Fungible Tests
        run: |
          COUNT=0
          TOTAL=8

          # FABRIC2 - FABRIC1
          ./bin/fabric-cli asset transfer pledge --source-network=network1 --dest-network=network2 --recipient=bob --expiry-secs=3600 --type=token --units=50 --owner=alice --data-file=src/data/tokensForTransfer.json &> tmp.out
          tail -n 1 tmp.out | grep "Asset pledged with ID" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          CID=$(cat tmp.out | grep "Asset pledged with ID " | sed -e 's/Asset pledged with ID //')

          # FABRIC1 - FABRIC2
          ./bin/fabric-cli asset transfer claim --source-network=network1 --dest-network=network2 --user=bob --owner=alice --type=token.fabric --pledge-id=$CID --param=token1:50 &> tmp.out
          tail -n 1 tmp.out | grep "Called Function ClaimRemoteTokenAsset. With Args: $CID" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query --user=alice mychannel simpleassettransfer GetMyWallet '[]' --local-network=network1 &> tmp.out
          tail -n 2 tmp.out | grep "Result from network query: token1=\"9950\"" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query --user=bob mychannel simpleassettransfer GetMyWallet '[]' --local-network=network2 &> tmp.out
          tail -n 2 tmp.out | grep "Result from network query: token1=\"50\"" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli asset transfer pledge --source-network=network1 --dest-network=network2 --recipient=bob --expiry-secs=20 --type=token --units=100 --owner=alice --data-file=src/data/tokensForTransfer.json &> tmp.out
          cat tmp.out

          CID=$(cat tmp.out | grep "Asset pledged with ID " | sed -e 's/Asset pledged with ID //')
          sleep 20

          ./bin/fabric-cli asset transfer claim --source-network=network1 --dest-network=network2 --user=bob --owner=alice --type=token.fabric --pledge-id=$CID --param=token1:100 &> tmp.out
          tail -n 1 tmp.out | grep "cannot claim asset with pledgeId $CID as the expiry time has elapsed" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli asset transfer reclaim --source-network=network1 --user=alice --type=token.fabric --pledge-id=$CID --param=token1:100 &> tmp.out
          tail -n 1 tmp.out | grep "Called Function ReclaimTokenAsset. With Args: $CID" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query --user=alice mychannel simpleassettransfer GetMyWallet '[]' --local-network=network1 &> tmp.out
          tail -n 2 tmp.out | grep "Result from network query: token1=\"9950\"" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query --user=bob mychannel simpleassettransfer GetMyWallet '[]' --local-network=network2 &> tmp.out
          tail -n 2 tmp.out | grep "Result from network query: token1=\"50\"" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # RESULT
          echo "Passed $COUNT/$TOTAL Tests."

          if [ $COUNT == $TOTAL ]; then
              exit 0
          else
              exit 1
          fi
        working-directory: weaver/samples/fabric/fabric-cli


      # CORDA - FABRIC
      - name: Corda - Fabric Asset Transfer test 1 - Pledge
        run: |
          COUNT=0
          TOTAL=2

          # CORDA - FABRIC1
          # Issue and Pledge token1:5 tokens to partyA
          NETWORK_NAME='Corda_Network' CORDA_PORT=10006 ./clients/build/install/clients/bin/clients issue-asset-state 5 token1 1> tmp.out
          CORDA_PORT=10006 ./clients/build/install/clients/bin/clients transfer pledge-asset --fungible --timeout="3600" --import-network-id='network1' --recipient='alice' --param='token1:5' 1> tmp.out
          cat tmp.out | grep "AssetPledgeState created with pledge-id" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          PID=$(cat tmp.out | grep "AssetPledgeState created with pledge-id " | awk -F "'" '{print $2}')

          # Is Asset Pledged
          CORDA_PORT=10006 ./clients/build/install/clients/bin/clients transfer is-asset-pledged -pid $PID 1> tmp.out
          cat tmp.out | grep "Is asset pledged for transfer response: true" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # RESULT
          echo "Passed $COUNT/$TOTAL Tests."

          echo "CF_PID=$PID" >> $GITHUB_ENV

          if [ $COUNT == $TOTAL ]; then
              exit 0
          else
              exit 1
          fi

        working-directory: weaver/samples/corda/corda-simple-application

      - name: Corda - Fabric Asset Transfer test 2 - Claim
        run: |
          COUNT=0
          TOTAL=3

          PID=${{ env.CF_PID }}

          # CORDA - FABRIC1
          # Claim in Fabric (pledged in Corda)
          ./bin/fabric-cli chaincode query --user=alice mychannel simpleassettransfer GetMyWallet '[]' --local-network=network1 &> tmp.out
          tail -n 2 tmp.out | grep "Result from network query: token1=\"9950\"" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli asset transfer claim --source-network='Corda_Network' --dest-network=network1 --user='alice' --owner='O=PartyA, L=London, C=GB' --type='token.corda' --pledge-id=$PID --param=token1:5 &> tmp.out
          tail -n 1 tmp.out | grep "Called Function ClaimRemoteTokenAsset. With Args: $PID" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query --user=alice mychannel simpleassettransfer GetMyWallet '[]' --local-network=network1 &> tmp.out
          tail -n 2 tmp.out | grep "Result from network query: token1=\"9955\"" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # RESULT
          echo "Passed $COUNT/$TOTAL Tests."

          if [ $COUNT == $TOTAL ]; then
              exit 0
          else
              exit 1
          fi

        working-directory: weaver/samples/fabric/fabric-cli

      - name: Corda - Fabric Asset Transfer test 3 - Reclaim
        run: |
          COUNT=0
          TOTAL=3

          # CORDA - FABRIC1
          # Issue and Pledge token1:10 tokens to partyA
          NETWORK_NAME='Corda_Network' CORDA_PORT=10006 ./clients/build/install/clients/bin/clients issue-asset-state 10 token1 1> tmp.out
          CORDA_PORT=10006 ./clients/build/install/clients/bin/clients transfer pledge-asset --fungible --timeout="20" --import-network-id='network1' --recipient='alice' --param='token1:10' 1> tmp.out
          sleep 20

          PID=$(cat tmp.out | grep "AssetPledgeState created with pledge-id " | awk -F "'" '{print $2}')

          # Is Asset Pledged
          CORDA_PORT=10006 ./clients/build/install/clients/bin/clients transfer is-asset-pledged -pid $PID 1> tmp.out
          cat tmp.out | grep "Is asset pledged for transfer response: false" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          NETWORK_NAME=Corda_Network CORDA_PORT=10006 ./clients/build/install/clients/bin/clients transfer reclaim-pledged-asset --pledge-id=$PID --export-relay-address='localhost:9081' --transfer-category='token.fabric' --import-network-id='network1' --param='token1:10' 1> tmp.out
          cat tmp.out | grep "Pledged Asset Reclaim Response: Right(b=SignedTransaction(id=" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          CORDA_PORT=10006 ./clients/build/install/clients/bin/clients get-asset-states-by-type token1 1> tmp.out
          cat tmp.out | grep "AssetState(quantity=10, tokenType=token1, owner=O=PartyA, L=London, C=GB, " && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # RESULT
          echo "Passed $COUNT/$TOTAL Tests."

          if [ $COUNT == $TOTAL ]; then
              exit 0
          else
              exit 1
          fi

        working-directory: weaver/samples/corda/corda-simple-application

      - name: Fabric - Corda Asset Transfer test 1 - Pledge
        run: |
          COUNT=0
          TOTAL=1

          ./bin/fabric-cli asset transfer pledge --source-network='network1' --dest-network='Corda_Network' --recipient='O=PartyA, L=London, C=GB' --expiry-secs=3600 --type='token' --units=50 --owner=alice --data-file=src/data/tokensForTransfer.json &> tmp.out

          PID=$(cat tmp.out | grep "Asset pledged with ID " | sed -e 's/Asset pledged with ID //')

          ./bin/fabric-cli chaincode query --user=alice mychannel simpleassettransfer GetMyWallet '[]' --local-network=network1 &> tmp.out
          tail -n 2 tmp.out | grep "Result from network query: token1=\"9905\"" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          sleep 30

          # RESULT
          echo "Passed $COUNT/$TOTAL Tests."

          echo "FC_PID=$PID" >> $GITHUB_ENV

          if [ $COUNT == $TOTAL ]; then
              exit 0
          else
              exit 1
          fi

        working-directory: weaver/samples/fabric/fabric-cli

      - name: Fabric - Corda Asset Transfer test 2 - Claim
        run: |
          COUNT=0
          TOTAL=2

          PID=${{ env.FC_PID }}

          # FABRIC - CORDA
          # Claim Remote Asset
          CORDA_PORT=10006 ./clients/build/install/clients/bin/clients transfer claim-remote-asset --pledge-id=$PID --locker='alice' --transfer-category='token.fabric' --export-network-id='network1' --param='token1:50' --import-relay-address='localhost:9082' 1> tmp.out
          cat tmp.out | grep "Pledged asset claim response: Right(b=SignedTransaction(id=" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          CORDA_PORT=10006 ./clients/build/install/clients/bin/clients get-asset-states-by-type token1 1> tmp.out
          cat tmp.out | grep "AssetState(quantity=50, tokenType=token1, owner=O=PartyA, L=London, C=GB, " && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # RESULT
          echo "Passed $COUNT/$TOTAL Tests."

          if [ $COUNT == $TOTAL ]; then
              exit 0
          else
              exit 1
          fi

        working-directory: weaver/samples/corda/corda-simple-application

      - name: Fabric - Corda Asset Transfer test 3 - Reclaim
        run: |
          COUNT=0
          TOTAL=3

          ./bin/fabric-cli asset transfer pledge --source-network='network1' --dest-network='Corda_Network' --recipient='O=PartyA, L=London, C=GB' --expiry-secs=30 --type='token' --units=50 --owner=alice --data-file=src/data/tokensForTransfer.json &> tmp.out
          PID=$(cat tmp.out | grep "Asset pledged with ID " | sed -e 's/Asset pledged with ID //')

          ./bin/fabric-cli chaincode query --user=alice mychannel simpleassettransfer GetMyWallet '[]' --local-network=network1 &> tmp.out
          tail -n 2 tmp.out | grep "Result from network query: token1=\"9855\"" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          sleep 30

          ./bin/fabric-cli asset transfer reclaim --source-network='network1' --user='alice' --type='token.corda' --pledge-id=$PID --param=token1:50 &> tmp.out
          tail -n 1 tmp.out | grep "Called Function ReclaimTokenAsset. With Args: $PID" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          ./bin/fabric-cli chaincode query --user=alice mychannel simpleassettransfer GetMyWallet '[]' --local-network=network1 &> tmp.out
          tail -n 2 tmp.out | grep "Result from network query: token1=\"9905\"" && COUNT=$(( COUNT + 1 )) && echo "PASS"
          cat tmp.out

          # RESULT
          echo "Passed $COUNT/$TOTAL Tests."

          if [ $COUNT == $TOTAL ]; then
              exit 0
          else
              exit 1
          fi

        working-directory: weaver/samples/fabric/fabric-cli

      - if: failure()
        name: DEBUG Logs - corda partya
        run: docker logs corda_partya_1

      - if: failure()
        name: DEBUG Logs - corda network2 partya
        run: docker logs corda_network2_partya_1

      - if: failure()
        name: DEBUG Logs - fabric n1 relay
        run: cat weaver/core/relay/relay-n1.out

      - if: failure()
        name: DEBUG Logs - fabric n2 relay
        run: cat weaver/core/relay/relay-n2.out

      - if: failure()
        name: DEBUG Logs - corda relay
        run: cat weaver/core/relay/relay-corda.out

      - if: failure()
        name: DEBUG Logs - corda2 relay
        run: cat weaver/core/relay/relay-corda2.out

      - if: failure()
        name: DEBUG Logs - fabric n1 driver
        run: cat weaver/core/drivers/fabric-driver/fdriver-n1.out

      - if: failure()
        name: DEBUG Logs - fabric n2 driver
        run: cat weaver/core/drivers/fabric-driver/fdriver-n2.out

      - if: failure()
        name: DEBUG Logs - corda driver
        run: cat weaver/core/drivers/corda-driver/corda-driver.out

      - if: failure()
        name: DEBUG Logs - corda2 driver
        run: cat weaver/core/drivers/corda-driver/corda2-driver.out

      - if: failure()
        name: DEBUG Logs - iin agent n1 org1
        run: cat weaver/core/identity-management/iin-agent/iinagent-n1.out

      - if: failure()
        name: DEBUG Logs - iin agent n2 org1
        run: cat weaver/core/identity-management/iin-agent/iinagent-n2.out

```


--- FILE: .github/workflows/satp-hermes-workflow.yaml ---
```yaml
name: SATP Hermes Package Workflow
 # -----------------------------------------------------------------------------
        # PROCESS OVERVIEW
        #
        # Purpose:
        #   CI/CD pipeline for the SATP (Secure Asset Transfer Protocol) Hermes Gateway plugin.
        #   It builds and tests the plugin, generates code artifacts (protobuf, OpenAPI, Solidity),
        #   validates code quality, produces Docker images and (on push) publishes them to registries.
        #
        # Architecture:
        #   This workflow has been modularized into separate stage-specific workflows:
        #   - Unit and integration testing
        #   - Docker image building and publishing
        #   - .github/workflows/satp-hermes-release.yaml - GitHub release creation
        #
        # Triggers:
        #   - workflow_call: invoked by packages-workflow.yaml when the SATP Hermes package is affected
        #   - workflow_dispatch: manual triggers with release options
        #
        # High-level job flow and intent:
        #   1) build-stage: Installs dependencies, runs minimal configure/build for the SATP plugin
        #   2) lint-stage: Runs ESLint, OpenAPI linting and protobuf linting for the SATP plugin
        #   3) codegen-stage: Generates protobuf artifacts, OpenAPI SDKs and Solidity ABIs
        #   4) test-stage: Runs unit and integration tests across multiple scenarios
        #   5) docker-stage: Builds and publishes Docker images with appropriate tagging
        #   6) release-stage: Creates GitHub releases (release mode only)
        #
        # DEVELOPMENT MODE (Default):
        # - Triggered by push/PR events on release branches
        # - Creates date-based development tags (YYYY-MM-DD-dev-{hash})
        # - Builds, tests, and publishes development images without affecting 'latest' tag
        #
        # RELEASE MODE:
        # - Triggered manually via workflow_dispatch with is_release=true
        # - Uses package.json version for release tags (e.g., 0.0.1-beta)
        # - Updates 'latest' tag to point to new release
        # - Additional options: custom version, branch selection, test skipping
        # - Creates GitHub release with changelog and Docker image information
        #
        # Core Pipeline Features:
        # - Builds all monorepo dependencies and generates protocol artifacts (protobuf, OpenAPI, Solidity)
        # - Runs comprehensive test suites including unit tests and integration tests across multiple scenarios
        # - Validates code quality through linting and static analysis
        # - Creates deployable Docker images and publishes them to container registries
        # - Supports multiple deployment environments (main, dev, staging) with appropriate tagging
        #
        # Artifacts published by jobs (names to reference):
        #   - satp-hermes-build-output: build outputs (dist)
        #   - satp-hermes-yarn-cache: cached .yarn directory (fallback to package-specific .yarn)
        #   - satp-unit-junit-report, satp-integration-junit-report-*: JUnit test reports
        #   - coverage-reports-satp-hermes: coverage artifacts (uploaded by tests when present)
        # -----------------------------------------------------------------------------

on:
  workflow_call:
    inputs:
      node_version:
        required: true
        type: string
      run_code_coverage:
        required: true
        type: string
    
concurrency:
  group: satp-hermes-package-workflows-${{ github.workflow }}-${{ github.event.pull_request.number || github.ref }}
  cancel-in-progress: true

jobs:
  # Test execution jobs: run unit and integration tests in parallel
  run-satp-tests-unit:
    runs-on: ubuntu-22.04
    continue-on-error: true
    env:
      JEST_TEST_PATTERN: packages/cactus-plugin-satp-hermes/src/test/typescript/unit/.*/*.test.ts
      JEST_TEST_COVERAGE_PATH: ./code-coverage-ts/cactus-plugin-satp-hermes
    steps:
      - uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 #v4.1.7

      - uses: ./.github/actions/docker-pull/
        with:
          image: kubaya/cacti-satp-hermes-gateway:5f190f37f-2025-08-19

      - name: build
        with:
          node_version: ${{ inputs.node_version }}
          yarn_hardened_mode: '0'
        uses: ./.github/actions/configure-repo/

      - name: Run Jest Tests
        uses: ./.github/actions/jest-runner/
        with:
          run_code_coverage: ${{ inputs.run_code_coverage }}
          jest_test_pattern: ${{ env.JEST_TEST_PATTERN }}
          jest_test_coverage_path: ${{ env.JEST_TEST_COVERAGE_PATH }}
          github_secret: ${{ secrets.GITHUB_TOKEN }}
          report_name: "satp-unit-tests-report"

      - name: Upload coverage reports as artifacts
        if: ${{ inputs.run_code_coverage == 'true' }}
        uses: actions/upload-artifact@65462800fd760344b1a7b4382951275a0abb4808 #v4.3.3
        with:
          name: coverage-reports-satp-hermes-unit
          path: ./code-coverage-ts/**/

      
  run-satp-tests-integration-bridge:
    runs-on: ubuntu-22.04
    continue-on-error: true
    env:
      JEST_TEST_PATTERN: packages/cactus-plugin-satp-hermes/src/test/typescript/integration/bridge/.*/*.test.ts
      JEST_TEST_COVERAGE_PATH: ./code-coverage-ts/cactus-plugin-satp-hermes
    steps:
      - uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 #v4.1.7

      - name: CI environment clean-up
        run: ./tools/ci-env-clean-up.sh

      - uses: ./.github/actions/docker-pull/
        with:
          image: ghcr.io/hyperledger/cactus-besu-all-in-one:2024-06-09-cc2f9c5
      
      - uses: ./.github/actions/docker-pull/
        with:
          image: ghcr.io/hyperledger-cacti/cactus-fabric2-all-in-one:v2.1.0
      
      - uses: ./.github/actions/docker-pull/
        with:
          image: ghcr.io/hyperledger/cacti-geth-all-in-one:2023-07-27-2a8c48ed6

      - name: build
        with:
          node_version: ${{ inputs.node_version }}
          yarn_hardened_mode: '0'
        uses: ./.github/actions/configure-repo/

      - name: Run Jest Tests
        uses: ./.github/actions/jest-runner/
        with:
          run_code_coverage: ${{ inputs.run_code_coverage }}
          jest_test_pattern: ${{ env.JEST_TEST_PATTERN }}
          jest_test_coverage_path: ${{ env.JEST_TEST_COVERAGE_PATH }}
          github_secret: ${{ secrets.GITHUB_TOKEN }}
          report_name: "satp-bridge-integration-tests-report"

      - name: Upload coverage reports as artifacts
        if: ${{ inputs.run_code_coverage == 'true' }}
        uses: actions/upload-artifact@65462800fd760344b1a7b4382951275a0abb4808 #v4.3.3
        with:
          name: coverage-reports-satp-hermes-bridge
          path: ./code-coverage-ts/**/

  run-satp-tests-integration-oracle:
    runs-on: ubuntu-22.04
    continue-on-error: true
    env:
      JEST_TEST_PATTERN: packages/cactus-plugin-satp-hermes/src/test/typescript/integration/oracle/.*/*.test.ts
      JEST_TEST_COVERAGE_PATH: ./code-coverage-ts/cactus-plugin-satp-hermes
    steps:
      - uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 #v4.1.7

      - name: CI environment clean-up
        run: ./tools/ci-env-clean-up.sh

      - uses: ./.github/actions/docker-pull/
        with:
          image: ghcr.io/hyperledger/cactus-besu-all-in-one:2024-06-09-cc2f9c5
      
      - uses: ./.github/actions/docker-pull/
        with:
          image: ghcr.io/hyperledger-cacti/cactus-fabric2-all-in-one:v2.1.0
      
      - uses: ./.github/actions/docker-pull/
        with:
          image: ghcr.io/hyperledger/cacti-geth-all-in-one:2023-07-27-2a8c48ed6
      - name: build
        with:
          node_version: ${{ inputs.node_version }}
          yarn_hardened_mode: '0'
        uses: ./.github/actions/configure-repo/

      - name: Run Jest Tests
        uses: ./.github/actions/jest-runner/
        with:
          run_code_coverage: ${{ inputs.run_code_coverage }}
          jest_test_pattern: ${{ env.JEST_TEST_PATTERN }}
          jest_test_coverage_path: ${{ env.JEST_TEST_COVERAGE_PATH }}
          github_secret: ${{ secrets.GITHUB_TOKEN }}
          report_name: "satp-oracle-integration-tests-report"

      - name: Upload coverage reports as artifacts
        if: ${{ inputs.run_code_coverage == 'true' }}
        uses: actions/upload-artifact@65462800fd760344b1a7b4382951275a0abb4808 #v4.3.3
        with:
          name: coverage-reports-satp-hermes-oracle
          path: ./code-coverage-ts/**/


  run-satp-tests-integration-gateway:
    runs-on: ubuntu-22.04
    continue-on-error: true
    env:
      JEST_TEST_PATTERN: packages/cactus-plugin-satp-hermes/src/test/typescript/integration/gateway/.*/*.test.ts
      JEST_TEST_COVERAGE_PATH: ./code-coverage-ts/cactus-plugin-satp-hermes
    steps:
      - uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 #v4.1.7

      - name: CI environment clean-up
        run: ./tools/ci-env-clean-up.sh

      - uses: ./.github/actions/docker-pull/
        with:
          image: ghcr.io/hyperledger/cactus-besu-all-in-one:2024-06-09-cc2f9c5
      
      - uses: ./.github/actions/docker-pull/
        with:
          image: ghcr.io/hyperledger-cacti/cactus-fabric2-all-in-one:v2.1.0
      
      - uses: ./.github/actions/docker-pull/
        with:
          image: ghcr.io/hyperledger/cacti-geth-all-in-one:2023-07-27-2a8c48ed6

      - name: build
        with:
          node_version: ${{ inputs.node_version }}
          yarn_hardened_mode: '0'
        uses: ./.github/actions/configure-repo/

      - name: Run Jest Tests
        uses: ./.github/actions/jest-runner/
        with:
          run_code_coverage: ${{ inputs.run_code_coverage }}
          jest_test_pattern: ${{ env.JEST_TEST_PATTERN }}
          jest_test_coverage_path: ${{ env.JEST_TEST_COVERAGE_PATH }}
          github_secret: ${{ secrets.GITHUB_TOKEN }}
          report_name: "satp-gateway-integration-tests-report"

      - name: Upload coverage reports as artifacts
        if: ${{ inputs.run_code_coverage == 'true' }}
        uses: actions/upload-artifact@65462800fd760344b1a7b4382951275a0abb4808 #v4.3.3
        with:
          name: coverage-reports-satp-hermes-gateway
          path: ./code-coverage-ts/**/


  run-satp-tests-integration-docker:
    runs-on: ubuntu-22.04
    continue-on-error: true
    env:
      JEST_TEST_PATTERN: packages/cactus-plugin-satp-hermes/src/test/typescript/integration/docker/.*/*.test.ts
      JEST_TEST_COVERAGE_PATH: ./code-coverage-ts/cactus-plugin-satp-hermes
    steps:
      - uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 #v4.1.7

      - name: CI environment clean-up
        run: ./tools/ci-env-clean-up.sh
      
      - uses: ./.github/actions/docker-pull/
        with:
          image: ghcr.io/hyperledger/cactus-besu-all-in-one:2024-06-09-cc2f9c5
      
      - uses: ./.github/actions/docker-pull/
        with:
          image: ghcr.io/hyperledger-cacti/cactus-fabric2-all-in-one:v2.1.0
      
      - uses: ./.github/actions/docker-pull/
        with:
          image: ghcr.io/hyperledger/cacti-geth-all-in-one:2023-07-27-2a8c48ed6
      
      - uses: ./.github/actions/docker-pull/
        with:
          image: kubaya/cacti-satp-hermes-gateway:5f190f37f-2025-08-19

      - uses: ./.github/actions/docker-pull/
        with:
          image: postgres:17.2

      - name: build
        with:
          node_version: ${{ inputs.node_version }}
          yarn_hardened_mode: '0'         
        uses: ./.github/actions/configure-repo/
      
      - name: Run Jest Tests
        uses: ./.github/actions/jest-runner/
        with:
          run_code_coverage: ${{ inputs.run_code_coverage }}
          jest_test_pattern: ${{ env.JEST_TEST_PATTERN }}
          jest_test_coverage_path: ${{ env.JEST_TEST_COVERAGE_PATH }}
          github_secret: ${{ secrets.GITHUB_TOKEN }}
          report_name: "satp-gateway-docker-tests-report"

      - name: Upload coverage reports as artifacts
        if: ${{ inputs.run_code_coverage == 'true' }}
        uses: actions/upload-artifact@65462800fd760344b1a7b4382951275a0abb4808 #v4.3.3
        with:
          name: coverage-reports-satp-hermes-gateway-docker
          path: ./code-coverage-ts/**/

  run-satp-tests-on-chain:
    runs-on: ubuntu-22.04
    continue-on-error: true
    steps:
      - uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 #v4.1.7
      
      - name: build
        with:
          node_version: ${{ inputs.node_version }}
          yarn_hardened_mode: '0'         
        uses: ./.github/actions/configure-repo/

      - name: Install Foundry
        uses: foundry-rs/foundry-toolchain@v1
        with:
          version: stable

      - name: Build Foundry contracts
        run: |
          set -euo pipefail
          cd packages/cactus-plugin-satp-hermes
          echo "Building Foundry contracts and tests"
          yarn forge:build:all

      - name: Run Foundry tests
        run: |
          set -euo pipefail
          cd packages/cactus-plugin-satp-hermes
          echo "Running Foundry on-chain tests"
          yarn forge:test

      - name: Upload SATP foundry test reports
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: satp-foundry-report-${{ github.job }}
          path: |
            packages/cactus-plugin-satp-hermes/src/test/solidity/generated/**/*
            packages/cactus-plugin-satp-hermes/src/main/solidity/generated/**/*

  run-satp-tests-recovery:
    runs-on: ubuntu-22.04
    continue-on-error: true
    env:
      JEST_TEST_PATTERN: packages/cactus-plugin-satp-hermes/src/test/typescript/integration/recovery/.*/*.test.ts
      JEST_TEST_COVERAGE_PATH: ./code-coverage-ts/cactus-plugin-satp-hermes
    steps:
      - uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 #v4.1.7

      - name: CI environment clean-up
        run: ./tools/ci-env-clean-up.sh

      - uses: ./.github/actions/docker-pull/
        with:
          image: ghcr.io/hyperledger/cactus-besu-all-in-one:2024-06-09-cc2f9c5
      
      - uses: ./.github/actions/docker-pull/
        with:
          image: ghcr.io/hyperledger-cacti/cactus-fabric2-all-in-one:v2.1.0
      
      - uses: ./.github/actions/docker-pull/
        with:
          image: ghcr.io/hyperledger/cacti-geth-all-in-one:2023-07-27-2a8c48ed6

      - name: build
        with:
          node_version: ${{ inputs.node_version }}
          yarn_hardened_mode: '0'
        uses: ./.github/actions/configure-repo/

      - name: Run Jest Tests
        uses: ./.github/actions/jest-runner/
        with:
          run_code_coverage: ${{ inputs.run_code_coverage }}
          jest_test_pattern: ${{ env.JEST_TEST_PATTERN }}
          jest_test_coverage_path: ${{ env.JEST_TEST_COVERAGE_PATH }}
          github_secret: ${{ secrets.GITHUB_TOKEN }}
          report_name: "satp-unit-tests-report"

      - name: Upload coverage reports as artifacts
        if: ${{ inputs.run_code_coverage == 'true' }}
        uses: actions/upload-artifact@65462800fd760344b1a7b4382951275a0abb4808 #v4.3.3
        with:
          name: coverage-reports-satp-hermes-recovery
          path: ./code-coverage-ts/**/

  run-satp-tests-rollback:
    runs-on: ubuntu-22.04
    continue-on-error: true
    env:
      JEST_TEST_PATTERN: packages/cactus-plugin-satp-hermes/src/test/typescript/integration/rollback/.*/*.test.ts
      JEST_TEST_COVERAGE_PATH: ./code-coverage-ts/cactus-plugin-satp-hermes
    steps:
      - uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 #v4.1.7

      - name: CI environment clean-up
        run: ./tools/ci-env-clean-up.sh

      - uses: ./.github/actions/docker-pull/
        with:
          image: ghcr.io/hyperledger/cactus-besu-all-in-one:2024-06-09-cc2f9c5
      
      - uses: ./.github/actions/docker-pull/
        with:
          image: ghcr.io/hyperledger-cacti/cactus-fabric2-all-in-one:v2.1.0
      
      - uses: ./.github/actions/docker-pull/
        with:
          image: ghcr.io/hyperledger/cacti-geth-all-in-one:2023-07-27-2a8c48ed6

      - name: build
        with:
          node_version: ${{ inputs.node_version }}
          yarn_hardened_mode: '0'
        uses: ./.github/actions/configure-repo/

      - name: Run Jest Tests
        uses: ./.github/actions/jest-runner/
        with:
          run_code_coverage: ${{ inputs.run_code_coverage }}
          jest_test_pattern: ${{ env.JEST_TEST_PATTERN }}
          jest_test_coverage_path: ${{ env.JEST_TEST_COVERAGE_PATH }}
          github_secret: ${{ secrets.GITHUB_TOKEN }}
          report_name: "satp-unit-tests-report"

      - name: Upload coverage reports as artifacts
        if: ${{ inputs.run_code_coverage == 'true' }}
        uses: actions/upload-artifact@65462800fd760344b1a7b4382951275a0abb4808 #v4.3.3
        with:
          name: coverage-reports-satp-hermes-rollback
          path: ./code-coverage-ts/**/
```
