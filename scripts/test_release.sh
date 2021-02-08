#!/bin/bash

load_config() {
	readonly NAME="${1:-${NAME:-$(jq -er '.name | sub("^@"; "")' package.json)}}"
	readonly VERSION="${2:-${VERSION:-$(jq -er '.version' package.json)}}"
	readonly PROVIDER="${3:-${PROVIDER:-virtualbox}}"
}

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "${SCRIPT_DIR}/common.sh"

load_config "$@"

log "Testing the following box:"
log "NAME    = ${NAME}"
log "VERSION = ${VERSION}"
log "PROVIDER = ${PROVIDER}"
log

log "  Fetching download url..."
readonly DOWNLOAD_URL=$("${CURL[@]}" "https://app.vagrantup.com/api/v1/box/${NAME}/version/${VERSION}/provider/${PROVIDER}" | jq -er '.download_url')

log "  Adding box to vagrant..."
readonly TEST_BOX="test-deploy"
c vagrant box add --force "$TEST_BOX" "${DOWNLOAD_URL}"

log "  Performing vagrant init and up..."
readonly TEST_FOLDER="temp/"
c rm -rf "$TEST_FOLDER"
c mkdir -p "$TEST_FOLDER"

cd "$TEST_FOLDER"

{
	c vagrant init "$TEST_BOX" && c vagrant up
} && ret=$? || ret=$?

log "  Cleaning up..."
c vagrant destroy --force || true
# c vagrant box remove --force "$TEST_BOX"

cd - >/dev/null
c rm -rf "$TEST_FOLDER"

exit $ret
