#!/usr/bin/env bash
set -euo pipefail
preinstall() {
    local dir
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$dir/../functions/preinstall/preliminary_checks.sh"
    source "$dir/01_partition.sh"
    source "$dir/02_format.sh"
    source "$dir/03_mount.sh"
    run_checks
    partition
    ormat
    mount_filesystem
}


