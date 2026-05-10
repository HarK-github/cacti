# HYPERLEDGER CACTI DOCKER & REGISTRY CONFIGURATION
Generated: Sun May 10 03:44:49 PM IST 2026


--- FILE: .github/workflows/ghcr-workflow.yaml ---
```yaml
name: Run All GHCR Workflows

# Controls when the workflow will run
on:
  # Triggers the workflow on push or pull request events but only for the main branch
  workflow_call:
    inputs:
      node_version:
        required: true
        type: string
      run_trivy_scan:  
        required: true
        type: string
      affected-packages:
        required: false
        type: string
  
concurrency:
  group: ghcr-workflows-${{ github.workflow }}-${{ github.event.pull_request.number || github.ref }}
  cancel-in-progress: true

jobs:
    ghcr-besu-all-in-one:
      runs-on: ubuntu-22.04
      steps:
        - uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 #v4.1.7
          with:
            fetch-depth: 0
        - id: changed
          run: |
            git fetch origin ${{ github.base_ref }}
            BASE=$(git merge-base HEAD origin/${{ github.base_ref }})

            FILES=$(git diff --name-only "$BASE" HEAD | tr '\n' ' ')
            echo "files=$FILES" >> "$GITHUB_OUTPUT"
        - name: ghcr.io/hyperledger/cactus-besu-all-in-one
          if: contains(steps.changed.outputs.files, 'tools/docker/besu-all-in-one/') || contains(steps.changed.outputs.files, '.github/workflows/')
          run: DOCKER_BUILDKIT=1 docker build ./tools/docker/besu-all-in-one/ -f ./tools/docker/besu-all-in-one/Dockerfile
    ghcr-connector-corda-server:
      if: contains(fromJson(inputs.affected-packages), 'packages/cactus-plugin-ledger-connector-corda')
      runs-on: ubuntu-22.04
      steps:
        - uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 #v4.1.7
        - name: ghcr.io/hyperledger/cactus-connector-corda-server
          run: DOCKER_BUILDKIT=1 docker build ./packages/cactus-plugin-ledger-connector-corda/src/main-server/ -f ./packages/cactus-plugin-ledger-connector-corda/src/main-server/Dockerfile -t cactus-connector-corda-server
          
    ghcr-corda-all-in-one-flowdb:
      runs-on: ubuntu-22.04
      steps:
        - uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 #v4.1.7
          with:
            fetch-depth: 0
        - id: changed
          run: |
            git fetch origin ${{ github.base_ref }}
            BASE=$(git merge-base HEAD origin/${{ github.base_ref }})

            FILES=$(git diff --name-only "$BASE" HEAD | tr '\n' ' ')
            echo "files=$FILES" >> "$GITHUB_OUTPUT"
        - name: ghcr.io/hyperledger/cactus-corda-all-in-one-flowdb
          if: contains(steps.changed.outputs.files, 'tools/docker/corda-all-in-one/corda-v4_8-flowdb/') || contains(steps.changed.outputs.files, '.github/workflows/')
          run: DOCKER_BUILDKIT=1 docker build ./tools/docker/corda-all-in-one/corda-v4_8-flowdb/

    ghcr-dev-container-vscode:
      runs-on: ubuntu-22.04
      env:
        IMAGE_NAME: cacti-dev-container-vscode
      steps:
        - uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 #v4.1.7
          with:
            fetch-depth: 0
        - id: changed
          run: |
            git fetch origin ${{ github.base_ref }}
            BASE=$(git merge-base HEAD origin/${{ github.base_ref }})

            FILES=$(git diff --name-only "$BASE" HEAD | tr '\n' ' ')
            echo "files=$FILES" >> "$GITHUB_OUTPUT"
        - name: Use Node.js ${{ inputs.node_version }}
          if: contains(steps.changed.outputs.files, '.devcontainer/') || contains(steps.changed.outputs.files, '.github/workflows/')
          uses: actions/setup-node@1e60f620b9541d16bece96c5465dc8ee9832be0b #v4.0.3
          with:
            node-version: ${{ inputs.node_version }}
        - name: npm_install_@devcontainers/cli@0.44.0
          if: contains(steps.changed.outputs.files, '.devcontainer/') || contains(steps.changed.outputs.files, '.github/workflows/')
          run: npm install -g @devcontainers/cli@0.44.0
        - name: npx_yes_devcontainers_cli_build
          if: contains(steps.changed.outputs.files, '.devcontainer/') || contains(steps.changed.outputs.files, '.github/workflows/')
          run: npx --yes @devcontainers/cli@0.44.0 build --workspace-folder="./" --log-level=trace --push=false --config="./.devcontainer/devcontainer.json" --image-name="$IMAGE_NAME"

    ghcr-example-supply-chain-app:
      if: contains(fromJson(inputs.affected-packages), 'examples/cactus-example-supply-chain-backend')
      runs-on: ubuntu-22.04
      steps:
        - uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 #v4.1.7
        - name: ghcr.io/hyperledger/cactus-example-supply-chain-app
          run: DOCKER_BUILDKIT=1 docker build . -f ./examples/cactus-example-supply-chain-backend/Dockerfile -t cactus-example-supply-chain-app

    ghcr-fabric2-all-in-one:
      runs-on: ubuntu-22.04
      steps:
        - uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 #v4.1.7
          with:
            fetch-depth: 0
        - id: changed
          run: |
            git fetch origin ${{ github.base_ref }}
            BASE=$(git merge-base HEAD origin/${{ github.base_ref }})

            FILES=$(git diff --name-only "$BASE" HEAD | tr '\n' ' ')
            echo "files=$FILES" >> "$GITHUB_OUTPUT"
        - name: ghcr.io/hyperledger/cactus-fabric2-all-in-one
          if: contains(steps.changed.outputs.files, 'tools/docker/fabric-all-in-one/') || contains(steps.changed.outputs.files, '.github/workflows/')
          run: DOCKER_BUILDKIT=1 docker build ./tools/docker/fabric-all-in-one/ -f ./tools/docker/fabric-all-in-one/Dockerfile_v2.x

    ghcr-daml-all-in-one:
      runs-on: ubuntu-22.04
      steps:
        - uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 #v4.1.7
          with:
            fetch-depth: 0
        - id: changed
          run: |
            git fetch origin ${{ github.base_ref }}
            BASE=$(git merge-base HEAD origin/${{ github.base_ref }})

            FILES=$(git diff --name-only "$BASE" HEAD | tr '\n' ' ')
            echo "files=$FILES" >> "$GITHUB_OUTPUT"
        - name: ghcr.io/hyperledger/daml-all-in-one
          if: contains(steps.changed.outputs.files, 'tools/docker/daml-all-in-one/') || contains(steps.changed.outputs.files, '.github/workflows/')
          run: DOCKER_BUILDKIT=1 docker build ./tools/docker/daml-all-in-one/ -f ./tools/docker/daml-all-in-one/Dockerfile

    ghcr-keychain-vault-server:
      if: contains(fromJson(inputs.affected-packages), 'packages/cactus-plugin-keychain-vault')
      runs-on: ubuntu-22.04
      steps:
        - uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 #v4.1.7
        - name: ghcr.io/hyperledger/cactus-keychain-vault-server
          run: DOCKER_BUILDKIT=1 docker build ./packages/cactus-plugin-keychain-vault/src/cactus-keychain-vault-server/ -f ./packages/cactus-plugin-keychain-vault/src/cactus-keychain-vault-server/Dockerfile -t cactus-keychain-vault-server
        - if: ${{ inputs.run_trivy_scan == 'true' && github.event.name == 'schedule' }}
          name: Run Trivy vulnerability scan for cactus-keychain-vault-server
          uses: aquasecurity/trivy-action@d710430a6722f083d3b36b8339ff66b32f22ee55 #0.19.0
          with:
            image-ref: 'cactus-keychain-vault-server'
            format: 'table'
            exit-code: '1'
            ignore-unfixed: false
            vuln-type: 'os,library'
            severity: 'CRITICAL,HIGH'




```


