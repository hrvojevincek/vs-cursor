#!/usr/bin/env bash
# Install VSCode extensions
set -euo pipefail

code --version >/dev/null 2>&1 || { echo "VSCode CLI (code) not found"; exit 1; }

while IFS= read -r ext; do
  [[ -z "$ext" ]] && continue
  echo "Installing $ext..."
  code --install-extension "$ext"
done < "$(dirname "$0")/vscode-extensions.txt"
