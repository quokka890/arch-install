#!/usr/bin/env bash
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$dir/../setup/run.sh"
sudo arch-chroot /mnt /root/installscript/setup/run.sh
setup
