# CACTI CI/CD & CONFIGURATION EXPORT
Exported on: Sun May 10 03:27:37 PM IST 2026


--- FILE: package.json ---
```
{
  "name": "@hyperledger/cactus",
  "license": "Apache-2.0",
  "private": true,
  "description": "Root project for Cactus which contains all core components and plugins developed by the project.",
  "workspaces": {
    "packages": [
      "packages/cactus-*",
      "extensions/cactus-*",
      "packages/cacti-*",
      "examples/cactus-*",
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
    ]
  },
  "scripts": {
    "audit": "yarn npm audit --recursive --all --environment production",
    "run-ci": "./tools/ci.sh",
    "reset:node-modules": "del-cli '**/node_modules'",
    "reset:git": "git clean -f -X",
    "reset:yarn-lock": "yarn run init-registries && yarn install --update-checksums --force",
    "reset": "run-s reset:git reset:node-modules reset:yarn-lock configure",
    "configure": "yarn init-registries && yarn install && yarn build:dev:backend",
    "set-yarn-version": "yarn set version stable",
    "enable-corepack": "npm i -g corepack && corepack enable && corepack prepare yarn@4.3.1 --activate",
    "custom-checks": "TS_NODE_PROJECT=./tools/tsconfig.json node --trace-deprecation --experimental-modules --abort-on-uncaught-exception --loader ts-node/esm --experimental-specifier-resolution=node ./tools/custom-checks/run-custom-checks.ts",
    "tools:install-pre-commit-secret-detection": "pre-commit install && pre-commit autoupdate",
    "tools:uninstall-pre-commit-secret-detection": "pre-commit uninstall",
    "tools:validate-bundle-names": "TS_NODE_PROJECT=./tools/tsconfig.json node --trace-deprecation --experimental-modules --abort-on-uncaught-exception --loader ts-node/esm --experimental-specifier-resolution=node ./tools/validate-bundle-names.js",
    "tools:bump-openapi-spec-dep-versions": "TS_NODE_PROJECT=./tools/tsconfig.json node --trace-deprecation --experimental-modules --abort-on-uncaught-exception --loader ts-node/esm --experimental-specifier-resolution=node ./tools/bump-openapi-spec-dep-versions.ts",
    "tools:bundle-open-api-tpl-files": "TS_NODE_PROJECT=./tools/tsconfig.json node --trace-deprecation --experimental-modules --abort-on-uncaught-exception --loader ts-node/esm --experimental-specifier-resolution=node ./tools/bundle-open-api-tpl-files.ts",
    "tools:check-dependency-version-consistency": "TS_NODE_PROJECT=./tools/tsconfig.json node --trace-deprecation --experimental-modules --abort-on-uncaught-exception --loader ts-node/esm --experimental-specifier-resolution=node ./tools/custom-checks/check-dependency-version-consistency.ts",
    "tools:create-production-only-archive": "TS_NODE_PROJECT=./tools/tsconfig.json node --trace-deprecation --experimental-modules --abort-on-uncaught-exception --loader ts-node/esm --experimental-specifier-resolution=node ./tools/create-production-only-archive.ts",
    "tools:download-file-to-disk": "TS_NODE_PROJECT=./tools/tsconfig.json node --trace-deprecation --experimental-modules --abort-on-uncaught-exception --loader ts-node/esm --experimental-specifier-resolution=node ./tools/download-file-to-disk.ts",
    "tools:get-latest-sem-ver-git-tag": "TS_NODE_PROJECT=./tools/tsconfig.json node --abort-on-uncaught-exception --loader ts-node/esm --experimental-specifier-resolution=node --no-warnings ./tools/get-latest-sem-ver-git-tag.ts",
    "tools:generate-sbom": "TS_NODE_PROJECT=tools/tsconfig.json node --experimental-json-modules --trace-deprecation --experimental-modules --abort-on-uncaught-exception --loader ts-node/esm --experimental-specifier-resolution=node ./tools/generate-sbom.ts",
    "tools:fix-pkg-npm-scope": "TS_NODE_PROJECT=tools/tsconfig.json node --experimental-json-modules --trace-deprecation --experimental-modules --abort-on-uncaught-exception --loader ts-node/esm --experimental-specifier-resolution=node ./tools/custom-checks/check-pkg-npm-scope.ts",
    "tools:sort-package-json": "TS_NODE_PROJECT=tools/tsconfig.json node --experimental-json-modules --trace-deprecation --experimental-modules --abort-on-uncaught-exception --loader ts-node/esm --experimental-specifier-resolution=node ./tools/sort-package-json.ts",
    "tools:check-missing-node-deps": "TS_NODE_PROJECT=tools/tsconfig.json node --experimental-json-modules --trace-deprecation --experimental-modules --abort-on-uncaught-exception --loader ts-node/esm --experimental-specifier-resolution=node ./tools/custom-checks/check-missing-node-deps.ts",
    "tools:are-the-types-wrong": "TS_NODE_PROJECT=./tools/tsconfig.json node --trace-deprecation --experimental-modules --abort-on-uncaught-exception --loader ts-node/esm --experimental-specifier-resolution=node ./tools/custom-checks/run-attw-on-tgz.ts",
    "setup:openapi-generator": "yarn codegen:warmup-mkdir && yarn codegen:warmup-v6.6.0 && openapi-generator-cli version-manager set 6.6.0",
    "generate-api-server-config": "yarn node ./tools/generate-api-server-config.js",
    "sync-ts-config": "TS_NODE_PROJECT=tools/tsconfig.json node --experimental-json-modules --loader ts-node/esm ./tools/sync-npm-deps-to-tsc-projects.ts",
    "start:api-server": "yarn node ./packages/cactus-cmd-api-server/dist/lib/main/typescript/cmd/cactus-api.js --config-file=.config.json",
    "start:example-supply-chain": "yarn build:dev && cd ./examples/cactus-example-supply-chain-backend/ && yarn start",
    "start:example-carbon-accounting": "CONFIG_FILE=examples/cactus-example-carbon-accounting-backend/example-config.json node examples/cactus-example-carbon-accounting-backend/dist/lib/main/typescript/carbon-accounting-app-cli.js",
    "start:example-cbdc-bridging-app": "node -r ts-node/register examples/cactus-example-cbdc-bridging-backend/dist/lib/main/typescript/cbdc-bridging-app-cli.js dotenv_config_path=examples/cactus-example-cbdc-bridging-backend/process.env",
    "purge-build-cache": "del-cli .build-cache/*",
    "clean": "yarn purge-build-cache && del-cli \"./{packages,examples,extensions}/cactus-*/{dist,.nyc_output,src/main/kotlin/generated/openapi/kotlin-client/*,src/main/proto/generated/*,src/main/typescript/generated/openapi/typescript-axios/*,src/main-server/kotlin/gen/kotlin-spring/src/**/{model,api}/*}\" \"!**/.openapi-generator-ignore\"",
    "lint": "run-s format:eslint format:prettier spellcheck",
    "check:circular-deps": "lerna exec --no-bail -- madge --circular --extensions ts ./src/main/typescript/",
    "format:eslint": "eslint '**/*.{js,ts}' --quiet --fix",
    "format:prettier": "prettier --write --config .prettierrc.js \"./**/{openapi.json,*.ts,*.js}\"",
    "spellcheck": "cspell lint --no-progress \"*/*/src/**/*.{js,ts}\"",
    "tsc": "NODE_OPTIONS=\"--max_old_space_size=3072\" tsc --build --verbose",
    "codegen": "run-s 'codegen:warmup-*' codegen:verify codegen:lerna codegen:cleanup",
    "codegen:cleanup": "rm -f -v ./openapitools.json",
    "codegen:verify": "yarn exec openapi-generator-cli version",
    "codegen:lerna": "openapi-generator-cli version-manager set 6.6.0 && yarn exec lerna run codegen",
    "codegen:warmup-bundle": "yarn tools:bundle-open-api-tpl-files",
    "codegen:warmup-cleancodegendir": "yarn node tools/clear-openapi-codegen-folders.js",
    "codegen:warmup-mkdir": "make-dir ./.cache/openapi-generator-cli/versions/",
    "codegen:warmup-v6.6.0": "yarn codegen:ensure-jar-exists || yarn tools:download-file-to-disk --url=https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/6.6.0/openapi-generator-cli-6.6.0.jar --output-file-path=./.cache/openapi-generator-cli/versions/6.6.0.jar",
    "codegen:ensure-jar-exists": "test -f ./.cache/openapi-generator-cli/versions/6.6.0.jar",
    "watch-other": "lerna run --parallel watch",
    "watch-tsc": "tsc --build --watch",
    "watch": "run-p -r watch-*",
    "docs:diagrams": "mkdir -p docs/assets && echo 'Generating Getting Started guide diagrams (PNG)...' && bash -c 'for f in docs/docs/guides/diagrams/*.mmd; do name=$(basename \"$f\" .mmd); echo \"  $name.png\"; mmdc -i \"$f\" -o \"docs/assets/$name.png\" -t default -b transparent -w 1920 -s 2; done' && echo 'All diagrams generated successfully'",
    "build": "npm-run-all build:dev build:prod",
    "build:prod": "npm-run-all build:prod:frontend",
    "build:prod:frontend": "lerna run build:prod:frontend",
    "build:dev": "yarn build:dev:backend && yarn webpack:dev:web && yarn build:dev:frontend",
    "build:dev:backend": "NODE_OPTIONS=\"--max_old_space_size=3072\" yarn tsc && yarn build:dev:backend:postbuild",
    "build:dev:frontend": "NODE_OPTIONS=\"--max_old_space_size=3072\" lerna run build:dev:frontend --scope='@hyperledger/cactus-example-*-frontend' --scope='@hyperledger/cacti-ledger-browser'",
    "build:dev:common": "lerna exec --stream --scope '*/*common' -- 'del-cli dist/** && tsc --project ./tsconfig.json && webpack --env=dev --target=node --config ../../webpack.config.js'",
    "build:dev:backend:postbuild": "lerna run build:dev:backend:postbuild",
    "test:cmd-api-server": "tap --ts --timeout=600 \"packages/cactus-*cmd-api-server/src/test/typescript/{unit,integration}/\"",
    "test:plugin-ledger-connector-besu": "tap --ts --jobs=1 --timeout=60 \"packages/cactus-*-besu/src/test/typescript/{unit,integration}/\"",
    "test:plugin-htlc-besu-erc20": "tap --jobs=1 --timeout=600 \"packages/*htlc-eth-besu-erc20/src/test/typescript/{unit,integration}/\"",
    "test:plugin": "tap --jobs=1 --timeout=600 \"packages/*test-plugin-htlc-eth-besu/src/test/typescript/{unit,integration}/\"",
    "test:plugin-ledger-connector-quorum": "tap --ts --jobs=1 --timeout=60 \"packages/cactus-*-quorum/src/test/typescript/{unit,integration}/\"",
    "test:cctxviz": "tap --jobs=1 --timeout=600 \"packages/cactus-plugin-cc-tx-visualization/src/test/typescript/{unit,integration}/\"",
    "test:plugin-ledger-connector-iroha": "tap --ts --jobs=1 --timeout=600 \"packages/cactus-*-iroha/src/test/typescript/{unit,integration}/\"",
    "test:plugin-htlc-besu": "tap --jobs=1 --timeout=600 \"packages/*htlc-eth-besu/src/test/typescript/{integration}/\"",
    "build:dev:plugin-consortium-manual": "lerna exec --stream --scope '*/*manual-consortium' -- 'del-cli dist/** && tsc --project ./tsconfig.json && webpack --env=dev --target=node --config ../../webpack.config.js'",
    "build:dev:plugin-cc-tx-visualization": "lerna exec --stream --scope '*/*cc-tx-visualization' -- 'del-cli dist/** && tsc --project ./tsconfig.json && webpack --env=dev --target=node --config ../../webpack.config.js'",
    "build:dev:example-supply-chain-backend": "lerna exec --stream --scope '*/*example-supply-chain-b*' -- 'del-cli dist/** && tsc --project ./tsconfig.json && webpack --display-modules --env=dev --target=node --config ../../webpack.config.js'",
    "build:dev:example-carbon-accounting-backend": "lerna exec --stream --scope '*/*carbon-accounting-b*' -- 'del-cli dist/** && tsc --project ./tsconfig.json && webpack --display-modules --env=dev --target=node --config ../../webpack.config.js' && cp -r examples/cactus-example-carbon-accounting-backend/src/utility-emissions-channel/ examples/cactus-example-carbon-accounting-backend/dist/lib/",
    "build:dev:sdk": "lerna exec --stream --scope '*/*sdk' -- 'del-cli dist/** && tsc --project ./tsconfig.json && webpack --env=dev --target=node --config ../../webpack.config.js'",
    "build:dev:plugin-ledger-connector-corda": "lerna exec --stream --scope '*/*connector-corda' -- 'del-cli dist/** && yarn tsc && webpack --env=dev --target=node --config ../../webpack.config.js'",
    "test:plugin-ledger-connector-corda": "tap --ts --jobs=1 --timeout=600 \"packages/cactus-*-corda/src/test/typescript/{unit,integration}/\"",
    "webpack": "lerna run webpack:dev",
    "webpack:dev:web": "lerna run webpack:dev:web",
    "webpack:dev:node": "lerna run webpack:dev:node",
    "test:jest:all": "NODE_OPTIONS=\"--max_old_space_size=3072 --experimental-vm-modules\" jest",
    "test:tap:all": "NODE_OPTIONS=\"--experimental-vm-modules\" tap",
    "test:all": "NODE_OPTIONS=\"--experimental-vm-modules\" yarn test:jest:all && yarn test:tap:all",
    "lerna-publish-canary": "lerna publish --canary --force-publish --dist-tag $(git branch --show-current) --preid $(git branch --show-current) --loglevel=silly --ignore-scripts --ignore-prepublish",
    "preinstall": "curl -L https://foundry.paradigm.xyz | bash",
    "prepare": "husky",
    "init-registries": "yarn config set npmScopes.iroha2.npmRegistryServer https://nexus.iroha.tech/repository/npm-group/"
  },
  "resolutions": {
    "@babel/traverse": ">=7.23.2",
    "ansi-html": ">=0.0.8",
    "axios": ">=1.8.4",
    "body-parser": ">=1.20.3",
    "braces": ">=3.0.3",
    "x-dicer": ">0.3.1",
    "elliptic": ">=6.6.1",
    "engine.io": ">=6.4.2",
    "get-func-name": "2.0.0",
    "glob-parent": ">=5.1.2",
    "x-hoek": ">6.1.3",
    "http-cache-semantics": ">=4.1.1",
    "http-proxy-middleware@2.0.6": "2.0.7",
    "http-proxy-middleware@2.0.3": "2.0.7",
    "x-ip": ">2.0.1",
    "jsonwebtoken": ">=9.0.0",
    "jsrsasign": ">=11.0.0",
    "lodash": ">=4.17.21",
    "x-minimatch": ">=3.0.5",
    "minimist": ">=1.2.6",
    "nano": ">=10.0.0",
    "node-forge": ">=1.3.0",
    "nth-check": ">=2.0.1",
    "postcss": ">=8.4.31",
    "protobufjs": ">=7.2.5",
    "semver": ">=7.5.2",
    "socket.io-parser": ">=4.2.3",
    "tough-cookie": ">=4.1.3",
    "underscore": ">=1.13.2",
    "vite": ">4.5.1",
    "webpack-dev-middleware": ">=6.1.2",
    "word-wrap": ">=1.2.5",
    "ws": ">=1.1.5",
    "xml2js": ">=0.5.0",
    "web3-eth-accounts@npm:1.6.1": "patch:web3-eth-accounts@npm%3A1.6.1#~/.yarn/patches/web3-eth-accounts-npm-1.6.1-c95f31ca81.patch",
    "zod": ">=3.22.3",
    "form-data@>=4.0.0 <4.0.4": "4.0.4",
    "form-data@>=3.0.0 <3.0.4": "3.0.4",
    "form-data@<2.5.4": "2.5.4",
    "form-data@~2.3.2": "2.5.4",
    "pbkdf2@<=3.1.2": "3.1.3",
    "sha.js@<=2.4.11": "2.4.12",
    "backslash": "0.2.0",
    "color": "3.2.1",
    "color-name": "1.1.4",
    "color-string": "1.9.0",
    "debug": "4.3.4",
    "error-ex": "1.3.2",
    "has-ansi": "2.0.0",
    "is-arrayish": "0.3.2",
    "simple-swizzle": "0.2.2",
    "slice-ansi": "3.0.0",
    "supports-color": "7.2.0",
    "supports-hyperlinks": "2.3.0",
    "request-promise-native": "1.0.9",
    "@angular/*": "17.3.11"
  },
  "devDependencies": {
    "@angular/common": "17.3.11",
    "@angular/core": "19.2.20",
    "@angular/platform-browser": "17.3.11",
    "@angular/platform-browser-dynamic": "17.3.11",
    "@angular/router": "17.3.11",
    "@arethetypeswrong/cli": "0.16.4",
    "@babel/parser": "7.24.7",
    "@babel/types": "7.24.7",
    "@bufbuild/buf": "1.30.0",
    "@bufbuild/protobuf": "1.10.0",
    "@bufbuild/protoc-gen-es": "1.8.0",
    "@commitlint/cli": "17.7.1",
    "@commitlint/config-conventional": "17.7.0",
    "@connectrpc/connect": "1.4.0",
    "@connectrpc/protoc-gen-connect-es": "1.4.0",
    "@lerna-lite/cli": "3.7.0",
    "@lerna-lite/exec": "3.7.0",
    "@lerna-lite/list": "3.7.0",
    "@lerna-lite/publish": "3.7.0",
    "@lerna-lite/run": "3.7.0",
    "@lerna-lite/version": "3.7.0",
    "@mermaid-js/mermaid-cli": "11.12.0",
    "@openapitools/openapi-generator-cli": "2.7.0",
    "@redocly/openapi-core": "1.15.0",
    "@types/adm-zip": "0.5.0",
    "@types/benchmark": "2.1.5",
    "@types/debug": "4.1.12",
    "@types/fs-extra": "11.0.4",
    "@types/jest": "29.5.3",
    "@types/madge": "5.0.3",
    "@types/node": "18.11.9",
    "@types/node-fetch": "2.6.4",
    "@types/path-browserify": "1",
    "@types/request": "2",
    "@types/tape": "4.13.4",
    "@types/tape-promise": "4.0.1",
    "@types/uuid": "10.0.0",
    "@types/yargs": "17.0.24",
    "@typescript-eslint/eslint-plugin": "7.1.0",
    "@typescript-eslint/parser": "7.1.0",
    "adm-zip": "0.5.10",
    "benchmark": "2.1.4",
    "browserify-zlib": "0.2.0",
    "buffer": "6.0.3",
    "check-dependency-version-consistency": "4.1.0",
    "cpy-cli": "4.2.0",
    "cross-env": "7.0.3",
    "crypto-browserify": "3.12.0",
    "cspell": "8.10.4",
    "debug": "4.3.5",
    "del": "7.1.0",
    "del-cli": "5.1.0",
    "depcheck": "1.4.7",
    "es-main": "1.2.0",
    "escape-string-regexp": "4.0.0",
    "eslint": "8.57.0",
    "eslint-config-prettier": "9.1.0",
    "eslint-config-standard": "17.1.0",
    "eslint-plugin-import": "2.29.1",
    "eslint-plugin-node": "11.1.0",
    "eslint-plugin-prettier": "5.1.3",
    "eslint-plugin-promise": "6.1.1",
    "eslint-plugin-standard": "5.0.0",
    "fast-safe-stringify": "2.1.1",
    "fs-extra": "11.2.0",
    "globby": "12.2.0",
    "google-protobuf": "3.21.4",
    "grpc-tools": "1.12.4",
    "grpc_tools_node_protoc_ts": "5.3.3",
    "hasown": "2.0.2",
    "husky": "9.1.7",
    "inquirer": "8.2.6",
    "jest": "29.6.2",
    "jest-extended": "4.0.1",
    "jest-junit": "16.0.0",
    "joi": "17.13.3",
    "json5": "2.2.3",
    "license-report": "6.4.0",
    "lint-staged": "11.2.6",
    "long": "5.2.3",
    "madge": "7.0.0",
    "make-dir-cli": "3.1.0",
    "node-polyfill-webpack-plugin": "1.1.4",
    "npm-run-all": "4.1.5",
    "npm-watch": "0.11.0",
    "openapi-types": "12.1.3",
    "path-browserify": "1.0.1",
    "prettier": "3.2.5",
    "protoc-gen-ts": "0.8.7",
    "puppeteer": "24.23.0",
    "replace": "1.2.2",
    "request": "2.88.2",
    "run-time-error": "1.4.0",
    "run-time-error-cjs": "1.4.0",
    "rxjs": "^7.8.2",
    "secp256k1": "5.0.1",
    "semver-parser": "4.1.4",
    "shebang-loader": "0.0.1",
    "simple-git": "3.32.3",
    "sort-package-json": "1.57.0",
    "source-map-loader": "4.0.1",
    "stream-browserify": "3.0.0",
    "stream-http": "3.2.0",
    "tap": "16.3.8",
    "tape": "5.6.6",
    "tape-promise": "4.0.0",
    "terser-webpack-plugin": "5.3.16",
    "ts-jest": "29.1.1",
    "ts-loader": "9.4.4",
    "ts-node": "10.9.2",
    "tslib": "2.6.2",
    "tsx": "4.16.2",
    "typescript": "5.5.2",
    "web3": "4.1.1",
    "web3-core": "4.1.1",
    "web3-eth": "4.1.1",
    "web3-utils": "4.3.0",
    "webpack": "5.104.1",
    "webpack-cli": "4.10.0",
    "wget-improved": "3.4.0",
    "yargs": "17.7.2",
    "zone.js": "^0.16.0"
  },
  "dependenciesMeta": {
    "@2060.io/ffi-napi": {
      "built": false
    },
    "@apollo/protobufjs": {
      "built": false
    },
    "@nestjs/core": {
      "built": false
    },
    "@openapitools/openapi-generator-cli": {
      "built": false
    },
    "@trufflesuite/bigint-buffer": {
      "built": false
    },
    "aws-sdk": {
      "built": false
    },
    "bufferutil": {
      "built": false
    },
    "cbor": {
      "built": false
    },
    "classic-level": {
      "built": false
    },
    "core-js": {
      "built": false
    },
    "cpu-features": {
      "built": false
    },
    "deasync": {
      "built": false
    },
    "es5-ext": {
      "built": false
    },
    "esbuild": {
      "built": false
    },
    "indy-sdk": {
      "built": false
    },
    "iso-constants": {
      "built": false
    },
    "keccak": {
      "built": false
    },
    "keytar": {
      "built": false
    },
    "leveldown": {
      "built": false
    },
    "nice-napi": {
      "built": false
    },
    "nodemon": {
      "built": false
    },
    "pkcs11js": {
      "built": false
    },
    "protobufjs": {
      "built": false
    },
    "secp256k1": {
      "built": false
    },
    "sqlite3": {
      "built": true
    },
    "ssh2": {
      "built": false
    },
    "truffle": {
      "built": false
    },
    "utf-8-validate": {
      "built": false
    },
    "web3": {
      "built": false
    },
    "web3-bzz": {
      "built": false
    },
    "web3-shh": {
      "built": false
    }
  },
  "packageManager": "yarn@4.3.1",
  "packageExtensions": {
    "form-data@2.5.4": {
      "dependencies": {
        "hasown": "2.0.2"
      }
    },
    "request-promise-native@*": {
      "dependencies": {
        "request": "2.88.2"
      }
    },
    "fabric-common@*": {
      "dependencies": {
        "long": "5.2.3"
      }
    },
    "ts-results@3.3.0": {
      "dependencies": {
        "tslib": "2.6.2"
      }
    }
  }
}

```


