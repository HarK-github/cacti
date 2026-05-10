 # Documentation Deep Dive - Batch Commands

Based on your directory structure, I've organized all documentation-related files into **4 batches**. Each batch will output all files into a single file with clear separators.

## Batch 1: Core Documentation & MkDocs Structure

```bash
#!/bin/bash
# Batch 1: Core docs and MkDocs structure
OUTPUT_FILE="batch1_docs_core.txt"

{
echo "========== FILE: docs/README.md =========="
cat docs/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/index.md =========="
cat docs/docs/index.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/architecture.md =========="
cat docs/docs/architecture.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/vision.md =========="
cat docs/docs/vision.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/README.md =========="
cat docs/docs/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/cactus/introduction.md =========="
cat docs/docs/cactus/introduction.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/cactus/architecture.md =========="
cat docs/docs/cactus/architecture.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/weaver/introduction.md =========="
cat docs/docs/weaver/introduction.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/contributing/README.md =========="
cat docs/docs/contributing/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/guides/getting-started.md =========="
cat docs/docs/guides/getting-started.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: BUILD.md =========="
cat BUILD.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: FAQ.md =========="
cat FAQ.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: GOVERNANCE.md =========="
cat GOVERNANCE.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: MAINTAINERS.md =========="
cat MAINTAINERS.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: RELEASE_MANAGEMENT.md =========="
cat RELEASE_MANAGEMENT.md 2>/dev/null || echo "[FILE NOT FOUND]"

} > "$OUTPUT_FILE"

echo "Batch 1 complete: $OUTPUT_FILE"
```

## Batch 2: Weaver Documentation (RFCs and Architecture)

```bash
#!/bin/bash
# Batch 2: Weaver RFCs and architecture docs
OUTPUT_FILE="batch2_weaver_docs.txt"

{
echo "========== FILE: weaver/OVERVIEW.md =========="
cat weaver/OVERVIEW.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/README.md =========="
cat weaver/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/SECURITY.md =========="
cat weaver/SECURITY.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/README.md =========="
cat weaver/rfcs/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/terminology.md =========="
cat weaver/rfcs/terminology.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/models/README.md =========="
cat weaver/rfcs/models/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/models/infrastructure/relays.md =========="
cat weaver/rfcs/models/infrastructure/relays.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/models/infrastructure/interoperation-modules.md =========="
cat weaver/rfcs/models/infrastructure/interoperation-modules.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/protocols/README.md =========="
cat weaver/rfcs/protocols/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/protocols/data-sharing/generic.md =========="
cat weaver/rfcs/protocols/data-sharing/generic.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/protocols/asset-exchange/generic-htlc.md =========="
cat weaver/rfcs/protocols/asset-exchange/generic-htlc.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/protocols/asset-transfer/generic.md =========="
cat weaver/rfcs/protocols/asset-transfer/generic.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/formats/README.md =========="
cat weaver/rfcs/formats/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/formats/views/definition.md =========="
cat weaver/rfcs/formats/views/definition.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/core/README.md =========="
cat weaver/core/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/core/relay/README.md =========="
cat weaver/core/relay/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/core/relay/architecture.md =========="
cat weaver/core/relay/architecture.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/core/relay/relay-config.md =========="
cat weaver/core/relay/relay-config.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/core/drivers/README.md =========="
cat weaver/core/drivers/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/core/drivers/fabric-driver/readme.md =========="
cat weaver/core/drivers/fabric-driver/readme.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/samples/README.md =========="
cat weaver/samples/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/sdks/README.md =========="
cat weaver/sdks/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/tests/README.md =========="
cat weaver/tests/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

} > "$OUTPUT_FILE"

echo "Batch 2 complete: $OUTPUT_FILE"
```

## Batch 3: Examples, Demos, and Tutorials Documentation

```bash
#!/bin/bash
# Batch 3: Examples and demos documentation
OUTPUT_FILE="batch3_examples_docs.txt"

{
echo "========== FILE: examples/README.md =========="
cat examples/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: examples/cactus-example-supply-chain-backend/README.md =========="
cat examples/cactus-example-supply-chain-backend/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: examples/cactus-example-discounted-asset-trade/README.md =========="
cat examples/cactus-example-discounted-asset-trade/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: examples/cactus-example-electricity-trade/README.md =========="
cat examples/cactus-example-electricity-trade/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: examples/cactus-example-cbdc-bridging/README.md =========="
cat examples/cactus-example-cbdc-bridging/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: examples/cactus-example-cbdc-bridging-frontend/README.md =========="
cat examples/cactus-example-cbdc-bridging-frontend/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: examples/cactus-example-carbon-accounting-backend/README.md =========="
cat examples/cactus-example-carbon-accounting-backend/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: examples/cactus-example-carbon-accounting-frontend/README.md =========="
cat examples/cactus-example-carbon-accounting-frontend/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: examples/carbon-accounting/README.md =========="
cat examples/carbon-accounting/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/README.md =========="
cat cacti-demos/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/README.md =========="
cat cacti-demos/gateway/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/satp/case_1/README.md =========="
cat cacti-demos/gateway/satp/case_1/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/satp/case_2/README.md =========="
cat cacti-demos/gateway/satp/case_2/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/satp/case_3/README.md =========="
cat cacti-demos/gateway/satp/case_3/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/oracle/case_1/README.md =========="
cat cacti-demos/gateway/oracle/case_1/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/oracle/case_2/README.md =========="
cat cacti-demos/gateway/oracle/case_2/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/oracle/case_3/README.md =========="
cat cacti-demos/gateway/oracle/case_3/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/oracle/case_4/README.md =========="
cat cacti-demos/gateway/oracle/case_4/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/oracle/case_5/README.md =========="
cat cacti-demos/gateway/oracle/case_5/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/oracle/case_6/README.md =========="
cat cacti-demos/gateway/oracle/case_6/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/oracle/case_7/README.md =========="
cat cacti-demos/gateway/oracle/case_7/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/extensions/carbon-credit/README.md =========="
cat cacti-demos/gateway/extensions/carbon-credit/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: whitepaper/whitepaper.md =========="
cat whitepaper/whitepaper.md 2>/dev/null || echo "[FILE NOT FOUND]"

} > "$OUTPUT_FILE"

echo "Batch 3 complete: $OUTPUT_FILE"
```

