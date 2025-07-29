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
    log "Formatting"
    mkfs.fat -F32 "${part1}"

    confirm_encryption

    if [[ "$encryption" == true ]]; then
        log "Encrypting ${part2}"
        cryptsetup luksFormat "$part2"
        cryptsetup open "$part2" cryptroot

        CRYPTROOT="/dev/mapper/cryptroot"
        update_env_var part2 "$CRYPTROOT"

        success "Disk successfully encrypted and mapped to $CRYPTROOT"
    else
        log "Proceeding without encryption"
    fi

    mkfs.btrfs "${part2}"
    btrfs subvolume create /mnt/@
    btrfs subvolume create /mnt/@home
    success "Formatting successful"
}
