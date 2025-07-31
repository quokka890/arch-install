#!/usr/bin/env bash
set -euo pipefail
finish() {
    systemctl enable NetworkManager
    log "Setup successful"
    exit
}