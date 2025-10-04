$ErrorActionPreference = "Stop"

if (-not (Test-Path "pom.xml")) {
  Write-Host "Run this from the repository root that contains pom.xml"
  exit 1
}

# Set hooks path in local repo config
git config core.hooksPath .githooks

# Mark executable bit for consistency when used in WSL or macOS clones
try {
  bash -lc "chmod +x .githooks/pre-commit" | Out-Null
} catch {
  # If bash is unavailable, ignore. Git for Windows will still run the script via Git Bash when present.
}

Write-Host "Pre-commit version bump hook enabled for this repository."