# Maven Patch Version Auto-Increment Hook

This repository template provides a **per-repository configurable Git pre-commit hook** that automatically increments the **patch version** in your Maven `pom.xml` file using the [Maven Versions Plugin](https://www.mojohaus.org/versions/versions-maven-plugin/index.html).

It works seamlessly on both **macOS/Linux** and **Windows**, requires **no global configuration**, and uses the globally installed `mvn` binary (not the wrapper).


---

## 🚀 Features

- **Per-repository setup** – does not affect other Git repositories
- **Cross-platform** – tested on macOS, Linux, and Windows (Git Bash / PowerShell)
- **Automatic patch bump** – increments the patch part of the version (e.g., `1.2.3 → 1.2.4`)
- **No global installs required** – uses the system `mvn` binary
- **Easy enable/disable scripts** – simple one-line commands
- **Zero manual intervention** – version updates happen automatically on commit

---

## 📋 Table of Contents

- [Folder Structure](#-folder-structure)
- [Pre-commit Hook](#%EF%B8%8F-pre-commit-hook)
- [Quick Start](#-quick-start)
- [How It Works](#-how-it-works)
- [Optional Customization](#-optional-customization)
- [Uninstall](#-uninstall)
- [Requirements](#-requirements)
- [License](#-license)

---

## 📁 Folder Structure

```
.
├── .githooks/
│   └── pre-commit           # The actual pre-commit hook script
├── version-hook.sh          # Enable/disable script for macOS/Linux
└── version-hook.ps1         # Enable/disable script for Windows
```

---

## ⚙️ Pre-commit Hook

### `.githooks/pre-commit`

This script runs automatically on each commit and bumps the patch version in `pom.xml`.

```bash
#!/usr/bin/env bash
set -euo pipefail

# Run only if a pom.xml exists at repo root
[[ -f "pom.xml" ]] || exit 0

# Optional: do not bump if pom.xml is already staged
if git diff --cached --name-only | grep -qx "pom.xml"; then
  exit 0
fi

# Patch version auto-increment using Maven Versions Plugin
mvn -q build-helper:parse-version versions:set \
  -DnewVersion=\${parsedVersion.majorVersion}.\${parsedVersion.minorVersion}.\${parsedVersion.nextIncrementalVersion} \
  -DgenerateBackupPoms=false
mvn -q versions:commit

# Stage updated pom.xml so it lands in this commit
git add pom.xml
```

---

## 🚀 Quick Start

### macOS / Linux

Use `version-hook.sh` to enable or disable the hook:

```bash
# Enable the pre-commit hook in this repository
./version-hook.sh enable

# Disable the pre-commit hook in this repository
./version-hook.sh disable
```

This command sets (or unsets) `core.hooksPath` to `.githooks` in the local Git config for this repository.

### Windows

Use `version-hook.ps1` (run in PowerShell):

```powershell
# Enable the pre-commit hook
./version-hook.ps1 enable

# Disable the pre-commit hook
./version-hook.ps1 disable
```

---

## 🧠 How It Works

1. **On commit**: When you run `git commit`, the `.githooks/pre-commit` script executes automatically.

2. **Version check**: If `pom.xml` exists at the repo root and is not already staged:
   - Maven increments the patch version using the Versions Plugin:
     ```bash
     mvn build-helper:parse-version versions:set \
       -DnewVersion=${parsedVersion.majorVersion}.${parsedVersion.minorVersion}.${parsedVersion.nextIncrementalVersion}
     ```
   - The updated `pom.xml` is automatically staged for the commit.

3. **Commit proceeds**: The commit completes with the updated version.

### Example

| Before commit | After commit |
|---------------|--------------|
| `<version>1.4.6</version>` | `<version>1.4.7</version>` |

---

## ❌ What It Does NOT Do

- ✗ Does not modify any global Git settings
- ✗ Does not block manual edits to `pom.xml` (developers can still edit versions manually)
- ✗ Does not add the hook automatically — each developer must enable it with one command
- ✗ Does not affect other repositories on your system

---

## 🧹 Uninstall

To fully disable and remove the hook:

```bash
# Unset the hooks path
git config --unset core.hooksPath

# Remove the hooks directory
rm -rf .githooks
```

Or simply run the disable script:

```bash
./version-hook.sh disable    # macOS/Linux
./version-hook.ps1 disable   # Windows
```

---

## ✅ Requirements

- **Git** ≥ 2.13
- **Maven** ≥ 3.6 (must be available on `PATH`)
- **Operating System**: macOS, Linux (bash), or Windows (PowerShell / Git Bash)

---

## 🧾 License

This template is open for internal use and adaptation.  
You may freely modify and redistribute it across your projects.

---

## 💡 Tips

- **Bypass the hook for a single commit**: Use `git commit --no-verify` to skip the pre-commit hook.
- **Check current hook status**: Run `git config --get core.hooksPath` to see if hooks are enabled.
- **Test the hook**: Make a dummy change and commit to see the version increment in action.

---

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit pull requests to improve this template.