## Batch 4: Package Documentation (Plugin READMEs)

```bash
#!/bin/bash
# Batch 4: Package-level documentation
OUTPUT_FILE="batch4_packages_docs.txt"

{
echo "========== FILE: packages/README.md =========="
cat packages/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-satp-hermes/README.md =========="
cat packages/cactus-plugin-satp-hermes/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-satp-hermes/ARCHITECTURE.md =========="
cat packages/cactus-plugin-satp-hermes/ARCHITECTURE.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-satp-hermes/CONTRIBUTING.md =========="
cat packages/cactus-plugin-satp-hermes/CONTRIBUTING.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-ledger-connector-fabric/README.md =========="
cat packages/cactus-plugin-ledger-connector-fabric/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-ledger-connector-besu/README.md =========="
cat packages/cactus-plugin-ledger-connector-besu/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-ledger-connector-corda/README.md =========="
cat packages/cactus-plugin-ledger-connector-corda/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-ledger-connector-ethereum/README.md =========="
cat packages/cactus-plugin-ledger-connector-ethereum/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-ledger-connector-iroha2/README.md =========="
cat packages/cactus-plugin-ledger-connector-iroha2/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-ledger-connector-polkadot/README.md =========="
cat packages/cactus-plugin-ledger-connector-polkadot/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-ledger-connector-sawtooth/README.md =========="
cat packages/cactus-plugin-ledger-connector-sawtooth/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-ledger-connector-stellar/README.md =========="
cat packages/cactus-plugin-ledger-connector-stellar/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-keychain-aws-sm/README.md =========="
cat packages/cactus-plugin-keychain-aws-sm/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-keychain-azure-kv/README.md =========="
cat packages/cactus-plugin-keychain-azure-kv/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-keychain-google-sm/README.md =========="
cat packages/cactus-plugin-keychain-google-sm/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-keychain-memory/README.md =========="
cat packages/cactus-plugin-keychain-memory/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-keychain-vault/README.md =========="
cat packages/cactus-plugin-keychain-vault/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-consortium-manual/README.md =========="
cat packages/cactus-plugin-consortium-manual/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-htlc-eth-besu/README.md =========="
cat packages/cactus-plugin-htlc-eth-besu/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-persistence-ethereum/README.md =========="
cat packages/cactus-plugin-persistence-ethereum/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-persistence-fabric/README.md =========="
cat packages/cactus-plugin-persistence-fabric/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-cmd-api-server/README.md =========="
cat packages/cactus-cmd-api-server/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-api-client/README.md =========="
cat packages/cactus-api-client/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-common/README.md =========="
cat packages/cactus-common/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-core/README.md =========="
cat packages/cactus-core/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cacti-ledger-browser/README.md =========="
cat packages/cacti-ledger-browser/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cacti-plugin-weaver-driver-fabric/readme.md =========="
cat packages/cacti-plugin-weaver-driver-fabric/readme.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: extensions/cactus-plugin-htlc-coordinator-besu/README.md =========="
cat extensions/cactus-plugin-htlc-coordinator-besu/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: extensions/cactus-plugin-object-store-ipfs/README.md =========="
cat extensions/cactus-plugin-object-store-ipfs/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

} > "$OUTPUT_FILE"

echo "Batch 4 complete: $OUTPUT_FILE"
```

## Batch 5: Issue Templates, CI/CD, and Contributing Guides

```bash
#!/bin/bash
# Batch 5: Issue templates, CI/CD, and developer resources
OUTPUT_FILE="batch5_developer_resources.txt"

{
echo "========== FILE: .github/ISSUE_TEMPLATE/bug_report.md =========="
cat .github/ISSUE_TEMPLATE/bug_report.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: .github/ISSUE_TEMPLATE/feature_request.md =========="
cat .github/ISSUE_TEMPLATE/feature_request.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: .github/ISSUE_TEMPLATE/config.yml =========="
cat .github/ISSUE_TEMPLATE/config.yml 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: .github/workflows/ci.yaml =========="
cat .github/workflows/ci.yaml 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: .github/workflows/test_data-sharing.yml =========="
cat .github/workflows/test_data-sharing.yml 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: .github/workflows/test_asset-transfer.yml =========="
cat .github/workflows/test_asset-transfer.yml 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: .github/workflows/test_asset-exchange-fabric.yml =========="
cat .github/workflows/test_asset-exchange-fabric.yml 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: .github/workflows/test_asset-exchange-corda.yml =========="
cat .github/workflows/test_asset-exchange-corda.yml 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: .github/workflows/test_asset-exchange-besu.yml =========="
cat .github/workflows/test_asset-exchange-besu.yml 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: tools/ci.sh =========="
cat tools/ci.sh 2>/dev/null | head -100 || echo "[FILE NOT FOUND or too large, showing first 100 lines]"

echo -e "\n\n========== FILE: docs/docs/contributing/code-of-conduct.md =========="
cat docs/docs/contributing/code-of-conduct.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/contributing/style-guide.md =========="
cat docs/docs/contributing/style-guide.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/contributing/pull-requests.md =========="
cat docs/docs/contributing/pull-requests.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/cactus/ledger-browser/developer-guide/README.md =========="
cat docs/docs/cactus/ledger-browser/developer-guide/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/weaver/getting-started/guide.md =========="
cat docs/docs/weaver/getting-started/guide.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/weaver/architecture-and-design/README.md =========="
cat docs/docs/weaver/architecture-and-design/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/weaver/user-stories/global-trade.md =========="
cat docs/docs/weaver/user-stories/global-trade.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/weaver/user-stories/financial-markets.md =========="
cat docs/docs/weaver/user-stories/financial-markets.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/concepts/README.md =========="
cat docs/docs/concepts/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: some_example_repos/cacti_onboarding_research/00_synthesis.md =========="
cat some_example_repos/cacti_onboarding_research/00_synthesis.md 2>/dev/null || echo "[FILE NOT FOUND]"

} > "$OUTPUT_FILE"

echo "Batch 5 complete: $OUTPUT_FILE"
```

