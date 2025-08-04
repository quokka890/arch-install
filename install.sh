#!/usr/bin/env bash
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$dir/utils/logger.sh"
source "$dir/preinstall/run.sh"

#status "Running preinstall" "confirm"
#preinstall

status "Running setup" "confirm"
mkdir -p /mnt/root/installscript
cp -r "$dir/" /mnt/root/installscript
status "Entering chroot"
scriptdir="/mnt/root/installscript/setup/"
for script in "$scriptdir"/*.sh; do
    script_name="$(basename "$script")"
    base_name="${script_name%%.sh}"          # Remove .sh extension
    function_name="configure_${base_name#*_}" # Strip numeric prefix like 01_, then prepend "configure_"

    # shellcheck disable=SC1090
    chmod +x "$script"
    source "$script"
    if declare -F "$function_name" > /dev/null; then
        "$function_name"
    else
        error "Function $function_name not found in $script"
        exit 1
    fi
done
