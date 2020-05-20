#!/bin/bash
set -euxo pipefail

APT_GET="sudo DEBIAN_FRONTEND=noninteractive apt-get"

# Remove dangling packages
$APT_GET autoremove --purge -qq

# Clean apt cache
$APT_GET clean

# Clean previous crash-reports
shopt -s dotglob
sudo rm -rf /var/crash/* || true

# Clean temp folder
sudo rm -rf /tmp/*
