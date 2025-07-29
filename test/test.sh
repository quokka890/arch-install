#!/usr/bin/env bash
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$dir/../utils/logger.sh"
source "$dir/../setup/run.sh"
log "Running setup" "confirm"
mkdir -p /mnt/root/installscript
cp -r "$dir" /mnt/root/installscript
chmod +x /mnt/root/installscript/setup/run.sh
sudo arch-chroot /mnt /root/installscript/setup/run.sh
setup
