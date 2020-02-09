#!/bin/bash
set -euxo pipefail

APT_GET="sudo DEBIAN_FRONTEND=noninteractive apt-get"

# Remove old versions
# $APT_GET remove -y virtualbox-guest-utils virtualbox-guest-x11 # We don't need in hashicorp/bionic64

# Install dependencies
$APT_GET update
$APT_GET install -qq "linux-headers-$(uname -r)" build-essential dkms

## Fetch latest version
BASE_URL="https://download.virtualbox.org/virtualbox"
VERSION="$(wget -q -O- "${BASE_URL}/LATEST.TXT")"

## Install
ADDITIONS_ISO="VBoxGuestAdditions_${VERSION}.iso"
ADDITIONS_PATH="/media/VBoxGuestAdditions"
wget -q "${BASE_URL}/${VERSION}/${ADDITIONS_ISO}"
sudo mkdir "${ADDITIONS_PATH}"
sudo mount -o loop,ro "${ADDITIONS_ISO}" "${ADDITIONS_PATH}"
sudo "${ADDITIONS_PATH}/VBoxLinuxAdditions.run" || if [ "$?" = 2 ]; then true; else false; fi
rm "${ADDITIONS_ISO}"
sudo umount "${ADDITIONS_PATH}"
sudo rmdir "${ADDITIONS_PATH}"
