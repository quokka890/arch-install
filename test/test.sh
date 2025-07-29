#!/usr/bin/env bash
ROOT_UUID=$(blkid -s UUID -o value "/dev/nvme0n1p2")
echo $ROOT_UUID