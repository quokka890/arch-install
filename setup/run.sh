#!/usr/bin/env bash
set -eo pipefail
setup() {
    local dir
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    mkdir -p /mnt/root/installscript
    cp -r "$dir/../" /mnt/root/installscript
    chmod +x /mnt/root/installscript/setup/run.sh
    arch-chroot /mnt /root/installscript/setup/run.sh
    source "$dir/01_locale.sh"
    source "$dir/02_users.sh"
    source "$dir/03_bootloader.sh"
    source "$dir/04_finish.sh"
    install_base
}