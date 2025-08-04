#!/usr/bin/env bash
set -eo pipefail
partition() {
    local dir
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$dir/../utils/logger.sh"
    source "$dir/../functions/disk.sh"
    source "$dir/../config/global.env"
    source "$dir/../utils/var_manager.sh"
    select_disk
    prep_disk
    update_env_var
    status "Partitioning disk ${DISK}" "confirm"
    sgdisk -a 2048 -o "${DISK}"
    sgdisk --new=1:0:+2G "${DISK}"
    sgdisk --typecode=1:ef00 "${DISK}"
    sgdisk --new=2:0:0 "${DISK}"
    partprobe "${DISK}"
    success "Partitioned successfully"
}