## Master Script to Run All Batches

```bash
#!/bin/bash
# master_docs_extract.sh - Run all documentation extraction batches

echo "Starting Hyperledger Cacti Documentation Extraction..."
echo "========================================================"

# Create output directory
mkdir -p docs_extraction_output

# Run each batch
echo "Running Batch 1: Core Documentation..."
bash batch1_docs_core.sh
mv batch1_docs_core.txt docs_extraction_output/

echo "Running Batch 2: Weaver Documentation..."
bash batch2_weaver_docs.sh
mv batch2_weaver_docs.txt docs_extraction_output/

echo "Running Batch 3: Examples and Demos..."
bash batch3_examples_docs.sh
mv batch3_examples_docs.txt docs_extraction_output/

echo "Running Batch 4: Package Documentation..."
bash batch4_packages_docs.sh
mv batch4_packages_docs.txt docs_extraction_output/

echo "Running Batch 5: Developer Resources..."
bash batch5_developer_resources.sh
mv batch5_developer_resources.txt docs_extraction_output/

echo "========================================================"
echo "Extraction complete! All files saved to docs_extraction_output/"
ls -lh docs_extraction_output/

# Optional: Combine all files for easier analysis
echo "Creating combined summary..."
cat docs_extraction_output/*.txt > docs_extraction_output/ALL_DOCS_COMBINED.txt
echo "Combined file created: docs_extraction_output/ALL_DOCS_COMBINED.txt"
```

## How to Use These Scripts

1. **Save each batch** as a separate `.sh` file (e.g., `batch1_docs_core.sh`, `batch2_weaver_docs.sh`, etc.)
2. **Make them executable**:
   ```bash
   chmod +x batch*.sh master_docs_extract.sh
   ```
3. **Run the master script** from the Cacti repository root:
   ```bash
   ./master_docs_extract.sh
   ```
4. **Review outputs** in the `docs_extraction_output/` directory

## Expected Analysis Areas After Extraction

Once you have these outputs, you can analyze:

### For Documentation Restructuring
- Identify duplicate content between `README.md`, `README-cactus.md`, and `weaver/README.md`
- Find broken links (look for `github.com/hyperledger/cactus`, not `cacti`)
- Discover missing cross-references between Cactus and Weaver docs

### For Onboarding Guides
- Evaluate if `docs/docs/guides/getting-started.md` exists and is complete
- Check if examples have clear prerequisites
- Identify gaps in tutorial sequence

### For Architecture Documentation
- Verify if `docs/docs/architecture.md` accurately reflects the merged system
- Check if Weaver RFCs are referenced from main documentation

### For CI/CD Improvements
- Analyze workflow runtime and parallelization opportunities
- Identify duplicate test jobs across different workflows

After running these commands, let me know which files were found vs missing, and I'll help you analyze the documentation gaps for your mentorship proposal!# Documentation Deep Dive - Batch Commands

Based on your directory structure, I've organized all documentation-related files into **4 batches**. Each batch will output all files into a single file with clear separators.

## Batch 1: Core Documentation & MkDocs Structure

```bash
#!/bin/bash
# Batch 1: Core docs and MkDocs structure
OUTPUT_FILE="batch1_docs_core.txt"

{
echo "========== FILE: docs/README.md =========="
cat docs/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/index.md =========="
cat docs/docs/index.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/architecture.md =========="
cat docs/docs/architecture.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/vision.md =========="
cat docs/docs/vision.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/README.md =========="
cat docs/docs/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/cactus/introduction.md =========="
cat docs/docs/cactus/introduction.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/cactus/architecture.md =========="
cat docs/docs/cactus/architecture.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/weaver/introduction.md =========="
cat docs/docs/weaver/introduction.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/contributing/README.md =========="
cat docs/docs/contributing/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/guides/getting-started.md =========="
cat docs/docs/guides/getting-started.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: BUILD.md =========="
cat BUILD.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: FAQ.md =========="
cat FAQ.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: GOVERNANCE.md =========="
cat GOVERNANCE.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: MAINTAINERS.md =========="
cat MAINTAINERS.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: RELEASE_MANAGEMENT.md =========="
cat RELEASE_MANAGEMENT.md 2>/dev/null || echo "[FILE NOT FOUND]"

} > "$OUTPUT_FILE"

echo "Batch 1 complete: $OUTPUT_FILE"
```

## Batch 2: Weaver Documentation (RFCs and Architecture)

