#!/usr/bin/env bash
set -euo pipefail

COMMON_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LINUX_DIR="$(cd "$COMMON_DIR/.." && pwd)"
REPO_ROOT="$(cd "$LINUX_DIR/.." && pwd)"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
PACKAGE_MANAGER="${PACKAGE_MANAGER:-}"
PACKAGE_INDEX_UPDATED=0
NEOVIM_MINIMUM_VERSION="${NEOVIM_MINIMUM_VERSION:-0.10.0}"

export XDG_CONFIG_HOME

action_log() {
  printf '%s\n' "$1"
}

fail() {
  printf 'Error: %s\n' "$1" >&2
  exit 1
}

require_command() {
  local command_name="$1"
  local install_hint="$2"

  if ! command -v "$command_name" &>/dev/null; then
    fail "$command_name is required. $install_hint"
  fi
}

detect_package_manager() {
  if [[ -n "$PACKAGE_MANAGER" ]]; then
    case "$PACKAGE_MANAGER" in
      apt|dnf|pacman)
        export PACKAGE_MANAGER
        return
        ;;
      *)
        fail "Unsupported package manager: $PACKAGE_MANAGER"
        ;;
    esac
  fi

  if command -v apt-get &>/dev/null; then
    PACKAGE_MANAGER='apt'
  elif command -v dnf &>/dev/null; then
    PACKAGE_MANAGER='dnf'
  elif command -v pacman &>/dev/null; then
    PACKAGE_MANAGER='pacman'
  else
    fail 'Supported package managers are apt, dnf, and pacman.'
  fi

  export PACKAGE_MANAGER
}

run_as_root() {
  if [[ "$EUID" -eq 0 ]]; then
    "$@"
    return
  fi

  require_command sudo 'Install sudo or run this installer as root.'
  sudo "$@"
}

update_package_index() {
  detect_package_manager

  if [[ "$PACKAGE_MANAGER" != 'apt' || "$PACKAGE_INDEX_UPDATED" -eq 1 || "${MYDOTTY_SKIP_PACKAGE_INDEX_UPDATE:-0}" == '1' ]]; then
    return
  fi

  action_log 'Refreshing apt package index...'
  run_as_root apt-get update
  PACKAGE_INDEX_UPDATED=1
}

install_packages() {
  (( "$#" > 0 )) || return

  detect_package_manager
  update_package_index

  case "$PACKAGE_MANAGER" in
    apt)
      run_as_root apt-get install --yes "$@"
      ;;
    dnf)
      run_as_root dnf install --assumeyes "$@"
      ;;
    pacman)
      run_as_root pacman --sync --needed --noconfirm "$@"
      ;;
    *)
      fail "Unsupported package manager: $PACKAGE_MANAGER"
      ;;
  esac
}

package_name() {
  local logical_name="$1"

  detect_package_manager

  case "$logical_name" in
    neovim|vim|git|nodejs|npm|ripgrep|fzf|curl|lazygit|delta|make)
      case "$logical_name" in
        delta)
          printf '%s\n' 'git-delta'
          ;;
        vim)
          if [[ "$PACKAGE_MANAGER" == 'dnf' ]]; then
            printf '%s\n' 'vim-enhanced'
          else
            printf '%s\n' 'vim'
          fi
          ;;
        make)
          if [[ "$PACKAGE_MANAGER" == 'apt' ]]; then
            printf '%s\n' 'build-essential'
          elif [[ "$PACKAGE_MANAGER" == 'dnf' ]]; then
            printf '%s\n' 'gcc' 'make'
          else
            printf '%s\n' 'base-devel'
          fi
          ;;
        *)
          printf '%s\n' "$logical_name"
          ;;
      esac
      ;;
    fd)
      if [[ "$PACKAGE_MANAGER" == 'pacman' ]]; then
        printf '%s\n' 'fd'
      else
        printf '%s\n' 'fd-find'
      fi
      ;;
    imagemagick)
      if [[ "$PACKAGE_MANAGER" == 'dnf' ]]; then
        printf '%s\n' 'ImageMagick'
      else
        printf '%s\n' 'imagemagick'
      fi
      ;;
    python3)
      if [[ "$PACKAGE_MANAGER" == 'pacman' ]]; then
        printf '%s\n' 'python'
      else
        printf '%s\n' 'python3'
      fi
      ;;
    pip)
      if [[ "$PACKAGE_MANAGER" == 'pacman' ]]; then
        printf '%s\n' 'python-pip'
      else
        printf '%s\n' 'python3-pip'
      fi
      ;;
    *)
      fail "No package mapping is defined for: $logical_name"
      ;;
  esac
}

install_logical_packages() {
  local packages=()
  local logical_name

  for logical_name in "$@"; do
    while IFS= read -r package; do
      packages+=("$package")
    done < <(package_name "$logical_name")
  done

  install_packages "${packages[@]}"
}

ensure_local_bin() {
  local local_bin="$HOME/.local/bin"
  mkdir -p "$local_bin"

  if [[ ":$PATH:" != *":$local_bin:"* ]]; then
    export PATH="$local_bin:$PATH"
  fi
}

