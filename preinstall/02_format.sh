#!/usr/bin/env bash
set -eo pipefail
format() {
    local dir
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$dir/../functions/preinstall/disk.sh"
    source "$dir/../config/global.env"
    source "$dir/../utils/logger.sh"
    source "$dir/../utils/var_manager.sh"

    get_partitions
    log "Formatting root partition (${part1})"
    mkfs.fat -F32 "$part1"

    confirm_encryption
    if [[ "$encryption" == "true" ]]; then
        log "Encrypting ${part2}"
        cryptsetup luksFormat "$part2"
        success "Encryption successful"
        log "Opening encrypted partition"
        cryptsetup open "$part2" cryptroot

        CRYPTROOT="/dev/mapper/cryptroot"
        update_env_var part2 "$CRYPTROOT"

        success "Disk successfully encrypted and mapped to ${part2}"
        warn "part2 variable updated to $CRYPTROOT"
    else
        log "Proceeding without encryption"
    fi
    mkfs.btrfs "$part2"
    mount "$part2" /mnt
    btrfs subvolume create /mnt/@
    btrfs subvolume create /mnt/@home
    umount /mnt
    success "Formatting successful"
}