```bash
#!/bin/bash
# Batch 2: Weaver RFCs and architecture docs
OUTPUT_FILE="batch2_weaver_docs.txt"

{
echo "========== FILE: weaver/OVERVIEW.md =========="
cat weaver/OVERVIEW.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/README.md =========="
cat weaver/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/SECURITY.md =========="
cat weaver/SECURITY.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/README.md =========="
cat weaver/rfcs/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/terminology.md =========="
cat weaver/rfcs/terminology.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/models/README.md =========="
cat weaver/rfcs/models/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/models/infrastructure/relays.md =========="
cat weaver/rfcs/models/infrastructure/relays.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/models/infrastructure/interoperation-modules.md =========="
cat weaver/rfcs/models/infrastructure/interoperation-modules.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/protocols/README.md =========="
cat weaver/rfcs/protocols/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/protocols/data-sharing/generic.md =========="
cat weaver/rfcs/protocols/data-sharing/generic.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/protocols/asset-exchange/generic-htlc.md =========="
cat weaver/rfcs/protocols/asset-exchange/generic-htlc.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/protocols/asset-transfer/generic.md =========="
cat weaver/rfcs/protocols/asset-transfer/generic.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/formats/README.md =========="
cat weaver/rfcs/formats/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/formats/views/definition.md =========="
cat weaver/rfcs/formats/views/definition.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/core/README.md =========="
cat weaver/core/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/core/relay/README.md =========="
cat weaver/core/relay/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/core/relay/architecture.md =========="
cat weaver/core/relay/architecture.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/core/relay/relay-config.md =========="
cat weaver/core/relay/relay-config.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/core/drivers/README.md =========="
cat weaver/core/drivers/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/core/drivers/fabric-driver/readme.md =========="
cat weaver/core/drivers/fabric-driver/readme.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/samples/README.md =========="
cat weaver/samples/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/sdks/README.md =========="
cat weaver/sdks/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/tests/README.md =========="
cat weaver/tests/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

} > "$OUTPUT_FILE"

echo "Batch 2 complete: $OUTPUT_FILE"
```

## Batch 3: Examples, Demos, and Tutorials Documentation

```bash
#!/bin/bash
# Batch 3: Examples and demos documentation
OUTPUT_FILE="batch3_examples_docs.txt"

{
echo "========== FILE: examples/README.md =========="
cat examples/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: examples/cactus-example-supply-chain-backend/README.md =========="
cat examples/cactus-example-supply-chain-backend/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: examples/cactus-example-discounted-asset-trade/README.md =========="
cat examples/cactus-example-discounted-asset-trade/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: examples/cactus-example-electricity-trade/README.md =========="
cat examples/cactus-example-electricity-trade/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: examples/cactus-example-cbdc-bridging/README.md =========="
cat examples/cactus-example-cbdc-bridging/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: examples/cactus-example-cbdc-bridging-frontend/README.md =========="
cat examples/cactus-example-cbdc-bridging-frontend/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: examples/cactus-example-carbon-accounting-backend/README.md =========="
cat examples/cactus-example-carbon-accounting-backend/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: examples/cactus-example-carbon-accounting-frontend/README.md =========="
cat examples/cactus-example-carbon-accounting-frontend/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: examples/carbon-accounting/README.md =========="
cat examples/carbon-accounting/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/README.md =========="
cat cacti-demos/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/README.md =========="
cat cacti-demos/gateway/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/satp/case_1/README.md =========="
cat cacti-demos/gateway/satp/case_1/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/satp/case_2/README.md =========="
cat cacti-demos/gateway/satp/case_2/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/satp/case_3/README.md =========="
cat cacti-demos/gateway/satp/case_3/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/oracle/case_1/README.md =========="
cat cacti-demos/gateway/oracle/case_1/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/oracle/case_2/README.md =========="
cat cacti-demos/gateway/oracle/case_2/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/oracle/case_3/README.md =========="
cat cacti-demos/gateway/oracle/case_3/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/oracle/case_4/README.md =========="
cat cacti-demos/gateway/oracle/case_4/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/oracle/case_5/README.md =========="
cat cacti-demos/gateway/oracle/case_5/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/oracle/case_6/README.md =========="
cat cacti-demos/gateway/oracle/case_6/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/oracle/case_7/README.md =========="
cat cacti-demos/gateway/oracle/case_7/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/extensions/carbon-credit/README.md =========="
cat cacti-demos/gateway/extensions/carbon-credit/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: whitepaper/whitepaper.md =========="
cat whitepaper/whitepaper.md 2>/dev/null || echo "[FILE NOT FOUND]"

} > "$OUTPUT_FILE"

echo "Batch 3 complete: $OUTPUT_FILE"
```

## Batch 4: Package Documentation (Plugin READMEs)

