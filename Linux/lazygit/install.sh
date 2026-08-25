#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/installer.sh"

install_logical_packages git lazygit delta
bash "$LINUX_DIR/dev-links/install.sh" install

action_log 'Lazygit setup is complete.'
