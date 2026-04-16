#!/bin/bash

# setup-cacti.sh - Initialize Hyperledger Cacti Dev Environment
set -e

echo "🚀 Starting Cacti setup..."
 

# 2. Ensure we are on the correct Node version
if [[ $(node -v) != *"v20.20.0"* ]]; then
    echo "❌ Error: Please run 'nvm use 20.20.0' first."
    exit 1
fi

# 3. Enable Corepack for Yarn support
echo "📦 Enabling Corepack..."
npm run enable-corepack

# 4. Run Initial Configuration (This takes ~10-15 minutes)
echo "🔨 Running initial configuration. Grab a coffee..."
yarn run configure

echo "✅ Build complete! You can now run 'npm run watch' to start developing."