--- FILE: .github/workflows/fabric2-all-in-one-publish.yaml ---
```yaml
name: fabric2-all-in-one-publish

on:
  # Publish `v1.2.3` tags as releases.
  push:
    tags:
      - v*

concurrency:
  group: ${{ github.workflow }}-${{ github.event.pull_request.number || github.ref }}
  cancel-in-progress: true

env:
  IMAGE_NAME: cactus-fabric2-all-in-one

jobs:
  # Push image to GitHub Packages.
  # See also https://docs.docker.com/docker-hub/builds/
  build-tag-push-container:
    runs-on: ubuntu-22.04
    env:
      DOCKER_BUILDKIT: 1
      DOCKERFILE_PATH: ./tools/docker/fabric-all-in-one/Dockerfile_v2.x
      DOCKER_BUILD_DIR: ./tools/docker/fabric-all-in-one/
    permissions:
      packages: write
      contents: read

    steps:
      - uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 #v4.1.7

      - name: Build image
        run: docker build "$DOCKER_BUILD_DIR" --file "$DOCKERFILE_PATH" --tag "$IMAGE_NAME" --label "runnumber=${GITHUB_RUN_ID}"

      - name: Log in to registry
        # This is where you will update the PAT to GITHUB_TOKEN
        run: echo "${{ secrets.GITHUB_TOKEN }}" | docker login ghcr.io -u ${{ github.actor }} --password-stdin

      - name: Push image
        run: |
          SHORTHASH=$(git rev-parse --short "$GITHUB_SHA")
          TODAYS_DATE="$(date +%F)"
          DOCKER_TAG="$TODAYS_DATE-$SHORTHASH"
          IMAGE_ID="ghcr.io/${{ github.repository_owner }}/$IMAGE_NAME"
          # Change all uppercase to lowercase
          IMAGE_ID=$(echo "$IMAGE_ID" | tr '[:upper:]' '[:lower:]')
          # Strip git ref prefix from version
          VERSION=$(echo "${{ github.ref }}" | sed -e 's,.*/\(.*\),\1,')
          # Strip "v" prefix from tag name
          [[ "${{ github.ref }}" == "refs/tags/*" ]] && VERSION="${VERSION//^v//}"
          # Do not use the `latest` tag at all, tag with date + git short hash if there is no git tag
          [ "$VERSION" == "main" ] && VERSION=$DOCKER_TAG
          echo IMAGE_ID="$IMAGE_ID"
          echo VERSION="$VERSION"
          docker tag "$IMAGE_NAME" "$IMAGE_ID:$VERSION"
          docker push "$IMAGE_ID:$VERSION"

```


