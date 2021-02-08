#!/bin/bash

load_config() {
	readonly VAGRANTFILE="${VAGRANTFILE:-"src/Vagrantfile"}"
	readonly FILE="${FILE:-package.box}"
}

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "${SCRIPT_DIR}/common.sh"

load_config

log "Exporting box to ${FILE}..."
c vagrant package --vagrantfile "${VAGRANTFILE}" --output "${FILE}"

log "Deleting VM to clean up some space..."
c vagrant destroy -f
