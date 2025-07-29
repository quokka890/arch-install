#!/usr/bin/env bash
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$dir/../../utils/var_manager.sh"

select_disk() {
    read -rp "Select disk (e.g /dev/sdx)" selected_disk
    update_env_var DISK $selected_disk
}

prep_disk() {
    if mountpoint -q /mnt; then
        umount -A --recursive /mnt
    fi
    wipefs -a "${selected_disk}"
    sgdisk -Z "${selected_disk}"
}

confirm_encryption() {
    read -p "Do you want to encrypt the disk? Y/n" encryption
    encrypt_confirm=${encryption:-Y}

    if [[ "$encrypt_confirm" =~ ^[Yy]$ ]]; then
        update_env_var encryption true
    else
        update_env_var encryption false
    fi
}

get_partitions() {
    if [[ "$selected_disk" =~ ^/dev/sd ]]; then
        update_env_var partition1 "${selected_disk}1"
        update_env_var partition2 "${selected_disk}2"
    elif [[ "$selected_disk" =~ ^/dev/nvme ]]; then
        update_env_var partition1 "${selected_disk}p1"
        update_env_var partition2 "${selected_disk}p2"
    else
       error "Unknown disk type: $selected_disk"
    fi
}