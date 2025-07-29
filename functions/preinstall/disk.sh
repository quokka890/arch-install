#!/usr/bin/env bash

select_disk() {
    read -rp "Select disk (e.g /dev/sdx)" selected_disk
    export selected_disk
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
        export encryption="true"
    else
        export encryption="false"
    fi
}

get_partitions() {
    if [[ "$selected_disk" =~ ^/dev/sd ]]; then
        export partition1="${selected_disk}1"
        export partition2="${selected_disk}2"
    elif [[ "$selected_disk" =~ ^/dev/nvme ]]; then
        export partition1="${selected_disk}p1"
        export partition2="${selected_disk}p2"
    else
       error "Unknown disk type: $selected_disk"
    fi
}

get_cryptroot() {
    local dir
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$dir/../../preinstall/02_format.sh"
    export partition2=$CRYPTROOTVAR
}