```bash
#!/bin/bash
# Batch 4: Package-level documentation
OUTPUT_FILE="batch4_packages_docs.txt"

{
echo "========== FILE: packages/README.md =========="
cat packages/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-satp-hermes/README.md =========="
cat packages/cactus-plugin-satp-hermes/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-satp-hermes/ARCHITECTURE.md =========="
cat packages/cactus-plugin-satp-hermes/ARCHITECTURE.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-satp-hermes/CONTRIBUTING.md =========="
cat packages/cactus-plugin-satp-hermes/CONTRIBUTING.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-ledger-connector-fabric/README.md =========="
cat packages/cactus-plugin-ledger-connector-fabric/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-ledger-connector-besu/README.md =========="
cat packages/cactus-plugin-ledger-connector-besu/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-ledger-connector-corda/README.md =========="
cat packages/cactus-plugin-ledger-connector-corda/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-ledger-connector-ethereum/README.md =========="
cat packages/cactus-plugin-ledger-connector-ethereum/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-ledger-connector-iroha2/README.md =========="
cat packages/cactus-plugin-ledger-connector-iroha2/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-ledger-connector-polkadot/README.md =========="
cat packages/cactus-plugin-ledger-connector-polkadot/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-ledger-connector-sawtooth/README.md =========="
cat packages/cactus-plugin-ledger-connector-sawtooth/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-ledger-connector-stellar/README.md =========="
cat packages/cactus-plugin-ledger-connector-stellar/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-keychain-aws-sm/README.md =========="
cat packages/cactus-plugin-keychain-aws-sm/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-keychain-azure-kv/README.md =========="
cat packages/cactus-plugin-keychain-azure-kv/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-keychain-google-sm/README.md =========="
cat packages/cactus-plugin-keychain-google-sm/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-keychain-memory/README.md =========="
cat packages/cactus-plugin-keychain-memory/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-keychain-vault/README.md =========="
cat packages/cactus-plugin-keychain-vault/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-consortium-manual/README.md =========="
cat packages/cactus-plugin-consortium-manual/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-htlc-eth-besu/README.md =========="
cat packages/cactus-plugin-htlc-eth-besu/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-persistence-ethereum/README.md =========="
cat packages/cactus-plugin-persistence-ethereum/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-persistence-fabric/README.md =========="
cat packages/cactus-plugin-persistence-fabric/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-cmd-api-server/README.md =========="
cat packages/cactus-cmd-api-server/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-api-client/README.md =========="
cat packages/cactus-api-client/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-common/README.md =========="
cat packages/cactus-common/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-core/README.md =========="
cat packages/cactus-core/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cacti-ledger-browser/README.md =========="
cat packages/cacti-ledger-browser/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cacti-plugin-weaver-driver-fabric/readme.md =========="
cat packages/cacti-plugin-weaver-driver-fabric/readme.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: extensions/cactus-plugin-htlc-coordinator-besu/README.md =========="
cat extensions/cactus-plugin-htlc-coordinator-besu/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: extensions/cactus-plugin-object-store-ipfs/README.md =========="
cat extensions/cactus-plugin-object-store-ipfs/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

} > "$OUTPUT_FILE"

echo "Batch 4 complete: $OUTPUT_FILE"
```

## Batch 5: Issue Templates, CI/CD, and Contributing Guides

```bash
#!/bin/bash
# Batch 5: Issue templates, CI/CD, and developer resources
OUTPUT_FILE="batch5_developer_resources.txt"

{
echo "========== FILE: .github/ISSUE_TEMPLATE/bug_report.md =========="
cat .github/ISSUE_TEMPLATE/bug_report.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: .github/ISSUE_TEMPLATE/feature_request.md =========="
cat .github/ISSUE_TEMPLATE/feature_request.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: .github/ISSUE_TEMPLATE/config.yml =========="
cat .github/ISSUE_TEMPLATE/config.yml 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: .github/workflows/ci.yaml =========="
cat .github/workflows/ci.yaml 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: .github/workflows/test_data-sharing.yml =========="
cat .github/workflows/test_data-sharing.yml 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: .github/workflows/test_asset-transfer.yml =========="
cat .github/workflows/test_asset-transfer.yml 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: .github/workflows/test_asset-exchange-fabric.yml =========="
cat .github/workflows/test_asset-exchange-fabric.yml 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: .github/workflows/test_asset-exchange-corda.yml =========="
cat .github/workflows/test_asset-exchange-corda.yml 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: .github/workflows/test_asset-exchange-besu.yml =========="
cat .github/workflows/test_asset-exchange-besu.yml 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: tools/ci.sh =========="
cat tools/ci.sh 2>/dev/null | head -100 || echo "[FILE NOT FOUND or too large, showing first 100 lines]"

echo -e "\n\n========== FILE: docs/docs/contributing/code-of-conduct.md =========="
cat docs/docs/contributing/code-of-conduct.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/contributing/style-guide.md =========="
cat docs/docs/contributing/style-guide.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/contributing/pull-requests.md =========="
cat docs/docs/contributing/pull-requests.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/cactus/ledger-browser/developer-guide/README.md =========="
cat docs/docs/cactus/ledger-browser/developer-guide/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/weaver/getting-started/guide.md =========="
cat docs/docs/weaver/getting-started/guide.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/weaver/architecture-and-design/README.md =========="
cat docs/docs/weaver/architecture-and-design/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/weaver/user-stories/global-trade.md =========="
cat docs/docs/weaver/user-stories/global-trade.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/weaver/user-stories/financial-markets.md =========="
cat docs/docs/weaver/user-stories/financial-markets.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/concepts/README.md =========="
cat docs/docs/concepts/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: some_example_repos/cacti_onboarding_research/00_synthesis.md =========="
cat some_example_repos/cacti_onboarding_research/00_synthesis.md 2>/dev/null || echo "[FILE NOT FOUND]"

} > "$OUTPUT_FILE"

echo "Batch 5 complete: $OUTPUT_FILE"
```

## Master Script to Run All Batches

```bash
#!/bin/bash
# master_docs_extract.sh - Run all documentation extraction batches

echo "Starting Hyperledger Cacti Documentation Extraction..."
echo "========================================================"

# Create output directory
mkdir -p docs_extraction_output

# Run each batch
echo "Running Batch 1: Core Documentation..."
bash batch1_docs_core.sh
mv batch1_docs_core.txt docs_extraction_output/

echo "Running Batch 2: Weaver Documentation..."
bash batch2_weaver_docs.sh
mv batch2_weaver_docs.txt docs_extraction_output/

echo "Running Batch 3: Examples and Demos..."
bash batch3_examples_docs.sh
mv batch3_examples_docs.txt docs_extraction_output/

echo "Running Batch 4: Package Documentation..."
bash batch4_packages_docs.sh
mv batch4_packages_docs.txt docs_extraction_output/

echo "Running Batch 5: Developer Resources..."
bash batch5_developer_resources.sh
mv batch5_developer_resources.txt docs_extraction_output/

echo "========================================================"
echo "Extraction complete! All files saved to docs_extraction_output/"
ls -lh docs_extraction_output/

# Optional: Combine all files for easier analysis
echo "Creating combined summary..."
cat docs_extraction_output/*.txt > docs_extraction_output/ALL_DOCS_COMBINED.txt
echo "Combined file created: docs_extraction_output/ALL_DOCS_COMBINED.txt"
```

