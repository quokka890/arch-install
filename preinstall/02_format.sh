#!/usr/bin/env bash
set -euo pipefail
format() {
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$dir/../config/global.env"
source "$dir/../utils/logger.sh"

log "Formatting"
mkfs.fat -F32 "${part1}"

if [[ "$encryption" == "true" ]]; then
    log "Encrypting $part2"
    cryptsetup luksFormat "$part2"
    cryptsetup open "$part2" cryptroot
    export CRYPTROOT="/dev/mapper/cryptroot"
    success "Disk successfully encrypted and mapped to $CRYPTROOT"
else
    exit 0
fi

mkfs.btrfs "${part2}"
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
success "Formatted successfully"
}

