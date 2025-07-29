#!/usr/bin/env bash
set -euo pipefail
finish() {
    systemctl enable NetworkManager
    exit
    umount -R /mnt
    reboot
}