--- FILE: .github/workflows/ci.yaml ---
```
name: Cacti CI
on:
  pull_request:
    branches:
      - main
      - dev

  workflow_dispatch:
    
  schedule:
    # Run at 8:00 AM UTC on weekends (Monday and Thursday)
    - cron: "0 8 * * 1,4" 

env:
  NODEJS_VERSION: v20.20.0
  RUN_TRIVY_SCAN: true
  RUN_CODE_COVERAGE: true
  NODE_OPTIONS: --max-old-space-size=8192

jobs:
  env-setup:
    outputs:
      node_version: ${{ steps.set-node-version.outputs.node_version }}
      run_code_coverage: ${{ steps.set-run-code-coverage.outputs.run_code_coverage }}
      run_trivy_scan: ${{ steps.set-run-trivy-scan.outputs.run_trivy_scan }}
    runs-on: ubuntu-22.04
    steps:
      - name: Set Node Version Output
        id: set-node-version
        run: echo "node_version=${{ env.NODEJS_VERSION }}" >> "$GITHUB_OUTPUT"
      - name: Set Run Code Coverage Output
        id: set-run-code-coverage
        run: echo "run_code_coverage=${{ env.RUN_CODE_COVERAGE }}" >> "$GITHUB_OUTPUT"
      - name: Set Run Trivy Scan Output
        id: set-run-trivy-scan
        run: echo "run_trivy_scan=${{ env.RUN_TRIVY_SCAN }}" >> "$GITHUB_OUTPUT"
      
  checks-and-build:
    needs: [env-setup]
    uses: ./.github/workflows/checks-and-build.yaml
    with:
      node_version: ${{ needs.env-setup.outputs.node_version }}
    
  code-quality-checks:
    needs: [checks-and-build, env-setup]
    uses: ./.github/workflows/code-quality-checks.yaml
    with:
      node_version: ${{ needs.env-setup.outputs.node_version }}
      
  packages-workflow:
    needs: [checks-and-build, code-quality-checks, env-setup]
    uses: ./.github/workflows/packages-workflow.yaml
    with:
      affected-packages: ${{ needs.checks-and-build.outputs.affected_packages }}
      node_version: ${{ needs.env-setup.outputs.node_version }}
      run_code_coverage: ${{ needs.env-setup.outputs.run_code_coverage }}
      run_trivy_scan: ${{ needs.env-setup.outputs.run_trivy_scan }}

  examples-workflow:
    needs: [checks-and-build, code-quality-checks, env-setup]
    uses: ./.github/workflows/examples-workflow.yaml
    with:
      affected-packages: ${{ needs.checks-and-build.outputs.affected_packages }}
      node_version: ${{ needs.env-setup.outputs.node_version }}
      run_code_coverage: ${{ needs.env-setup.outputs.run_code_coverage }}

  ghcr-workflow:
    needs: [checks-and-build, env-setup]
    uses: ./.github/workflows/ghcr-workflow.yaml
    with:
      node_version: ${{ needs.env-setup.outputs.node_version }}
      run_trivy_scan: ${{ needs.env-setup.outputs.run_trivy_scan }}
      affected-packages: ${{ needs.checks-and-build.outputs.affected_packages }}


```


