#!/usr/bin/env bash
set -eo pipefail
preinstall() {
    local dir
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$dir/../functions/preinstall/preliminary_checks.sh"
    source "$dir/01_partition.sh"
    source "$dir/02_format.sh"
    source "$dir/03_mount.sh"
    source "$dir/04_base.sh"
    run_checks
    partition
    format
    mount_filesystem
    install_base
    log "Running setup" "confirm"
mkdir -p /mnt/root/installscript
cp -r "$dir/../" /mnt/root/installscript
log "Entering chroot"
chmod +x /mnt/root/installscript/setup/*.sh
arch-chroot /mnt /root/installscript/setup/run.sh
}


