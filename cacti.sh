#!/bin/bash

# setup-cacti.sh - Initialize Hyperledger Cacti Dev Environment
set -e

echo "🚀 Starting Cacti setup..." 

# Enable Corepack for Yarn support
echo "📦 Enabling Corepack..."
npm run enable-corepack

# Run Initial Configuration (This takes ~10-15 minutes)
echo "🔨 Running initial configuration."
yarn run configure

echo "✅ Build complete! You can now run 'npm run watch' to start developing."