--- FILE: .github/workflows/checks-and-build.yaml ---
```

name: Early Checks and Build

# Controls when the workflow will run
on:
  # Triggers the workflow on push or pull request events but only for the main branch
  workflow_call:
    inputs:
      node_version:
        required: true
        type: string
    outputs:
      affected_packages:
        description: "Changed packages"
        value: ${{ jobs.compute-changed-packages.outputs.affected_packages }}

concurrency:
  group: checks-and-build-${{ github.workflow }}-${{ github.event.pull_request.number || github.ref }}
  cancel-in-progress: true

jobs: 
  ActionLint:
    uses: ./.github/workflows/actionlint.yaml

  DCI-Lint:
      name: DCI-Lint
      runs-on: ubuntu-22.04
      steps:
        - id: lint-git-repo
          name: Lint Git Repo
          uses: petermetz/gh-action-dci-lint@beb6ebd5c14241d27bca98e797606f20cb4b50d2 #v0.6.1
          with:
            lint-git-repo-request: >-
              {
                "cloneUrl": "${{ github.server_url }}/${{ github.repository }}.git",
                "fetchArgs": [
                  "--update-head-ok",
                  "--no-tags",
                  "--prune",
                  "--progress",
                  "--no-recurse-submodules",
                  "--depth=1",
                  "origin",
                  "+${{ github.sha }}:${{ github.ref }}"
                ],
                "checkoutArgs": [
                  "${{ github.ref }}"
                ],
                "targetPhrasePatterns": [],
                "configDefaultsUrl": "https://inclusivenaming.org/json/dci-lint-config-recommended-v1.json",
                "excludePatterns": [
                  "packages/**/generated/**"
                ]
              }
        - name: Get the output response
          run: echo "${{ steps.lint-git-repo.outputs.lint-git-repo-response }}"

  check-coverage:
    outputs:
      run-coverage: ${{ steps.set-output.outputs.run-coverage }}
    runs-on: ubuntu-22.04
    steps:
      - uses: actions/checkout@v5
      - name: Set output
        id: set-output
        run: echo "run-coverage=${{ env.RUN_CODE_COVERAGE }}" >> "$GITHUB_OUTPUT"
  
  build-dev:
    runs-on: ubuntu-22.04
    steps:
      - uses: actions/checkout@v5
      - name: build
        uses:  ./.github/actions/configure-repo/
        with:
          node_version:  ${{ inputs.node_version }}

  compute-changed-packages:
    runs-on: ubuntu-22.04
    outputs:
      affected_packages: ${{ steps.compute-affected-packages.outputs.affected_packages }}
    steps:
      - uses: actions/checkout@v5
        with:
          fetch-depth: 0
      - name: Set up Node.js
        uses: actions/setup-node@6044e13b5dc448c55e2357c09f80417699197238 #v6.2.0
        with:
          node-version: ${{ inputs.node_version }}
      - id: compute-affected-packages
        name: Compute Affected Packages
        run: |
          node ./tools/compute-affected-packages.cjs origin/${{ github.base_ref }} ${{ github.event_name != 'pull_request'}} > affected-packages.json
          AFFECTED_PACKAGES=$(jq -c '.' affected-packages.json)
          echo "affected_packages=$AFFECTED_PACKAGES" >> "$GITHUB_OUTPUT"
    
```