install_npm_global_package() {
  local package="$1"

  require_command npm 'Install Node.js and npm, then rerun this installer.'
  ensure_local_bin
  npm install --global --prefix "$HOME/.local" "$package"
}

ensure_fd_command() {
  if command -v fd &>/dev/null || ! command -v fdfind &>/dev/null; then
    return
  fi

  ensure_local_bin

  local fd_link="$HOME/.local/bin/fd"
  local fdfind_path
  fdfind_path="$(command -v fdfind)"

  if [[ -L "$fd_link" ]]; then
    if [[ "$(readlink "$fd_link")" == "$fdfind_path" ]]; then
      return
    fi

    action_log "Skipped fd compatibility link because it already points elsewhere: $fd_link"
    return
  fi

  if [[ -e "$fd_link" ]]; then
    action_log "Skipped fd compatibility link because a file already exists: $fd_link"
    return
  fi

  ln -s "$fdfind_path" "$fd_link"
  action_log "Linked $fd_link -> $fdfind_path"
}

version_is_at_least() {
  local current_version="$1"
  local minimum_version="$2"

  [[ "$(printf '%s\n%s\n' "$minimum_version" "$current_version" | sort -V | head -n 1)" == "$minimum_version" ]]
}

get_neovim_version() {
  local nvim_path="$1"
  "$nvim_path" --version 2>/dev/null | sed -n '1s/^NVIM v//p'
}

ensure_neovim_version() {
  ensure_local_bin

  local nvim_path
  nvim_path="$(command -v nvim || true)"
  if [[ -n "$nvim_path" ]]; then
    local installed_version
    installed_version="$(get_neovim_version "$nvim_path")"
    if [[ -n "$installed_version" ]] && version_is_at_least "$installed_version" "$NEOVIM_MINIMUM_VERSION"; then
      action_log "Neovim $installed_version satisfies the minimum version $NEOVIM_MINIMUM_VERSION."
      return
    fi
  fi

  action_log "Installing a current Neovim release because the available version is below $NEOVIM_MINIMUM_VERSION."
  require_command curl 'Install curl, then rerun this installer.'
  require_command tar 'Install tar, then rerun this installer.'

  local architecture
  case "$(uname -m)" in
    x86_64|amd64)
      architecture='x86_64'
      ;;
    aarch64|arm64)
      architecture='arm64'
      ;;
    *)
      fail "No official Neovim Linux release asset is configured for architecture: $(uname -m)"
      ;;
  esac

  local archive_name="nvim-linux-$architecture.tar.gz"
  local temporary_directory
  temporary_directory="$(mktemp -d)"
  local archive_path="$temporary_directory/$archive_name"

  if ! curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/$archive_name" -o "$archive_path"; then
    rm -rf "$temporary_directory"
    fail 'Could not download the current Neovim release.'
  fi

  if ! tar -xzf "$archive_path" -C "$temporary_directory"; then
    rm -rf "$temporary_directory"
    fail 'Could not extract the Neovim release archive.'
  fi

  local extracted_directory="$temporary_directory/nvim-linux-$architecture"
  local extracted_binary="$extracted_directory/bin/nvim"
  if [[ ! -x "$extracted_binary" ]]; then
    rm -rf "$temporary_directory"
    fail 'The Neovim release archive did not contain the expected nvim binary.'
  fi

  local release_version
  release_version="$(get_neovim_version "$extracted_binary")"
  if [[ -z "$release_version" ]] || ! version_is_at_least "$release_version" "$NEOVIM_MINIMUM_VERSION"; then
    rm -rf "$temporary_directory"
    fail "The downloaded Neovim release does not satisfy the minimum version $NEOVIM_MINIMUM_VERSION."
  fi

  local local_opt_directory="$HOME/.local/opt"
  local installation_directory="$local_opt_directory/nvim-$release_version-$architecture"
  mkdir -p "$local_opt_directory"

  if [[ ! -e "$installation_directory" ]]; then
    mv "$extracted_directory" "$installation_directory"
  fi
  rm -rf "$temporary_directory"

  local local_nvim="$HOME/.local/bin/nvim"
  local expected_binary="$installation_directory/bin/nvim"
  if [[ -e "$local_nvim" || -L "$local_nvim" ]]; then
    if [[ -L "$local_nvim" ]] && [[ "$(readlink "$local_nvim")" == "$expected_binary" ]]; then
      action_log "Already linked: $local_nvim -> $expected_binary"
    elif [[ -L "$local_nvim" ]] && [[ "$(readlink "$local_nvim")" == "$local_opt_directory"/nvim-*/bin/nvim ]]; then
      ln -sfn "$expected_binary" "$local_nvim"
      action_log "Updated $local_nvim -> $expected_binary"
    else
      fail "Cannot activate the downloaded Neovim because $local_nvim already exists. Move it aside, then rerun this installer."
    fi
  else
    ln -s "$expected_binary" "$local_nvim"
    action_log "Linked $local_nvim -> $expected_binary"
  fi
}

get_shared_config_path() {
  local relative_path="$1"
  local config_path="$REPO_ROOT/config/$relative_path"

  if [[ ! -e "$config_path" ]]; then
    fail "Expected shared configuration was not found: $config_path"
  fi

  printf '%s\n' "$config_path"
}
