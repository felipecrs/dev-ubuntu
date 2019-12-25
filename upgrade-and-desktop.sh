#!/bin/bash

set -ex

APT_GET="sudo DEBIAN_FRONTEND=noninteractive apt-get"

$APT_GET update
$APT_GET dist-upgrade -qq
$APT_GET install -qq ubuntu-desktop
