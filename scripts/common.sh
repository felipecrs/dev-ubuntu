#!/bin/bash

log() {
	echo "$@" >&2
}

c() {
	log "+" "$@"
	"$@" >&2
}

readonly CURL=("curl" "-fsSL")
readonly VAGRANT_CLOUD_URL="https://app.vagrantup.com"
readonly VAGRANT_CLOUD_API_URL="${VAGRANT_CLOUD_URL}/api/v1"
