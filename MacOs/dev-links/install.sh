#!/usr/bin/env bash
set -euo pipefail

# Create symlinks from this repository into the user's home so edits in-repo
# are reflected immediately in the active configuration.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MACOS_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_ROOT="$HOME/.mydotty-backups"
BACKUP_DIR="$BACKUP_ROOT/$TIMESTAMP"

mkdir -p "$BACKUP_ROOT"

BACKUP_USED=0

declare -a MANAGED_SOURCES=()
declare -a MANAGED_TARGETS=()

action_log() {
  local message="$1"
  printf '%s\n' "$message"
}

ensure_backup_dir() {
  if [[ "$BACKUP_USED" -eq 0 ]]; then
    mkdir -p "$BACKUP_DIR"
    BACKUP_USED=1
  fi
}

backup_target() {
  local target="$1"
  ensure_backup_dir

  local safe_name
  safe_name="${target#/}"
  safe_name="${safe_name//\//__}"

  mv "$target" "$BACKUP_DIR/$safe_name"
  action_log "Backed up $target -> $BACKUP_DIR/$safe_name"
}

register_mapping() {
  local source="$1"
  local target="$2"
  MANAGED_SOURCES+=("$source")
  MANAGED_TARGETS+=("$target")
}

link_one() {
  local source="$1"
  local target="$2"

  if [[ ! -e "$source" && ! -L "$source" ]]; then
    action_log "Skipping missing source: $source"
    return
  fi

  mkdir -p "$(dirname "$target")"

  if [[ -L "$target" ]]; then
    local current
    current="$(readlink "$target")"
    if [[ "$current" == "$source" ]]; then
      action_log "Already linked: $target -> $source"
      return
    fi

    backup_target "$target"
  elif [[ -e "$target" ]]; then
    backup_target "$target"
  fi

  ln -sfn "$source" "$target"
  action_log "Linked $target -> $source"
}

unlink_one() {
  local source="$1"
  local target="$2"

  if [[ -L "$target" ]]; then
    local current
    current="$(readlink "$target")"
    if [[ "$current" == "$source" ]]; then
      rm "$target"
      action_log "Unlinked $target"
      return
    fi
  fi

  action_log "Skipped (not managed link): $target"
}

status_one() {
  local source="$1"
  local target="$2"

  if [[ -L "$target" ]]; then
    local current
    current="$(readlink "$target")"
    if [[ "$current" == "$source" ]]; then
      action_log "OK   $target -> $source"
    else
      action_log "DIFF $target -> $current"
    fi
  elif [[ -e "$target" ]]; then
    action_log "FILE $target (not a symlink)"
  else
    action_log "MISS $target"
  fi
}

build_mappings() {
  register_mapping "$MACOS_DIR/ghostty/config" "$HOME/.config/ghostty/config"
  register_mapping "$MACOS_DIR/oh-my-zsh/.zshrc" "$HOME/.zshrc"
  register_mapping "$MACOS_DIR/vim/.vimrc" "$HOME/.vimrc"
  register_mapping "$MACOS_DIR/nvim" "$HOME/.config/nvim"
  register_mapping \
    "$MACOS_DIR/vscode/settings.json" \
    "$HOME/Library/Application Support/Code/User/settings.json"

  local plugin
  for plugin in "$MACOS_DIR"/oh-my-zsh/plugins/*; do
    [[ -e "$plugin" ]] || continue
    local plugin_file
    plugin_file="$(basename "$plugin")"
    local plugin_name
    plugin_name="${plugin_file%%.*}"

    register_mapping \
      "$plugin" \
      "$HOME/.oh-my-zsh/custom/plugins/$plugin_name/$plugin_file"
  done
}

run_install() {
  local i
  for (( i = 0; i < ${#MANAGED_SOURCES[@]}; i++ )); do
    link_one "${MANAGED_SOURCES[$i]}" "${MANAGED_TARGETS[$i]}"
  done

  if [[ "$BACKUP_USED" -eq 1 ]]; then
    action_log "Backups stored in: $BACKUP_DIR"
  else
    action_log "No backups were needed."
  fi

  action_log "Done. Changes in this repo now reflect immediately in linked locations."
}

run_unlink() {
  local i
  for (( i = 0; i < ${#MANAGED_SOURCES[@]}; i++ )); do
    unlink_one "${MANAGED_SOURCES[$i]}" "${MANAGED_TARGETS[$i]}"
  done

  action_log "Unlink complete. Restore from $BACKUP_ROOT if needed."
}

run_status() {
  local i
  for (( i = 0; i < ${#MANAGED_SOURCES[@]}; i++ )); do
    status_one "${MANAGED_SOURCES[$i]}" "${MANAGED_TARGETS[$i]}"
  done
}

main() {
  local command="${1:-install}"

  build_mappings

  case "$command" in
    install)
      run_install
      ;;
    unlink)
      run_unlink
      ;;
    status)
      run_status
      ;;
    *)
      printf 'Usage: %s [install|status|unlink]\n' "$0"
      exit 1
      ;;
  esac
}

main "$@"
