#!/bin/bash
set -euxo pipefail

APT_GET="sudo DEBIAN_FRONTEND=noninteractive apt-get"

$APT_GET update
$APT_GET dist-upgrade -yq
$APT_GET install -yq ubuntu-desktop
