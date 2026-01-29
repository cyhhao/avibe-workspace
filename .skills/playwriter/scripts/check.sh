#!/bin/bash
# Check playwriter environment
# Usage: ./check.sh
# Returns: 0 if CLI ready, 1 if setup needed

READY=true

# Check Node.js
if ! command -v node &> /dev/null; then
  echo "❌ Node.js not found"
  echo "   Install from: https://nodejs.org/"
  READY=false
else
  echo "✅ Node.js $(node --version)"
fi

# Check playwriter CLI
if ! command -v playwriter &> /dev/null; then
  echo "❌ playwriter CLI not installed"
  echo "   Run: npm install -g playwriter@latest"
  READY=false
else
  echo "✅ playwriter CLI installed"
fi

# Summary
echo ""
if [ "$READY" = true ]; then
  echo "🎉 CLI ready!"
  echo ""
  echo "⚠️  Remember: User must install & enable Chrome extension"
  echo "   Click Playwriter extension icon on tab to control"
  exit 0
else
  echo "⚠️  Setup required"
  exit 1
fi