--- FILE: .github/workflows/besu-all-in-one-publish.yaml ---
```yaml
name: besu-all-in-one-publish

on:
  # Publish `v1.2.3` tags as releases.
  push:
    tags:
      - v*

concurrency:
  group: ${{ github.workflow }}-${{ github.event.pull_request.number || github.ref }}
  cancel-in-progress: true

env:
  IMAGE_NAME: besu-all-in-one

jobs:
  # Push image to GitHub Packages.
  # See also https://docs.docker.com/docker-hub/builds/
  build-tag-push-container:
    runs-on: ubuntu-22.04
    env:
      DOCKER_BUILDKIT: 1
      DOCKERFILE_PATH: ./tools/docker/besu-all-in-one/Dockerfile
      DOCKER_BUILD_DIR: ./tools/docker/besu-all-in-one/
    permissions:
      packages: write
      contents: read

    steps:
      - uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 #v4.1.7

      - name: Build image
        run: docker build "$DOCKER_BUILD_DIR" --file "$DOCKERFILE_PATH" --tag "$IMAGE_NAME" --label "runnumber=${GITHUB_RUN_ID}"

      - name: Log in to registry
        # This is where you will update the PAT to GITHUB_TOKEN
        run: echo "${{ secrets.GITHUB_TOKEN }}" | docker login ghcr.io -u ${{ github.actor }} --password-stdin

      - name: Push image
        run: |
          SHORTHASH=$(git rev-parse --short "$GITHUB_SHA")
          TODAYS_DATE="$(date +%F)"
          DOCKER_TAG="$TODAYS_DATE-$SHORTHASH"
          IMAGE_ID="ghcr.io/${{ github.repository_owner }}/$IMAGE_NAME"
          # Change all uppercase to lowercase
          IMAGE_ID=$(echo "$IMAGE_ID" | tr '[:upper:]' '[:lower:]')
          # Strip git ref prefix from version
          VERSION=$(echo "${{ github.ref }}" | sed -e 's,.*/\(.*\),\1,')
          # Strip "v" prefix from tag name
          [[ "${{ github.ref }}" == "refs/tags/*" ]] && VERSION="${VERSION//^v//}"
          # Do not use the `latest` tag at all, tag with date + git short hash if there is no git tag
          [ "$VERSION" == "main" ] && VERSION=$DOCKER_TAG
          echo IMAGE_ID="$IMAGE_ID"
          echo VERSION="$VERSION"
          docker tag "$IMAGE_NAME" "$IMAGE_ID:$VERSION"
          docker push "$IMAGE_ID:$VERSION"

```


