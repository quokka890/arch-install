#!/usr/bin/env bash
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$dir/utils/logger.sh"
source "$dir/preinstall/run.sh"
source "$dir/setup/run.sh"

log "Running preinstall" "confirm"
preinstall

log "Running setup" "confirm"
mkdir -p /mnt/root/installscript
cp -r "$dir/../" /mnt/root/installscript
chmod +x /mnt/root/installscript/setup/*.sh
arch-chroot /mnt /root/installscript/setup/setup_croot.sh
