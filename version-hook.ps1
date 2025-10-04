param(
  [Parameter(Mandatory = $true)]
  [ValidateSet("enable", "disable")]
  [string]$Action
)

$ErrorActionPreference = "Stop"
$HooksDir = ".githooks"
$HookFile = Join-Path $HooksDir "pre-commit"

function Assert-InRepo {
  if (-not (Test-Path ".git")) {
    Write-Host "Error: run this from the root of a Git repository"
    exit 1
  }
}

Assert-InRepo

switch ($Action) {
  "enable" {
    if (-not (Test-Path $HookFile)) {
      Write-Host "Error: $HookFile not found. Add your pre-commit hook first."
      exit 1
    }

    if (-not (Test-Path "pom.xml")) {
      Write-Host "Warning: pom.xml not found at repo root. The hook will simply do nothing."
    }

    # Set repo-local hooks path
    git config --local core.hooksPath $HooksDir | Out-Null

    # Try to set executable bit for cross-platform clones
    try {
      bash -lc "chmod +x $HookFile" | Out-Null
    } catch {
      # If Git Bash is unavailable, ignore
    }

    Write-Host "Pre-commit version bump hook ENABLED for this repository."
    $current = git config --local --get core.hooksPath
    Write-Host ("core.hooksPath -> {0}" -f $current)
  }

  "disable" {
    $current = ""
    try { $current = git config --local --get core.hooksPath } catch { }

    if ($current -eq $HooksDir) {
      git config --local --unset core.hooksPath | Out-Null
      Write-Host "Pre-commit version bump hook DISABLED for this repository."
    } else {
      Write-Host ("No change. core.hooksPath is not set to {0} (current: '{1}')." -f $HooksDir, ($current -ne $null ? $current : "unset"))
    }
  }
}