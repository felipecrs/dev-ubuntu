#!/bin/bash

set -euxo pipefail

readonly APT_GET=("sudo" "DEBIAN_FRONTEND=noninteractive" "apt-get")

"${APT_GET[@]}" update
"${APT_GET[@]}" dist-upgrade -yq
"${APT_GET[@]}" install -yq ubuntu-desktop

# Reset machine-id to be able to enable Livepatch
# sudo rm /etc/machine-id /var/lib/dbus/machine-id && sudo systemd-machine-id-setup
