#!/usr/bin/env bash

select_disk() {
    local dir
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    caller="$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd)"
    source "$dir/../utils/var_manager.sh"
    read -rp "Select disk (e.g /dev/sdx)" selected_disk
    update_env_var DISK "$selected_disk" "$caller"
}

prep_disk() {
    if findmnt -rno TARGET /mnt &>/dev/null; then
        umount -A --recursive /mnt
    fi

    if [[ -e /dev/mapper/cryptroot ]]; then
        cryptsetup close cryptroot 
    fi

    swapoff "$selected_disk" 2>/dev/null || true
    fuser -kv "$selected_disk" 2>/dev/null || true
    sgdisk -Z "${selected_disk}"
    partprobe "$selected_disk" || true
    wipefs -a "${selected_disk}"
}

confirm_encryption() {
    local dir
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$dir/../utils/var_manager.sh"
    default_response=Y
    read -p "Do you want to encrypt the disk? Y/n" encryption
    encrypt_confirm=${encryption:-$default_response}

    if [[ "$encrypt_confirm" =~ ^[Yy]$ ]]; then
        update_env_var encryption "true"
    else
        update_env_var encryption "false"
    fi
}

get_partitions() {
    local dir
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$dir/../utils/var_manager.sh"
    if [[ "$selected_disk" =~ ^/dev/sd ]]; then
        update_env_var part1 "${selected_disk}1"
        update_env_var part2 "${selected_disk}2"
        update_env_var persistent_part2 "${selected_disk}2"
    elif [[ "$selected_disk" =~ ^/dev/nvme ]]; then
        update_env_var part1 "${selected_disk}p1"
        update_env_var part2 "${selected_disk}p2"
        update_env_var persistent_part2 "${selected_disk}p2"
    else
       error "Unknown disk type: $selected_disk"
    fi
}