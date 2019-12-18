#!/bin/bash

set -ex
APT_GET="sudo DEBIAN_FRONTEND=noninteractive apt-get"

# Remove old version
$APT_GET remove -y virtualbox-guest-utils virtualbox-guest-x11

# Install dependencies
$APT_GET update
$APT_GET install -y curl linux-headers-$(uname -r) build-essential dkms

## Fetch latest version
BASE_URL="https://download.virtualbox.org/virtualbox"
VERSION="$(curl -fsSL "${BASE_URL}/LATEST-STABLE.TXT")"

## Install
ADDITIONS_ISO="VBoxGuestAdditions_${VERSION}.iso"
ADDITIONS_PATH="/media/VBoxGuestAdditions"
wget --quiet "${BASE_URL}/${VERSION}/${ADDITIONS_ISO}"
sudo mkdir "${ADDITIONS_PATH}"
sudo mount -o loop,ro "${ADDITIONS_ISO}" "${ADDITIONS_PATH}"
sudo "${ADDITIONS_PATH}/VBoxLinuxAdditions.run" || [ "$?" = 2 ] && true || false
rm "${ADDITIONS_ISO}"
sudo umount "${ADDITIONS_PATH}"
sudo rmdir "${ADDITIONS_PATH}"
