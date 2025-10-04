#!/usr/bin/env bash
set -euo pipefail

# Usage: scripts/version-hook.sh enable|disable
ACTION="${1:-}"

HOOKS_DIR=".githooks"
HOOK_FILE="$HOOKS_DIR/pre-commit"

usage() {
  echo "Usage: $0 enable|disable"
  exit 2
}

if [[ -z "$ACTION" ]]; then
  usage
fi

# Basic repo check
if [[ ! -d .git ]]; then
  echo "Error: run this from the root of a Git repository"
  exit 1
fi

case "$ACTION" in
  enable)
    # Ensure hook file exists
    if [[ ! -f "$HOOK_FILE" ]]; then
      echo "Error: $HOOK_FILE not found. Add your pre-commit hook first."
      exit 1
    fi

    # Optional: require pom.xml at root
    if [[ ! -f "pom.xml" ]]; then
      echo "Warning: pom.xml not found at repo root. The hook will simply do nothing."
    fi

    chmod +x "$HOOK_FILE"
    git config --local core.hooksPath "$HOOKS_DIR"
    echo "Pre-commit version bump hook ENABLED for this repository."
    echo "core.hooksPath -> $(git config --local core.hooksPath)"
    ;;

  disable)
    current="$(git config --local --get core.hooksPath || true)"
    if [[ "$current" == "$HOOKS_DIR" ]]; then
      git config --local --unset core.hooksPath
      echo "Pre-commit version bump hook DISABLED for this repository."
    else
      echo "No change. core.hooksPath is not set to $HOOKS_DIR (current: '${current:-unset}')."
    fi
    ;;

  *)
    usage
    ;;
esac