#!/usr/bin/env bash
set -euo pipefail

# Ensure we are in the repo root
if [ ! -f "pom.xml" ]; then
  echo "Run this from the repository root that contains pom.xml"
  exit 1
fi

# Ensure hook is executable
chmod +x .githooks/pre-commit

# Point Git to use the repo-local hooks directory
git config core.hooksPath .githooks

echo "Pre-commit version bump hook enabled for this repository."