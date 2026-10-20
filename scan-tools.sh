#!/usr/bin/env bash
# Scan installed coding tools. Excludes: Ruby, Java, Perl, kubectl, kind, aws cli.
set -euo pipefail

OUT="$(dirname "$0")/tools.md"
{
echo "# Coding Tools"
echo ""
echo "Auto-generated list of installed development tools."
echo ""
echo "Last updated: $(date -u +"%Y-%m-%d %H:%M UTC")"
echo ""

exclude="ruby|java|perl|kubectl|kind|aws"

scan_section() {
  local title="$1"
  shift
  echo "## $title"
  echo ""
  local found=0
  for cmd in "$@"; do
    local path
    path=$(command -v "$cmd" 2>/dev/null || true)
    if [ -n "$path" ]; then
      if echo "$cmd" | grep -qiE "^($exclude)$"; then
        continue
      fi
      local ver
      ver=$($cmd --version 2>/dev/null | head -1 || $cmd version 2>/dev/null | head -1 || echo "?")
      echo "- \`$cmd\` — $path — $ver"
      found=1
    fi
  done
  if [ "$found" -eq 0 ]; then
    echo "_None found_"
  fi
  echo ""
}

scan_section "Editors" git gh code cursor zed vim nvim emacs subl
scan_section "Package managers" brew npm yarn pnpm bun pip pip3 pipx poetry uv conda mamba cargo gem bundle
scan_section "Languages / runtimes" node python python3 go rust php lua dotnet
scan_section "Containers / k8s" docker podman helm minikube k9s colima limactl
scan_section "Cloud / infra" az gcloud terraform pulumi ansible ansible-playbook vagrant
scan_section "Databases" psql mysql mongosh redis-cli sqlite3 pg_dump mysqladmin
scan_section "Terminals / shells" zsh bash fish warp iterm2 alacritty kitty ghostty tmux screen
scan_section "Build / system" make cmake gcc clang gdb lldb xcodebuild ninja meson just

echo "## macOS Applications"
echo ""
if [ -d /Applications ]; then
  ls /Applications/ 2>/dev/null | grep -iE "(postman|insomnia|docker|cursor|visual studio|zed|fleet|webstorm|intellij|datagrip|tableplus|github|sublime|warp|ghostty|iterm|fig|raycast|linear|notion|obsidian)" | sort -u | sed 's/^/- /' || echo "_None found_"
else
  echo "_None found_"
fi
echo ""

echo "## Shell"
echo ""
echo "- Default shell: \`$SHELL\`"

} > "$OUT"

echo "Wrote $OUT"
