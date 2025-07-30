#!/usr/bin/env bash
set -eo pipefail
finish() {
    systemctl enable NetworkManager
    exit
}