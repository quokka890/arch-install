#!/usr/bin/env bash
set -eo pipefail
partition() {
local dir
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$dir/../config/global.env"
source "$dir/../utils/logger.sh"
source "$dir/../functions/preinstall/disk.sh"
select_disk
prep_disk
log "Partitioning disk ${DISK}" "confirm"
sgdisk -a 2048 -o "${DISK}"
sgdisk --new=1:2048:+2G "${DISK}"
sgdisk --typecode=1:ef00 "${DISK}"
sgdisk --new=2:0:0 "${DISK}"
partprobe "${DISK}"

success "Partitioned successfully"
}
