#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/installer.sh"

TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_ROOT="$HOME/.mydotty-backups"
BACKUP_DIR="$BACKUP_ROOT/$TIMESTAMP"
BACKUP_USED=0

declare -a MANAGED_SOURCES=()
declare -a MANAGED_TARGETS=()

mkdir -p "$BACKUP_ROOT"

ensure_backup_dir() {
  if [[ "$BACKUP_USED" -eq 0 ]]; then
    mkdir -p "$BACKUP_DIR"
    BACKUP_USED=1
  fi
}

backup_target() {
  local target="$1"
  ensure_backup_dir

  local safe_name="${target#/}"
  safe_name="${safe_name//\//__}"

  mv "$target" "$BACKUP_DIR/$safe_name"
  action_log "Backed up $target -> $BACKUP_DIR/$safe_name"
}

register_mapping() {
  MANAGED_SOURCES+=("$1")
  MANAGED_TARGETS+=("$2")
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

  ln -s "$source" "$target"
  action_log "Linked $target -> $source"
}

unlink_one() {
  local source="$1"
  local target="$2"

  if [[ -L "$target" ]] && [[ "$(readlink "$target")" == "$source" ]]; then
    rm "$target"
    action_log "Unlinked $target"
    return
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
  register_mapping "$(get_shared_config_path 'nvim')" "$XDG_CONFIG_HOME/nvim"
  register_mapping "$(get_shared_config_path 'vim/.vimrc')" "$HOME/.vimrc"
  register_mapping "$(get_shared_config_path 'lazygit/config.yml')" "$XDG_CONFIG_HOME/lazygit/config.yml"
}

run_install() {
  local index
  for ((index = 0; index < ${#MANAGED_SOURCES[@]}; index++)); do
    link_one "${MANAGED_SOURCES[$index]}" "${MANAGED_TARGETS[$index]}"
  done

  if [[ "$BACKUP_USED" -eq 1 ]]; then
    action_log "Backups stored in: $BACKUP_DIR"
  else
    action_log 'No backups were needed.'
  fi
}

run_unlink() {
  local index
  for ((index = 0; index < ${#MANAGED_SOURCES[@]}; index++)); do
    unlink_one "${MANAGED_SOURCES[$index]}" "${MANAGED_TARGETS[$index]}"
  done
}

run_status() {
  local index
  for ((index = 0; index < ${#MANAGED_SOURCES[@]}; index++)); do
    status_one "${MANAGED_SOURCES[$index]}" "${MANAGED_TARGETS[$index]}"
  done
}

main() {
  local command="${1:-install}"
  build_mappings

  case "$command" in
    install)
      run_install
      ;;
    status)
      run_status
      ;;
    unlink)
      run_unlink
      ;;
    *)
      printf 'Usage: %s [install|status|unlink]\n' "$0" >&2
      exit 1
      ;;
  esac
}

main "$@"
