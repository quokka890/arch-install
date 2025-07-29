#!/usr/bin/env bash
set -eo pipefail
format() {
local dir
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$dir/../config/global.env"
source "$dir/../utils/logger.sh"
source "$dir/../functions/preinstall/disk.sh"
log "Formatting"
get_partitions
mkfs.fat -F32 "${part1}"
confirm_encryption
if [[ "$encryption" == "true" ]]; then
    log "Encrypting ${part2}"
    cryptsetup luksFormat "$part2"
    cryptsetup open "$part2" cryptroot
    export CRYPTROOTVAR="/dev/mapper/cryptroot"
    success "Disk successfully encrypted and mapped to $CRYPTROOTVAR"
    get_cryptroot ## this is terrible code pls fix this someday
else
    exit 0
fi

mkfs.btrfs "${part2}"
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
success "Formatting successful"
}

