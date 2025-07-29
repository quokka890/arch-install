#!/usr/bin/env bash
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$dir/../../config/global.env"
source "$dir/../../utils/logger.sh"
source "$dir/../../preinstall/02_format.sh"

select_disk() {
    read -p "Select disk (e.g /dev/sdx)" selected_disk
    export selected_disk
}

prep_disk() {
    umount -A recursive /mnt
    sgdisk -Z "${DISK}"
}

confirm_encrypt() {
    local default_response="Y"
    read -p -r "Do you want to encrypt the disk? Y/n " encryption
    encrypt_confirm=${encryption:-$default_response}

    if [[ "$encrypt_confirm" =~ ^[Yy]$ ]]; then
        export encryption="true"
    else
        export encryption="false"
    fi
}

get_partition() {
    if [[ "$DISK" =~ ^/dev/sd ]]; then
        export partition1="${DISK}1"
        export partition="${DISK}2"
    elif [[ "$DISK" =~ ^/dev/nvme ]]; then
        export partition1="${DISK}p1"
        export partition2="${DISK}p2"
    else
       error "Unknown disk type: $DISK"
    fi

    if [[ $encryption == "true" ]]; then
        export partition2=$CRYPTROOT
    fi
}