--- FILE: tools/docker/fabric-all-in-one/Dockerfile_v2.x ---
```dockerfile
FROM docker:24.0.5-dind

ARG FABRIC_VERSION=2.5.6
ARG FABRIC_NODEENV_VERSION=2.5.4
ARG CA_VERSION=1.5.6
ARG COUCH_VERSION_FABRIC=0.4
ARG COUCH_VERSION=3.2.2

WORKDIR /

RUN apk update && apk --no-cache upgrade openssh-client

# Install dependencies of Docker Compose
RUN apk add docker-cli docker-cli-compose

# Need git to clone the sources of the Fabric Samples repository from GitHub
RUN apk add --no-cache git

# Fabric Samples needs bash, sh is not good enough here
RUN apk add --no-cache bash

# Need curl to download the Fabric installation script
RUN apk add --no-cache curl

# The file binary is used to inspect exectubles when debugging container image issues
RUN apk add --no-cache file

# Need NodeJS tooling for the Typescript contracts
RUN apk add --no-cache npm nodejs

# Need YQ to mutate the core.yaml and docker-compose files for Fabric config changes
RUN apk add --no-cache yq

# Download and setup path variables for Go
RUN wget https://golang.org/dl/go1.22.4.linux-amd64.tar.gz
RUN tar -xvf go1.22.4.linux-amd64.tar.gz
RUN mv go /usr/local
ENV GOROOT=/usr/local/go
ENV GOPATH=/usr/local/go
ENV PATH=$PATH:$GOPATH/bin
RUN rm go1.22.4.linux-amd64.tar.gz

# Needed as of as of go v1.20
# @see https://github.com/golang/go/issues/59305#issuecomment-1488478737
RUN apk add gcompat

# Needed because the Fabric binaries need the GNU libc dynamic linker to be executed
# and alpine does not have that by default
# @see https://askubuntu.com/a/1035037/1008695
# @see https://github.com/gliderlabs/docker-alpine/issues/219#issuecomment-254741346
RUN apk add --no-cache libc6-compat

ENV CACTUS_CFG_PATH=/etc/hyperledger/cactus
RUN mkdir -p $CACTUS_CFG_PATH
# Installing OpenSSH:
# 1. OpenSSH - need to have it so we can shell in and install/instantiate contracts
# 2. Before installing we need to wipe all pre-existing installations which Alpine
# started shipping in recent versions. Without cleaning up first, our installation
# crash with this:
#
#    => ERROR [17/64] RUN apk add --no-cache openssh augeas                                                                                                                                                     1.1s
#   ------
#    > [17/64] RUN apk add --no-cache openssh augeas:
#   0.300 fetch https://dl-cdn.alpinelinux.org/alpine/v3.18/main/x86_64/APKINDEX.tar.gz
#   0.560 fetch https://dl-cdn.alpinelinux.org/alpine/v3.18/community/x86_64/APKINDEX.tar.gz
#   1.041 ERROR: unable to select packages:
#   1.043   openssh-client-common-9.3_p1-r3:
#   1.043     breaks: openssh-client-default-9.3_p2-r0[openssh-client-common=9.3_p2-r0]
RUN apk del openssh*
RUN apk add --no-cache openssh augeas

# Configure the OpenSSH server we just installed
RUN augtool 'set /files/etc/ssh/sshd_config/AuthorizedKeysFile ".ssh/authorized_keys /etc/authorized_keys/%u"'
RUN augtool 'set /files/etc/ssh/sshd_config/PermitRootLogin yes'
RUN augtool 'set /files/etc/ssh/sshd_config/PasswordAuthentication no'
RUN augtool 'set /files/etc/ssh/sshd_config/PermitEmptyPasswords no'
RUN augtool 'set /files/etc/ssh/sshd_config/Port 22'
RUN augtool 'set /files/etc/ssh/sshd_config/LogLevel DEBUG2'
RUN augtool 'set /files/etc/ssh/sshd_config/LoginGraceTime 10'
# Create the server's key - without this sshd will refuse to start
RUN ssh-keygen -A

# Generate an RSA keypair on the fly to avoid having to hardcode one in the image
# which technically does not pose a security threat since this is only a development
# image, but we do it like this anyway.
RUN mkdir ~/.ssh
RUN chmod 700 ~/.ssh/
RUN touch ~/.ssh/authorized_keys
RUN ["/bin/bash", "-c", "ssh-keygen -t rsa -N '' -f $CACTUS_CFG_PATH/fabric-aio-image <<< y"]
RUN mv $CACTUS_CFG_PATH/fabric-aio-image $CACTUS_CFG_PATH/fabric-aio-image.key
RUN cp $CACTUS_CFG_PATH/fabric-aio-image.pub ~/.ssh/authorized_keys

# OpenSSH Server (needed for chaincode deployment )
EXPOSE 22

# orderer.example.com
EXPOSE 7050

# peer0.org1.example.com
EXPOSE 7051

# peer0.org2.example.com
EXPOSE 9051

# ca_org1
EXPOSE 7054

# ca_org2
EXPOSE 8054

# ca_orderer
EXPOSE 9054

# supervisord web ui/dashboard
EXPOSE 9001

# couchdb0, couchdb1, couchdb2, couchdb3
EXPOSE 5984 6984 7984 8984

RUN apk add --no-cache util-linux

# FIXME - make it so that SSHd does not need this to work
RUN echo "root:$(uuidgen)" | chpasswd

RUN curl -sSL https://raw.githubusercontent.com/cloudflare/semver_bash/c1133faf0efe17767b654b213f212c326df73fa3/semver.sh > /semver.sh
RUN chmod +x /semver.sh

# jq is needed by the /download-frozen-image-v2.sh script to pre-fetch docker images without docker.
RUN apk add --no-cache jq

# Get the utility script that can pre-fetch the Fabric docker images without
# a functioning Docker daemon available which we do not have at image build
# time so have to resort to manually get the Fabric images insteadd of just saying
# "docker pull hyperledger/fabric..." etc.
# The reason to jump trough these hoops is to speed up the boot time of the
# container which won't have to download the images at container startup since
# they'll have been cached already at build time.
RUN curl -sSL https://raw.githubusercontent.com/moby/moby/dedf8528a51c6db40686ed6676e9486d1ed5f9c0/contrib/download-frozen-image-v2.sh > /download-frozen-image-v2.sh
RUN chmod +x /download-frozen-image-v2.sh

RUN mkdir -p /etc/hyperledger/fabric/fabric-peer/
RUN mkdir -p /etc/hyperledger/fabric/fabric-orderer/
RUN mkdir -p /etc/hyperledger/fabric/fabric-ccenv/
RUN mkdir -p /etc/hyperledger/fabric/fabric-nodeenv/
RUN mkdir -p /etc/hyperledger/fabric/fabric-tools/
RUN mkdir -p /etc/hyperledger/fabric/fabric-baseos/
RUN mkdir -p /etc/hyperledger/fabric/fabric-ca/
RUN mkdir -p /etc/hyperledger/fabric/fabric-couchdb/
RUN mkdir -p /etc/couchdb/

RUN /download-frozen-image-v2.sh /etc/hyperledger/fabric/fabric-peer/ hyperledger/fabric-peer:${FABRIC_VERSION}
RUN /download-frozen-image-v2.sh /etc/hyperledger/fabric/fabric-orderer/ hyperledger/fabric-orderer:${FABRIC_VERSION}
RUN /download-frozen-image-v2.sh /etc/hyperledger/fabric/fabric-ccenv/ hyperledger/fabric-ccenv:${FABRIC_VERSION}
RUN /download-frozen-image-v2.sh /etc/hyperledger/fabric/fabric-nodeenv/ hyperledger/fabric-nodeenv:${FABRIC_NODEENV_VERSION}
RUN /download-frozen-image-v2.sh /etc/hyperledger/fabric/fabric-tools/ hyperledger/fabric-tools:${FABRIC_VERSION}
RUN /download-frozen-image-v2.sh /etc/hyperledger/fabric/fabric-baseos/ hyperledger/fabric-baseos:${FABRIC_VERSION}
RUN /download-frozen-image-v2.sh /etc/hyperledger/fabric/fabric-ca/ hyperledger/fabric-ca:${CA_VERSION}
RUN /download-frozen-image-v2.sh /etc/hyperledger/fabric/fabric-couchdb/ hyperledger/fabric-couchdb:${COUCH_VERSION_FABRIC}
RUN /download-frozen-image-v2.sh /etc/couchdb/ couchdb:${COUCH_VERSION}

# Download and execute the Fabric installation script, but instruct it with the -d
# flag to avoid pulling docker images because during the build phase of this image
# there is no docker daemon running yet
RUN curl -sSLO https://raw.githubusercontent.com/hyperledger/fabric/main/scripts/install-fabric.sh > /install-fabric.sh
RUN chmod +x install-fabric.sh
RUN /install-fabric.sh --fabric-version ${FABRIC_VERSION} --ca-version ${CA_VERSION} binary samples

# Update the image version used by the Fabric peers when installing chaincodes.
# This is necessary because the older (default) image uses NodeJS v12 and npm v6
# But we need at least NodeJS 16 and npm v7 for the dependency installation to work.
RUN sed -i "s/fabric-nodeenv:\$(TWO_DIGIT_VERSION)/fabric-nodeenv:${FABRIC_NODEENV_VERSION}/g" /fabric-samples/test-network/compose/docker/peercfg/core.yaml

RUN yq '.chaincode.logging.level = "debug"' \
    --inplace /fabric-samples/test-network/compose/docker/peercfg/core.yaml

# Set the log level of the peers and other containers to DEBUG instead of the default INFO
RUN sed -i "s/FABRIC_LOGGING_SPEC=INFO/FABRIC_LOGGING_SPEC=DEBUG/g" /fabric-samples/test-network/compose/docker/docker-compose-test-net.yaml

# For now this cannot be used because it mangles the outupt of the "peer lifecycle chaincode queryinstalled" commands.
# We need to refactor those commands in the deployment endpoints so that they are immune to this logging setting.
# RUN sed -i "s/FABRIC_LOGGING_SPEC=INFO/FABRIC_LOGGING_SPEC=DEBUG/g" /fabric-samples/test-network/compose/compose-test-net.yaml

# Update the docker-compose file of the fabric-samples repo so that the
# core.yaml configuration file of the peer containers can be customized.
# We need the above because we need to override the NodeJS version the peers are
# using when building the chaincodes in the tests. This is necessary because the
# older npm version (v6) that NodeJS v12 ships with breaks down and crashes with
# an error when the peer tries to install the dependencies as part of the
# chaincode installation.
RUN yq '.services."peer0.org1.example.com".volumes += "../..:/opt/gopath/src/github.com/hyperledger/fabric-samples"' \
    --inplace /fabric-samples/test-network/compose/docker/docker-compose-test-net.yaml
RUN yq '.services."peer0.org1.example.com".volumes += "../../config/core.yaml:/etc/hyperledger/fabric/core.yaml"' \
    --inplace /fabric-samples/test-network/compose/docker/docker-compose-test-net.yaml
RUN yq '.services."peer0.org2.example.com".volumes += "../..:/opt/gopath/src/github.com/hyperledger/fabric-samples"' \
    --inplace /fabric-samples/test-network/compose/docker/docker-compose-test-net.yaml
RUN yq '.services."peer0.org2.example.com".volumes += "../../config/core.yaml:/etc/hyperledger/fabric/core.yaml"' \
    --inplace /fabric-samples/test-network/compose/docker/docker-compose-test-net.yaml


# Install supervisord because we need to run the docker daemon and also the fabric network
# meaning that we have multiple processes to run.
RUN apk add --no-cache supervisor

COPY supervisord.conf /etc/supervisord.conf
COPY run-fabric-network.sh /
COPY healthcheck.sh /

ENV FABRIC_CFG_PATH=/fabric-samples/config/
ENV CORE_PEER_TLS_ENABLED=true
ENV CORE_PEER_LOCALMSPID="Org1MSP"
ENV CORE_PEER_TLS_ROOTCERT_FILE=/fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
ENV CORE_PEER_MSPCONFIGPATH=/fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
ENV CORE_PEER_ADDRESS=localhost:7051
ENV COMPOSE_PROJECT_NAME=cactusfabrictestnetwork
ENV FABRIC_VERSION=${FABRIC_VERSION}
ENV CA_VERSION=${CA_VERSION}
ENV COUCH_VERSION_FABRIC=${COUCH_VERSION_FABRIC}
ENV COUCH_VERSION=${COUCH_VERSION}

# Extend the parent image's entrypoint
# https://superuser.com/questions/1459466/can-i-add-an-additional-docker-entrypoint-script
ENTRYPOINT ["/usr/bin/supervisord"]
CMD ["--configuration", "/etc/supervisord.conf", "--nodaemon"]

# We consider the container healthy once the default example asset-transfer contract has been deployed
# and is responsive to queries as well
HEALTHCHECK --interval=1s --timeout=5s --start-period=60s --retries=300 CMD ./healthcheck.sh

```


