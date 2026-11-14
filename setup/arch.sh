#!/usr/bin/env bash
# Manual package bootstrap. No changes unless --install is explicitly given.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: bash setup/arch.sh [--install] [--hardware] [--aur]

Default: preview the current package snapshot without making changes.
  --install   Upgrade Arch and install missing packages; keep normal prompts.
  --hardware  Include this desktop's kernel, firmware and NVIDIA packages.
  --aur       Include reviewed foreign packages using an already installed yay.
  --help      Show help.

Review setup/packages-*.txt first. This is not an Arch OS installer.
No dotfiles, services, bootloader configuration or user groups are changed.
EOF
}

install=false
hardware=false
aur=false
for arg in "$@"; do
  case "$arg" in
    --install) install=true ;;
    --hardware) hardware=true ;;
    --aur) aur=true ;;
    --help|-h) usage; exit 0 ;;
    *) printf 'Unknown option: %s\n' "$arg" >&2; usage >&2; exit 2 ;;
  esac
done

dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
read_list() {
  local line
  while IFS= read -r line || [[ -n "$line" ]]; do
    line=${line%%#*}
    [[ "$line" =~ ^[[:space:]]*$ ]] && continue
    if [[ ! "$line" =~ ^[a-zA-Z0-9@_+][a-zA-Z0-9@._+-]*$ ]]; then
      printf 'Invalid package in %s: %s\n' "$1" "$line" >&2
      return 1
    fi
    printf '%s\n' "$line"
  done < "$1"
}

declare -A hardware_packages=() seen=()
# Read through command substitution so malformed lists propagate a failure.
hardware_list=$(read_list "$dir/packages-hardware.txt")
while IFS= read -r pkg; do
  [[ -n "$pkg" ]] && hardware_packages["$pkg"]=1
done <<< "$hardware_list"

official_list=$(read_list "$dir/packages-official.txt")
required_list=$(read_list "$dir/packages-required.txt")
packages=()
while IFS= read -r pkg; do
  [[ -z "$pkg" ]] && continue
  if ! "$hardware" && [[ -n ${hardware_packages[$pkg]+yes} ]]; then
    continue
  fi
  [[ -n ${seen[$pkg]+yes} ]] && continue
  packages+=("$pkg")
  seen["$pkg"]=1
done <<< "$official_list
$required_list"

foreign=()
if "$aur"; then
  foreign_list=$(read_list "$dir/packages-foreign.txt")
  while IFS= read -r pkg; do
    [[ -n "$pkg" ]] && foreign+=("$pkg")
  done <<< "$foreign_list"
fi

printf 'Official/runtime packages: %s; foreign packages: %s\n' "${#packages[@]}" "${#foreign[@]}"
printf 'Hardware-specific packages enabled: %s\n' "$hardware"
printf 'Planned command: '
printf '%q ' sudo pacman -Syu --needed -- "${packages[@]}"
printf '\n'
if ((${#foreign[@]})); then
  printf 'After reviewing PKGBUILDs: '
  printf '%q ' yay -S --needed -- "${foreign[@]}"
  printf '\n'
fi

if ! "$install"; then
  printf 'Preview only. Add --install to proceed. No changes made.\n'
  exit 0
fi

command -v pacman >/dev/null || { printf 'pacman is required.\n' >&2; exit 1; }
if ((EUID == 0)); then
  printf 'Run as your regular user, not root; sudo is used only for pacman.\n' >&2
  exit 1
fi
command -v sudo >/dev/null || { printf 'sudo is required.\n' >&2; exit 1; }
if "$aur" && ! command -v yay >/dev/null; then
  printf 'Install/review yay manually first, or omit --aur.\n' >&2
  exit 1
fi
printf 'This installs the selected snapshot and performs a full system upgrade.\n'
read -r -p 'Type INSTALL to continue: ' answer
[[ "$answer" == INSTALL ]] || { printf 'Cancelled.\n'; exit 0; }
sudo pacman -Syu --needed -- "${packages[@]}"
if ((${#foreign[@]})); then
  yay -S --needed -- "${foreign[@]}"
fi