## How to Use These Scripts

1. **Save each batch** as a separate `.sh` file (e.g., `batch1_docs_core.sh`, `batch2_weaver_docs.sh`, etc.)
2. **Make them executable**:
   ```bash
   chmod +x batch*.sh master_docs_extract.sh
   ```
3. **Run the master script** from the Cacti repository root:
   ```bash
   ./master_docs_extract.sh
   ```
4. **Review outputs** in the `docs_extraction_output/` directory

## Expected Analysis Areas After Extraction

Once you have these outputs, you can analyze:

### For Documentation Restructuring
- Identify duplicate content between `README.md`, `README-cactus.md`, and `weaver/README.md`
- Find broken links (look for `github.com/hyperledger/cactus`, not `cacti`)
- Discover missing cross-references between Cactus and Weaver docs

### For Onboarding Guides
- Evaluate if `docs/docs/guides/getting-started.md` exists and is complete
- Check if examples have clear prerequisites
- Identify gaps in tutorial sequence

### For Architecture Documentation
- Verify if `docs/docs/architecture.md` accurately reflects the merged system
- Check if Weaver RFCs are referenced from main documentation

### For CI/CD Improvements# Documentation Deep Dive - Batch Commands

Based on your directory structure, I've organized all documentation-related files into **4 batches**. Each batch will output all files into a single file with clear separators.

## Batch 1: Core Documentation & MkDocs Structure

```bash
#!/bin/bash
# Batch 1: Core docs and MkDocs structure
OUTPUT_FILE="batch1_docs_core.txt"

{
echo "========== FILE: docs/README.md =========="
cat docs/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/index.md =========="
cat docs/docs/index.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/architecture.md =========="
cat docs/docs/architecture.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/vision.md =========="
cat docs/docs/vision.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/README.md =========="
cat docs/docs/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/cactus/introduction.md =========="
cat docs/docs/cactus/introduction.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/cactus/architecture.md =========="
cat docs/docs/cactus/architecture.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/weaver/introduction.md =========="
cat docs/docs/weaver/introduction.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/contributing/README.md =========="
cat docs/docs/contributing/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/guides/getting-started.md =========="
cat docs/docs/guides/getting-started.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: BUILD.md =========="
cat BUILD.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: FAQ.md =========="
cat FAQ.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: GOVERNANCE.md =========="
cat GOVERNANCE.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: MAINTAINERS.md =========="
cat MAINTAINERS.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: RELEASE_MANAGEMENT.md =========="
cat RELEASE_MANAGEMENT.md 2>/dev/null || echo "[FILE NOT FOUND]"

} > "$OUTPUT_FILE"

echo "Batch 1 complete: $OUTPUT_FILE"
```

## Batch 2: Weaver Documentation (RFCs and Architecture)

```bash
#!/bin/bash
# Batch 2: Weaver RFCs and architecture docs
OUTPUT_FILE="batch2_weaver_docs.txt"

{
echo "========== FILE: weaver/OVERVIEW.md =========="
cat weaver/OVERVIEW.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/README.md =========="
cat weaver/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/SECURITY.md =========="
cat weaver/SECURITY.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/README.md =========="
cat weaver/rfcs/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/terminology.md =========="
cat weaver/rfcs/terminology.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/models/README.md =========="
cat weaver/rfcs/models/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/models/infrastructure/relays.md =========="
cat weaver/rfcs/models/infrastructure/relays.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/models/infrastructure/interoperation-modules.md =========="
cat weaver/rfcs/models/infrastructure/interoperation-modules.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/protocols/README.md =========="
cat weaver/rfcs/protocols/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/protocols/data-sharing/generic.md =========="
cat weaver/rfcs/protocols/data-sharing/generic.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/protocols/asset-exchange/generic-htlc.md =========="
cat weaver/rfcs/protocols/asset-exchange/generic-htlc.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/protocols/asset-transfer/generic.md =========="
cat weaver/rfcs/protocols/asset-transfer/generic.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/formats/README.md =========="
cat weaver/rfcs/formats/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/rfcs/formats/views/definition.md =========="
cat weaver/rfcs/formats/views/definition.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/core/README.md =========="
cat weaver/core/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/core/relay/README.md =========="
cat weaver/core/relay/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/core/relay/architecture.md =========="
cat weaver/core/relay/architecture.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/core/relay/relay-config.md =========="
cat weaver/core/relay/relay-config.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/core/drivers/README.md =========="
cat weaver/core/drivers/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/core/drivers/fabric-driver/readme.md =========="
cat weaver/core/drivers/fabric-driver/readme.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/samples/README.md =========="
cat weaver/samples/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/sdks/README.md =========="
cat weaver/sdks/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: weaver/tests/README.md =========="
cat weaver/tests/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

} > "$OUTPUT_FILE"

echo "Batch 2 complete: $OUTPUT_FILE"
```

## Batch 3: Examples, Demos, and Tutorials Documentation

