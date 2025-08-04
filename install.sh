#!/usr/bin/env bash
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$dir/utils/logger.sh"
source "$dir/preinstall/run.sh"

status "Running preinstall" "confirm"
preinstall

status "Running setup" "confirm"
mkdir -p /mnt/root/installscript
cp -r "$dir/" /mnt/root/installscript
status "Entering chroot"
scriptdir="/mnt/root/installscript/Arch-Install/setup"
for script in "$scriptdir"/*; do
    script_name="$(basename "$script")"
    base_name="${script_name%%.sh}"          
    live_script="${script#/mnt}"
    function="configure_${base_name#*_}" # strip prefix like 01_, then prepend "configure_"
    # shellcheck disable=SC1090
    chmod +x "$script"
    arch-chroot /mnt /bin/bash -c "
        source $live_script
        if declare -F $function > /dev/null; then
            $function
        else
            echo 'Function $function not found in $script_name' >&2
            exit 1
        fi
    " 
done
