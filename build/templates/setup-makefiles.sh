#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017 The LineageOS Project
# Copyright (C) 2020 Raphielscape LLC. and Haruka LLC.
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=*** FILL IN DEVICE ****
VENDOR=*** FILL IN VENDOR ****

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$MY_DIR" ]]; then MY_DIR="$PWD"; fi

HENTAI_ROOT="$MY_DIR"/../../..

HELPER="$HENTAI_ROOT"/vendor/hentai/build/tools/extract_utils.sh
if [ ! -f "$HELPER" ]; then
    echo "Unable to find helper script at $HELPER"
    exit 1
fi
. "$HELPER"

# Initialize the helper
setup_vendor "$DEVICE" "$VENDOR" "$HENTAI_ROOT"

# Warning headers and guards
write_headers

write_makefiles "$MY_DIR"/proprietary-files.txt

# Finish
write_footers
