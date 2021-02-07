#!/bin/bash

set -euxo pipefail

readonly APT_GET=("sudo" "DEBIAN_FRONTEND=noninteractive" "apt-get")

# Remove dangling packages
"${APT_GET[@]}" autoremove --purge -qq

# Clean apt cache
"${APT_GET[@]}" clean

# Clean npm cache
sudo npm cache clean --force

# Clean previous crash-reports
shopt -s dotglob
sudo rm -rf /var/crash/* || true

# Clean temp folder
sudo rm -rf /tmp/*