--- FILE: tools/docker/besu-all-in-one/Dockerfile ---
```dockerfile
FROM hyperledger/besu:25.4.0

LABEL org.opencontainers.image.source="https://github.com/hyperledger-cacti/cacti"

RUN apt update -y && \
    apt install --no-install-recommends --yes curl && \
    rm -rf /var/lib/apt/lists/*

ADD ./genesis.json /opt/besu/genesis.json

ENV BESU_LOGGING=WARN
ENV BESU_GENESIS_FILE="/opt/besu/genesis.json"
ENV BESU_REVERT_REASON_ENABLED=true
ENV BESU_NETWORK=dev
ENV BESU_RPC_HTTP_ENABLED="true"
ENV BESU_RPC_WS_ENABLED="true"
ENV BESU_HOST_WHITELIST="*"
ENV BESU_RPC_HTTP_API="ETH,NET,WEB3,CLIQUE,TRACE,DEBUG"
ENV BESU_RPC_HTTP_CORS_ORIGINS=all
ENV BESU_RPC_WS_API="ETH,NET,WEB3,CLIQUE,TRACE,DEBUG"
ENV BESU_MINER_ENABLED="true"
ENV BESU_MINER_COINBASE="0x0000000000000000000000000000000000000000"
ENV BESU_MIN_GAS_PRICE="0"

```


