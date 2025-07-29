#!/usr/bin/env bash
set -euo pipefail
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$dir/../utils/var_manager.sh"
update_env_var part1 dsadasdsa
log "hi"