```bash
#!/bin/bash
# Batch 3: Examples and demos documentation
OUTPUT_FILE="batch3_examples_docs.txt"

{
echo "========== FILE: examples/README.md =========="
cat examples/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: examples/cactus-example-supply-chain-backend/README.md =========="
cat examples/cactus-example-supply-chain-backend/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: examples/cactus-example-discounted-asset-trade/README.md =========="
cat examples/cactus-example-discounted-asset-trade/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: examples/cactus-example-electricity-trade/README.md =========="
cat examples/cactus-example-electricity-trade/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: examples/cactus-example-cbdc-bridging/README.md =========="
cat examples/cactus-example-cbdc-bridging/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: examples/cactus-example-cbdc-bridging-frontend/README.md =========="
cat examples/cactus-example-cbdc-bridging-frontend/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: examples/cactus-example-carbon-accounting-backend/README.md =========="
cat examples/cactus-example-carbon-accounting-backend/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: examples/cactus-example-carbon-accounting-frontend/README.md =========="
cat examples/cactus-example-carbon-accounting-frontend/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: examples/carbon-accounting/README.md =========="
cat examples/carbon-accounting/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/README.md =========="
cat cacti-demos/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/README.md =========="
cat cacti-demos/gateway/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/satp/case_1/README.md =========="
cat cacti-demos/gateway/satp/case_1/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/satp/case_2/README.md =========="
cat cacti-demos/gateway/satp/case_2/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/satp/case_3/README.md =========="
cat cacti-demos/gateway/satp/case_3/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/oracle/case_1/README.md =========="
cat cacti-demos/gateway/oracle/case_1/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/oracle/case_2/README.md =========="
cat cacti-demos/gateway/oracle/case_2/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/oracle/case_3/README.md =========="
cat cacti-demos/gateway/oracle/case_3/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/oracle/case_4/README.md =========="
cat cacti-demos/gateway/oracle/case_4/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/oracle/case_5/README.md =========="
cat cacti-demos/gateway/oracle/case_5/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/oracle/case_6/README.md =========="
cat cacti-demos/gateway/oracle/case_6/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/oracle/case_7/README.md =========="
cat cacti-demos/gateway/oracle/case_7/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: cacti-demos/gateway/extensions/carbon-credit/README.md =========="
cat cacti-demos/gateway/extensions/carbon-credit/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: whitepaper/whitepaper.md =========="
cat whitepaper/whitepaper.md 2>/dev/null || echo "[FILE NOT FOUND]"

} > "$OUTPUT_FILE"

echo "Batch 3 complete: $OUTPUT_FILE"
```

## Batch 4: Package Documentation (Plugin READMEs)

```bash
#!/bin/bash
# Batch 4: Package-level documentation
OUTPUT_FILE="batch4_packages_docs.txt"

{
echo "========== FILE: packages/README.md =========="
cat packages/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-satp-hermes/README.md =========="
cat packages/cactus-plugin-satp-hermes/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-satp-hermes/ARCHITECTURE.md =========="
cat packages/cactus-plugin-satp-hermes/ARCHITECTURE.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-satp-hermes/CONTRIBUTING.md =========="
cat packages/cactus-plugin-satp-hermes/CONTRIBUTING.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-ledger-connector-fabric/README.md =========="
cat packages/cactus-plugin-ledger-connector-fabric/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-ledger-connector-besu/README.md =========="
cat packages/cactus-plugin-ledger-connector-besu/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-ledger-connector-corda/README.md =========="
cat packages/cactus-plugin-ledger-connector-corda/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-ledger-connector-ethereum/README.md =========="
cat packages/cactus-plugin-ledger-connector-ethereum/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-ledger-connector-iroha2/README.md =========="
cat packages/cactus-plugin-ledger-connector-iroha2/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-ledger-connector-polkadot/README.md =========="
cat packages/cactus-plugin-ledger-connector-polkadot/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-ledger-connector-sawtooth/README.md =========="
cat packages/cactus-plugin-ledger-connector-sawtooth/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-ledger-connector-stellar/README.md =========="
cat packages/cactus-plugin-ledger-connector-stellar/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-keychain-aws-sm/README.md =========="
cat packages/cactus-plugin-keychain-aws-sm/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-keychain-azure-kv/README.md =========="
cat packages/cactus-plugin-keychain-azure-kv/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-keychain-google-sm/README.md =========="
cat packages/cactus-plugin-keychain-google-sm/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-keychain-memory/README.md =========="
cat packages/cactus-plugin-keychain-memory/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-keychain-vault/README.md =========="
cat packages/cactus-plugin-keychain-vault/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-consortium-manual/README.md =========="
cat packages/cactus-plugin-consortium-manual/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-htlc-eth-besu/README.md =========="
cat packages/cactus-plugin-htlc-eth-besu/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-persistence-ethereum/README.md =========="
cat packages/cactus-plugin-persistence-ethereum/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-plugin-persistence-fabric/README.md =========="
cat packages/cactus-plugin-persistence-fabric/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-cmd-api-server/README.md =========="
cat packages/cactus-cmd-api-server/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-api-client/README.md =========="
cat packages/cactus-api-client/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-common/README.md =========="
cat packages/cactus-common/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cactus-core/README.md =========="
cat packages/cactus-core/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cacti-ledger-browser/README.md =========="
cat packages/cacti-ledger-browser/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: packages/cacti-plugin-weaver-driver-fabric/readme.md =========="
cat packages/cacti-plugin-weaver-driver-fabric/readme.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: extensions/cactus-plugin-htlc-coordinator-besu/README.md =========="
cat extensions/cactus-plugin-htlc-coordinator-besu/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: extensions/cactus-plugin-object-store-ipfs/README.md =========="
cat extensions/cactus-plugin-object-store-ipfs/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

} > "$OUTPUT_FILE"

echo "Batch 4 complete: $OUTPUT_FILE"
```

## Batch 5: Issue Templates, CI/CD, and Contributing Guides

