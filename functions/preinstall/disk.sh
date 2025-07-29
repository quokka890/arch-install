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
    sgdisk -Z "${selected_disk}"
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
    if [[ "$selected_disk" =~ ^/dev/sd ]]; then
        export partition1="${selected_disk}1"
        export partition="${selected_disk}2"
    elif [[ "$selected_disk" =~ ^/dev/nvme ]]; then
        export partition1="${selected_disk}p1"
        export partition2="${selected_disk}p2"
    else
       error "Unknown disk type: $selected_disk"
    fi

    if [[ $encryption == "true" ]]; then
        export partition2=$CRYPTROOT
    fi
}