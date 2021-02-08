#!/bin/bash

set -euxo pipefail

readonly APT_GET=("sudo" "DEBIAN_FRONTEND=noninteractive" "apt-get")

# Remove old versions if exist
"${APT_GET[@]}" remove -y virtualbox-guest-utils virtualbox-guest-x11

# Install dependencies
"${APT_GET[@]}" update
"${APT_GET[@]}" install -yq linux-generic build-essential dkms

## Fetch latest version
BASE_URL="https://download.virtualbox.org/virtualbox"
VERSION="$(wget -qO- "${BASE_URL}/LATEST.TXT")"

## Install
ADDITIONS_ISO="VBoxGuestAdditions.iso"
ADDITIONS_PATH="/media/VBoxGuestAdditions"
wget -q -O "${ADDITIONS_ISO}" "${BASE_URL}/${VERSION}/${ADDITIONS_ISO}"
sudo mkdir -p "${ADDITIONS_PATH}"
sudo mount -o loop,ro "${ADDITIONS_ISO}" "${ADDITIONS_PATH}"
sudo "${ADDITIONS_PATH}/VBoxLinuxAdditions.run" || if [[ $? -eq 2 ]]; then true; else false; fi
sudo umount "${ADDITIONS_PATH}"
rm -f "${ADDITIONS_ISO}"
sudo rm -rf "${ADDITIONS_PATH}"