```bash
#!/bin/bash
# Batch 5: Issue templates, CI/CD, and developer resources
OUTPUT_FILE="batch5_developer_resources.txt"

{
echo "========== FILE: .github/ISSUE_TEMPLATE/bug_report.md =========="
cat .github/ISSUE_TEMPLATE/bug_report.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: .github/ISSUE_TEMPLATE/feature_request.md =========="
cat .github/ISSUE_TEMPLATE/feature_request.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: .github/ISSUE_TEMPLATE/config.yml =========="
cat .github/ISSUE_TEMPLATE/config.yml 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: .github/workflows/ci.yaml =========="
cat .github/workflows/ci.yaml 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: .github/workflows/test_data-sharing.yml =========="
cat .github/workflows/test_data-sharing.yml 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: .github/workflows/test_asset-transfer.yml =========="
cat .github/workflows/test_asset-transfer.yml 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: .github/workflows/test_asset-exchange-fabric.yml =========="
cat .github/workflows/test_asset-exchange-fabric.yml 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: .github/workflows/test_asset-exchange-corda.yml =========="
cat .github/workflows/test_asset-exchange-corda.yml 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: .github/workflows/test_asset-exchange-besu.yml =========="
cat .github/workflows/test_asset-exchange-besu.yml 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: tools/ci.sh =========="
cat tools/ci.sh 2>/dev/null | head -100 || echo "[FILE NOT FOUND or too large, showing first 100 lines]"

echo -e "\n\n========== FILE: docs/docs/contributing/code-of-conduct.md =========="
cat docs/docs/contributing/code-of-conduct.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/contributing/style-guide.md =========="
cat docs/docs/contributing/style-guide.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/contributing/pull-requests.md =========="
cat docs/docs/contributing/pull-requests.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/cactus/ledger-browser/developer-guide/README.md =========="
cat docs/docs/cactus/ledger-browser/developer-guide/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/weaver/getting-started/guide.md =========="
cat docs/docs/weaver/getting-started/guide.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/weaver/architecture-and-design/README.md =========="
cat docs/docs/weaver/architecture-and-design/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/weaver/user-stories/global-trade.md =========="
cat docs/docs/weaver/user-stories/global-trade.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/weaver/user-stories/financial-markets.md =========="
cat docs/docs/weaver/user-stories/financial-markets.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: docs/docs/concepts/README.md =========="
cat docs/docs/concepts/README.md 2>/dev/null || echo "[FILE NOT FOUND]"

echo -e "\n\n========== FILE: some_example_repos/cacti_onboarding_research/00_synthesis.md =========="
cat some_example_repos/cacti_onboarding_research/00_synthesis.md 2>/dev/null || echo "[FILE NOT FOUND]"

} > "$OUTPUT_FILE"

echo "Batch 5 complete: $OUTPUT_FILE"
```

## Master Script to Run All Batches

```bash
#!/bin/bash
# master_docs_extract.sh - Run all documentation extraction batches

echo "Starting Hyperledger Cacti Documentation Extraction..."
echo "========================================================"

# Create output directory
mkdir -p docs_extraction_output

# Run each batch
echo "Running Batch 1: Core Documentation..."
bash batch1_docs_core.sh
mv batch1_docs_core.txt docs_extraction_output/

echo "Running Batch 2: Weaver Documentation..."
bash batch2_weaver_docs.sh
mv batch2_weaver_docs.txt docs_extraction_output/

echo "Running Batch 3: Examples and Demos..."
bash batch3_examples_docs.sh
mv batch3_examples_docs.txt docs_extraction_output/

echo "Running Batch 4: Package Documentation..."
bash batch4_packages_docs.sh
mv batch4_packages_docs.txt docs_extraction_output/

echo "Running Batch 5: Developer Resources..."
bash batch5_developer_resources.sh
mv batch5_developer_resources.txt docs_extraction_output/

echo "========================================================"
echo "Extraction complete! All files saved to docs_extraction_output/"
ls -lh docs_extraction_output/

# Optional: Combine all files for easier analysis
echo "Creating combined summary..."
cat docs_extraction_output/*.txt > docs_extraction_output/ALL_DOCS_COMBINED.txt
echo "Combined file created: docs_extraction_output/ALL_DOCS_COMBINED.txt"
```

## How to Use These Scripts

1. **Save each batch** as a separate `.sh` file (e.g., `batch1_docs_core.sh`, `batch2_weaver_docs.sh`, etc.)
2. **Make them executable**:
   ```bash
   chmod +x batch*.sh master_docs_extract.sh
   ```
3. **Run the master script** from the Cacti repository root:
   ```bash
   ./master_docs_extract.sh
   ```
4. **Review outputs** in the `docs_extraction_output/` directory

## Expected Analysis Areas After Extraction

Once you have these outputs, you can analyze:

### For Documentation Restructuring
- Identify duplicate content between `README.md`, `README-cactus.md`, and `weaver/README.md`
- Find broken links (look for `github.com/hyperledger/cactus`, not `cacti`)
- Discover missing cross-references between Cactus and Weaver docs

### For Onboarding Guides
- Evaluate if `docs/docs/guides/getting-started.md` exists and is complete
- Check if examples have clear prerequisites
- Identify gaps in tutorial sequence

### For Architecture Documentation
- Verify if `docs/docs/architecture.md` accurately reflects the merged system
- Check if Weaver RFCs are referenced from main documentation

### For CI/CD Improvements
- Analyze workflow runtime and parallelization opportunities
- Identify duplicate test jobs across different workflows

After running these commands, let me know which files were found vs missing, and I'll help you analyze the documentation gaps for your mentorship proposal!
- Analyze workflow runtime and parallelization opportunities
- Identify duplicate test jobs across different workflows

After running these commands, let me know which files were found vs missing, and I'll help you analyze the documentation gaps for your mentorship proposal!