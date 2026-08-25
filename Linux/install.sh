#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common/installer.sh"

usage() {
  cat <<EOF
Usage: $0 [all|editors|terminal|nvim|vim|lazygit|nvim-extras|dev-links|dev-links-status|dev-links-unlink]
EOF
}

run_installer() {
  local relative_path="$1"
  shift
  bash "$SCRIPT_DIR/$relative_path" "$@"
}

main() {
  local target="${1:-all}"

  case "$target" in
    dev-links)
      run_installer 'dev-links/install.sh' install
      ;;
    dev-links-status)
      run_installer 'dev-links/install.sh' status
      ;;
    dev-links-unlink)
      run_installer 'dev-links/install.sh' unlink
      ;;
    all|editors|terminal|nvim|vim|lazygit|nvim-extras)
      detect_package_manager
      update_package_index
      export MYDOTTY_SKIP_PACKAGE_INDEX_UPDATE=1

      case "$target" in
        all)
          run_installer 'nvim/install.sh'
          run_installer 'vim/install.sh'
          run_installer 'lazygit/install.sh'
          ;;
        editors)
          run_installer 'nvim/install.sh'
          run_installer 'vim/install.sh'
          ;;
        terminal)
          run_installer 'lazygit/install.sh'
          ;;
        nvim)
          run_installer 'nvim/install.sh'
          ;;
        vim)
          run_installer 'vim/install.sh'
          ;;
        lazygit)
          run_installer 'lazygit/install.sh'
          ;;
        nvim-extras)
          run_installer 'nvim/install.sh' --extras
          ;;
      esac
      ;;
    *)
      usage >&2
      exit 1
      ;;
  esac

  action_log "Completed Linux target: $target"
}

main "$@"