--- FILE: tools/ci.sh ---
```
#!/usr/bin/env bash

###
### Continous Integration Shell Script
###
### Designed to be re-entrant on a local dev machine as well, not just on a
### newly pulled up VM.
###
echo $BASH_VERSION

STARTED_AT=`date +%s`
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_ROOT_DIR="$SCRIPT_DIR/.."
CHANGED_FILES="$(git diff-index --name-only HEAD --)"

function checkWorkTreeStatus()
{
  git update-index -q --refresh
  new_changed_files="$(git diff-index --name-only HEAD --)"
  if [ "${CHANGED_FILES}" != "${new_changed_files}" ]; then
    echo >&2 "Changes in the git index have been detected!"
    git diff
    exit 1
  fi
}

function dumpDiskUsageInfo()
{

  if ! [ -x "$(command -v df)" ]; then
    echo 'df is not installed, skipping...'
  else
    df || true
  fi
  if ! [ -x "$(command -v docker)" ]; then
    echo 'docker is not installed, skipping...'
  else
    docker system df || true
  fi
}

function checkOnlyDocumentation()
{
  z=0

  for i in $CHANGED_FILES; do
    z=$((z+1))
    if [ ${i: -3} != ".md" ]; then
      break
    elif [ ${i: -3} == ".md" ] && [ $(echo ${CHANGED_FILES} | wc -l) == $z ]; then
      echo 'There are only changes in the documentation files.'
      ENDED_AT=`date +%s`
      runtime=$((ENDED_AT-STARTED_AT))
      echo "$(date +%FT%T%z) [CI] SUCCESS - runtime=$runtime seconds."
      exit 0
    fi
  done
}

function freeUpGitHubRunnerDiskSpace() {
  # If we are running in a GitHub Actions runner, then free up 30 GB space by
  # removing things we do not need such as the Android SDK and .NET.
  #
  # Huge thanks to Maxim Lobanov for the advice:
  # https://github.com/actions/virtual-environments/issues/2606#issuecomment-772683150
  #
  # Why do this? Because we've been getting warnings about the runners being
  # left with less than a hundred megabytes of disk space during the tests.
  #
  # This operation takes about 2 minutes to do and so is disabled by default to get better
  # performance from the CI by default. It can be enabled on a per job basis via
  # the env variables defined in the action's .yaml files.
  #
  if [ "${FREE_UP_GITHUB_RUNNER_DISK_SPACE_DISABLED:-true}" = "true" ]; then
    echo "$(date +%FT%T%z) [CI] Freeing up GitHub Action Runner disk space disabled. Skipping..."
  else
    echo "$(date +%FT%T%z) [CI] Freeing up GitHub Action Runner disk space by deleting Android and .NET ..."
    sudo rm -rf /usr/local/lib/android # will release about 10 GB if you don't need Android
    sudo rm -rf /usr/share/dotnet # will release about 20GB if you don't need .NET
  fi
}

function mainTask()
{
  set -euxo pipefail

  if ! [ -x "$(command -v lscpu)" ]; then
    echo 'lscpu is not installed, skipping...'
  else
    lscpu || true
  fi

  if ! [ -x "$(command -v lsmem)" ]; then
    echo 'lsmem is not installed, skipping...'
  else
    lsmem || true
  fi

  if ! [ -x "$(command -v smem)" ]; then
    echo 'smem is not installed, skipping...'
  else
    smem --abbreviate --totals --system || true
  fi

  # Check if the modified files are only for documentation.
  checkOnlyDocumentation

  # Can be turned ON/OFF via env var FREE_UP_GITHUB_RUNNER_DISK_SPACE_DISABLED=true/false
  freeUpGitHubRunnerDiskSpace

  if [ "${DUMP_DISK_USAGE_INFO_DISABLED:-true}" = "true" ]; then
    echo "$(date +%FT%T%z) [CI] dumpDiskUsageInfo disabled. Skipping..."
  else
    dumpDiskUsageInfo
  fi

  docker --version
  docker compose version
  node --version
  npm --version
  java -version
  yarn --version

  export NODE_OPTIONS=--max_old_space_size=5120

  ### COMMON
  cd $PROJECT_ROOT_DIR

  if [ "${CONFIGURE_DISABLED:-false}" = "true" ]; then
    echo "$(date +%FT%T%z) [CI] npm run configure disabled. Skipping..."
  else
    npm run configure
  fi

  if [ "${TOOLS_VALIDATE_BUNDLE_NAMES_DISABLED:-true}" = "true" ]; then
    echo "$(date +%FT%T%z) [CI] yarn tools:validate-bundle-names disabled. Skipping..."
  else
    yarn tools:validate-bundle-names
  fi

  if [ "${CUSTOM_CHECKS_DISABLED:-true}" = "true" ]; then
    echo "$(date +%FT%T%z) [CI] yarn custom-checks disabled. Skipping..."
  else
    yarn custom-checks
  fi

  if [ "${JEST_TEST_RUNNER_DISABLED:-false}" = "true" ]; then
    echo "$(date +%FT%T%z) [CI] Jest test runner disabled. Skipping..."
  elif [ "${JEST_TEST_CODE_COVERAGE_ENABLED:-true}" = "true" ]; then
   yarn jest $JEST_TEST_PATTERN --coverage --coverageDirectory=$JEST_TEST_COVERAGE_PATH
  else
    yarn test:jest:all $JEST_TEST_PATTERN
  fi

  if [ "${DUMP_DISK_USAGE_INFO_DISABLED:-true}" = "true" ]; then
    echo "$(date +%FT%T%z) [CI] dumpDiskUsageInfo disabled. Skipping..."
  else
    dumpDiskUsageInfo
  fi

  if [ "${TAPE_TEST_RUNNER_DISABLED:-false}" = "true" ]; then
    echo "$(date +%FT%T%z) [CI] Tape test runner disabled. Skipping..."
  else
    yarn test:tap:all --bail $TAPE_TEST_PATTERN
  fi

  if [ "${DUMP_DISK_USAGE_INFO_DISABLED:-true}" = "true" ]; then
    echo "$(date +%FT%T%z) [CI] dumpDiskUsageInfo disabled. Skipping..."
  else
    dumpDiskUsageInfo
  fi

  # We run the full build last because the tests don't need it so in the interest
  # of providing feedback about failing tests as early as possible we run the
  # dev:backend build first and then the tests which is the fastest way to get
  # to a failed test if there was one.
  if [ "${FULL_BUILD_DISABLED:-true}" = "true" ]; then
    echo "$(date +%FT%T%z) [CI] Full build disabled. Skipping..."
  else
    yarn run build
  fi

  if [ "${CHECK_WORK_TREE_STATUS_DISABLED:-true}" = "true" ]; then
    echo "$(date +%FT%T%z) [CI] checkWorkTreeStatus disabled. Skipping..."
  else
    checkWorkTreeStatus
  fi

  ENDED_AT=`date +%s`
  runtime=$((ENDED_AT-STARTED_AT))
  echo "$(date +%FT%T%z) [CI] SUCCESS - runtime=$runtime seconds."
  exit 0
}

function onTaskFailure()
{
  set +eu # do not crash process upon individual command failures

  ENDED_AT=`date +%s`
  runtime=$((ENDED_AT-STARTED_AT))
  echo "$(date +%FT%T%z) [CI] FAILURE - runtime=$runtime seconds."
  exit 1
}

(
  mainTask
)
if [ $? -ne 0 ]; then
  onTaskFailure
fi

```


