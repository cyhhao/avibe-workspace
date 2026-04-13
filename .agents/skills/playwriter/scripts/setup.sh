#!/bin/bash
# Install playwriter CLI
# Usage: ./setup.sh

set -e

echo "🔍 Checking dependencies..."

# Check Node.js
if ! command -v node &> /dev/null; then
  echo "❌ Node.js not found. Please install from https://nodejs.org/"
  exit 1
fi
echo "✅ Node.js $(node --version)"

# Install playwriter
echo "📦 Installing playwriter..."
npm install -g playwriter@latest

echo ""
echo "🎉 CLI installed!"
echo ""
echo "Next steps:"
echo "1. Install Playwriter Chrome extension from Chrome Web Store"
echo "2. Click extension icon on any tab you want to control"
echo "3. Run: playwriter session new"
