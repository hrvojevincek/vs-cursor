#!/usr/bin/env bash
# Install Cursor extensions
set -euo pipefail

cursor --version >/dev/null 2>&1 || { echo "Cursor CLI (cursor) not found"; exit 1; }

while IFS= read -r ext; do
  [[ -z "$ext" ]] && continue
  echo "Installing $ext..."
  cursor --install-extension "$ext"
done < "$(dirname "$0")/cursor-extensions.txt"