--- FILE: .github/workflows/code-quality-checks.yaml ---
```
name: Code Quality Checks
# Controls when the workflow will run
on:
  # Triggers the workflow on push or pull request events but only for the main branch
  workflow_call:
    inputs:
      node_version:
        required: true
        type: string
  
concurrency:
  group: code-quality-checks-${{ github.workflow }}-${{ github.event.pull_request.number || github.ref }}
  cancel-in-progress: true

jobs:
  yarn_lint:
    runs-on: ubuntu-22.04
    steps:
      - uses: actions/checkout@v5
      
      - name: build
        with:
          node_version:  ${{ inputs.node_version }}
          configure_desable: 'true'
          yarn_hardened_mode: '0'     
        uses: ./.github/actions/configure-repo/

      - run: git status --porcelain
      - run: git status --porcelain | wc -l
      - run: yarn lint
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
        uses: actions/github-script@60a0d83039c74a4aee543508d2ffcb1c3799cdea #v7.0.1
        with:
          script: |
            const failMsg = "yarn lint script produced version control " +
              "side-effects: source files have been changed by it that are " +
              "otherwise are under version control. " +
              "This means (99% of the time) that you need to run the " +
              "yarn lint script locally and then include the changes it " +
              "makes in your own commit when submitting your pull request.";
            core.setFailed(failMsg)

  yarn_codegen:
    continue-on-error: false
    runs-on: ubuntu-22.04
    steps:
      - uses: actions/checkout@v5

      - name: CI environment clean-up
        run: ./tools/ci-env-clean-up.sh

      - name: Install Foundry
        uses: foundry-rs/foundry-toolchain@v1
        with:
          version: stable

      - name: build
        with:
          node_version:  ${{ inputs.node_version }}
          configure_desable: 'true'
          yarn_hardened_mode: '0'     
        uses: ./.github/actions/configure-repo/

      - run: git status --porcelain
      - run: git status --porcelain | wc -l

      - name: Cache OpenAPI Generator JAR
        id: cache-openapi-generator-jar
        uses: actions/cache@v4
        with:
          path: |
            node_modules/@openapitools/openapi-generator-cli/versions/6.6.0.jar
          key: openapi-generator-cli-${{ runner.os }}-6.6.0
          restore-keys: |
            openapi-generator-cli-${{ runner.os }}-

      # grpc-tools@1.12.4 ships a node-pre-gyp-downloaded native binary
      # (bin/protoc) that is absent or incompatible on Ubuntu 22.04 + Node 20,
      # causing ENOENT when yarn codegen runs the proto generation step in
      # @hyperledger/cactus-core-api. The package.json script calls system
      # protoc directly (instead of grpc_tools_node_protoc) so we must ensure
      # it is available on PATH before codegen runs.
      - name: Install protoc
        run: |
          sudo apt-get update -y
          sudo apt-get install -y protobuf-compiler
          protoc --version

      - name: Run codegen
        run: yarn codegen
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

      - name: Check CodeGen Side-effects
        if: ${{ steps.set-result-git_index_file_count.outputs.result != 0 }}
        uses: actions/github-script@60a0d83039c74a4aee543508d2ffcb1c3799cdea #v7.0.1
        with:
          script: |
            const failMsg = "yarn codegen script produced version control " +
              "side-effects: source files have been changed by it that are " +
              "otherwise are under version control. " +
              "This means (99% of the time) that you need to run the " +
              "yarn codegen script locally and then include the changes it " +
              "makes in your own commit when submitting your pull request.";
            core.setFailed(failMsg)

  yarn_custom_checks:
    continue-on-error: false
    env:
      CACTI_CUSTOM_CHECKS_REQUIRED_OPENAPI_SPEC_VERSION: 3.0.3
    runs-on: ubuntu-22.04
    steps:
      - uses: actions/checkout@v5

      - name: build
        with:
          node_version:  ${{ inputs.node_version }}
          yarn_hardened_mode: '0'     
        uses: ./.github/actions/configure-repo/

      - name: Run Custom Checks
        run: yarn custom-checks

  yarn_tools_validate_bundle_names:
    continue-on-error: true
    runs-on: ubuntu-22.04
    steps:
      - uses: actions/checkout@v5

      - name: build
        with:
          node_version:  ${{ inputs.node_version }}
          configure_desable: 'true'
          yarn_hardened_mode: '0'    
        uses: ./.github/actions/configure-repo/
      
      - name: Run Bundle Names Validation
        run: yarn tools:validate-bundle-names
      
```