--- FILE: tools/docker/fabric-all-in-one/README.md ---
```markdown
# fabric-docker-all-in-one

> This docker image is for `testing` and `development` only.
> Do NOT use in production!

An all in one fabric docker image with the `fabric-samples` repo fully embedded.

## Usage

### Local Image Builds

From the project root:

```sh
# Fabric 2.X
DOCKER_BUILDKIT=1 docker build ./tools/docker/fabric-all-in-one/ -f ./tools/docker/fabric-all-in-one/Dockerfile_v2.x -t faio2x
docker run --detach --privileged --publish-all --name faio2x-testnet faio2x

# Docker compose (Fabric 2.X)
docker-compose -f ./tools/docker/fabric-all-in-one/docker-compose-v2.x.yml build
docker-compose -f ./tools/docker/fabric-all-in-one/docker-compose-v2.x.yml up -d

# Check SSH
docker cp IMG_NAME:/etc/hyperledger/cactus/fabric-aio-image.key ./fabric-aio-image.key
ssh root@localhost -p IMG_SSH_PORT -i fabric-aio-image.key
```

### Visual Studio Code

Example `.vscode/tasks.json` file for building/running the image:

```json
{
  "version": "2.1.0",
  "tasks": [
    {
      "label": "Docker - BUILD and TAG: 2.x",
      "type": "shell",
      "command": "docker build . -f Dockerfile_v2.x -t hyperledger/cactus-fabric-all-in-one:2.2.0"
    },
    {
      "label": "Docker Compose - BUILD",
      "type": "shell",
      "command": "docker-compose build --force-rm"
    },
    {
      "label": "Docker Compose - UP",
      "type": "shell",
      "command": "docker-compose up --force-recreate "
    }
  ]
}
```

### Local Image Builds

From the project root:

```sh
DOCKER_BUILDKIT=1 docker build ./tools/docker/fabric-all-in-one/ -f ./tools/docker/fabric-all-in-one/Dockerfile_v2.x -t faio2x
docker run --detach --privileged --publish-all --env FABRIC_VERSION=2.2.13 faio2x

docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                     PORTS                                                                                                                                                                                                                                                                                                                                                                                  NAMES
db676059b79e        faio2x              "/usr/bin/supervisor…"   9 minutes ago       Up 9 minutes   0.0.0.0:32924->22/tcp, 0.0.0.0:32923->2375/tcp, 0.0.0.0:32922->2376/tcp, 0.0.0.0:32921->5984/tcp, 0.0.0.0:32920->6984/tcp, 0.0.0.0:32919->7050/tcp, 0.0.0.0:32918->7051/tcp, 0.0.0.0:32917->7054/tcp, 0.0.0.0:32916->7984/tcp, 0.0.0.0:32915->8051/tcp, 0.0.0.0:32914->8054/tcp, 0.0.0.0:32913->8984/tcp, 0.0.0.0:32912->9001/tcp, 0.0.0.0:32911->9051/tcp, 0.0.0.0:32910->10051/tcp   sharp_clarke

docker cp db676059b79e:/etc/hyperledger/cactus/fabric-aio-image.key ./fabric-aio-image.key

ssh root@localhost -p 32924 -i fabric-aio-image.key
```


### Running Fabric CLI Container Commands


For Fabric 2.x

```sh
cd /fabric-samples/test-network
export PATH=${PWD}/../bin:${PWD}:$PATH
export FABRIC_CFG_PATH=$PWD/../config/
# for peer command issued to peer0.org1.example.com
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051
peer chaincode query --channelID mychannel --name fabcar --ctor '{"Args": [], "Function": "queryAllCars"}'
[{"Key":"CAR0","Record":{"make":"Toyota","model":"Prius","colour":"blue","owner":"Tom"}},{"Key":"CAR1","Record":{"make":"Ford","model":"Mustang","colour":"red","owner":"Brad"}},{"Key":"CAR2","Record":{"make":"Hyundai","model":"Tucson","colour":"green","owner":"Jin Soo"}},{"Key":"CAR277","Record":{"make":"Trabant","model":"601","colour":"Blue","owner":"4cf0a45d-1349-4900-927c-d03e2a2c4dfc"}},{"Key":"CAR3","Record":{"make":"Volkswagen","model":"Passat","colour":"yellow","owner":"Max"}},{"Key":"CAR4","Record":{"make":"Tesla","model":"S","colour":"black","owner":"Adriana"}},{"Key":"CAR5","Record":{"make":"Peugeot","model":"205","colour":"purple","owner":"Michel"}},{"Key":"CAR6","Record":{"make":"Chery","model":"S22L","colour":"white","owner":"Aarav"}},{"Key":"CAR7","Record":{"make":"Fiat","model":"Punto","colour":"violet","owner":"Pari"}},{"Key":"CAR8","Record":{"make":"Tata","model":"Nano","colour":"indigo","owner":"Valeria"}},{"Key":"CAR9","Record":{"make":"Holden","model":"Barina","colour":"brown","owner":"Shotaro"}}]
```

```
