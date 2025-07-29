#!/usr/bin/env bash
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$dir/utils/logger.sh"
source "$dir/preinstall/run.sh"
source "$dir/setup/run.sh"

log "Running preinstall" "confirm"
preinstall

log "Running setup" "confirm"
setup
