#!/bin/bash
set -euxo pipefail

APT_GET="sudo DEBIAN_FRONTEND=noninteractive apt-get"

# Remove dangling packages
$APT_GET autoremove --purge -qq

# Clean apt cache
$APT_GET clean

# Clean previous crash-reports
sudo rm /var/crash/*

# Clean temp folder
shopt -s dotglob
sudo rm -rf /tmp/*
