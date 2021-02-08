#!/bin/bash

load_config() {
	readonly VERSION="${VERSION:-$(jq -er '.version' package.json)}"
	readonly CHANNEL="${CHANNEL:-"latest"}"
	# @felipecrs/dev-ubuntu from package.json becomes felipecrs/dev-ubuntu
	NAME="${NAME:-$(jq -er '.name |  sub("^@"; "")' package.json)}"
	if [[ "${CHANNEL}" != "latest" ]]; then
		# felipecrs/dev-ubuntu -> felipecrs/dev-ubuntu-alpha
		NAME="${NAME}-${CHANNEL}"
	fi
	readonly NAME
	readonly PROVIDER="${PROVIDER:-"virtualbox"}"
	readonly DESCRIPTION="${DESCRIPTION:-$(jq -er '.description' package.json)}"
	readonly RELEASE_NOTES="${RELEASE_NOTES:-}"

	readonly FILE="${FILE:-package.box}"
	readonly CHECKSUM=$(md5sum "${FILE}" | cut -d " " -f 1)

	readonly USERNAME="${NAME%/*}"
	readonly BOX_BASENAME="${NAME#*/}"
	readonly VAGRANT_CLOUD_TOKEN="${VAGRANT_CLOUD_TOKEN?}"

	readonly BOX_BASE_URL="${VAGRANT_CLOUD_API_URL}/box/${NAME}"
	readonly VERSION_BASE_URL="${BOX_BASE_URL}/version/${VERSION}"
	readonly PROVIDER_BASE_URL="${VERSION_BASE_URL}/provider/${PROVIDER}"
}

update_box() {
	log
	log "Updating box on Vagrant Cloud..."

	if ! "${CURL[@]}" \
		--header "Content-Type: application/json" \
		--header "Authorization: Bearer ${VAGRANT_CLOUD_TOKEN}" \
		--request PUT \
		"${BOX_BASE_URL}" \
		--data "$(
			jq -n \
				--arg name "${BOX_BASENAME}" \
				--arg description "${DESCRIPTION}" \
				'
				{
					"box": {
						"name": $name,
						"short_description": $description,
						"is_private": false
					}
				}
				'
		)" | jq . >&2; then

		log "Failed, trying to update instead..."
		"${CURL[@]}" \
			--header "Content-Type: application/json" \
			--header "Authorization: Bearer ${VAGRANT_CLOUD_TOKEN}" \
			"${VAGRANT_CLOUD_API_URL}/boxes" \
			--data "$(
				jq -n \
					--arg username "${USERNAME}" \
					--arg name "${BOX_BASENAME}" \
					--arg description "${DESCRIPTION}" \
					'
			{
				"box": {
					"username": $username,
					"name": $name,
					"short_description": $description,
					"is_private": false
				}
			}
			'
			)" | jq . >&2
	fi

}

delete_version() {
	log
	log "Deleting version in Vagrant Cloud..."

	"${CURL[@]}" \
		--header "Authorization: Bearer ${VAGRANT_CLOUD_TOKEN}" \
		--request DELETE \
		"${VERSION_BASE_URL}" | jq . >&2
}

create_version_cmd() {
	"${CURL[@]}" \
		--header "Content-Type: application/json" \
		--header "Authorization: Bearer ${VAGRANT_CLOUD_TOKEN}" \
		"${BOX_BASE_URL}/versions" \
		--data "$(
			jq -n \
				--arg version "${VERSION}" \
				--arg description "${RELEASE_NOTES}" \
				'
			{
				"version": {
					"version": $version,
					"description": $description
				}
			}
			'
		)" | jq . >&2
}

create_version() {
	log
	log "Creating version in Vagrant Cloud..."

	if ! create_version_cmd; then
		log "Failed. Trying to delet it first..."
		if delete_version; then
			log "Trying to create it again..."
			create_version_cmd
		else
			log "Failed."
			return 1
		fi
	fi
}

create_provider() {
	log
	log "Creating provider in Vagrant Cloud..."

	"${CURL[@]}" \
		--header "Content-Type: application/json" \
		--header "Authorization: Bearer ${VAGRANT_CLOUD_TOKEN}" \
		"${VERSION_BASE_URL}/providers" \
		--data "$(
			jq -n \
				--arg provider "${PROVIDER}" \
				--arg checksum "${CHECKSUM}" \
				'
			{
				"provider": {
					"name": $provider,
					"checksum_type": "md5",
					"checksum": $checksum
				}
			}
			'
		)" | jq . >&2
}

get_upload_url() {
	"${CURL[@]}" \
		--header "Authorization: Bearer ${VAGRANT_CLOUD_TOKEN}" \
		"${PROVIDER_BASE_URL}/upload" \
		| jq -er '.upload_path'
}

upload_box_cmd() {
	local -r upload_url="$1"

	curl -fL \
		--request PUT \
		--upload-file "${FILE}" \
		"${upload_url}" \
		| jq . >&2
}

upload_box() {
	log
	log "Fetching upload url..."

	local upload_url
	if upload_url=$(get_upload_url); then

		log "Uploading box..."
		if ! upload_box_cmd "${upload_url}"; then

			log "Failed, but this can be a known server issue."
			log "Sleeping for some time so the box becomes available on the Vagrant Cloud..."
			c sleep 5m
		fi
	else
		log "Failed."
		return 1
	fi
}

release() {
	log
	log "Releasing version on Vagrant Cloud..."

	"${CURL[@]}" \
		--header "Authorization: Bearer ${VAGRANT_CLOUD_TOKEN}" \
		"${VERSION_BASE_URL}/release" \
		--request PUT \
		| jq . >&2
}

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "${SCRIPT_DIR}/common.sh"

load_config

log "Publishing the following box:"
log "NAME    = ${NAME}"
log "VERSION = ${VERSION}"
log "PROVIDER = ${PROVIDER}"
log "DESCRIPTION = ${DESCRIPTION}"
log "RELEASE_NOTES = ${RELEASE_NOTES}"
log

update_box

create_version

if create_provider && upload_box && "${SCRIPT_DIR}/test_release.sh" "${NAME}" "${VERSION}" "${PROVIDER}"; then
	log "Test passed."
	release

	log
	log "Printing Semantic Release ouput..."
	echo '{"name": "Vagrant Cloud", "url": "'"${VAGRANT_CLOUD_URL}/${USERNAME}/boxes/${BOX_BASENAME}/versions/${VERSION}"'"}'
else
	log "Failed."
	delete_version
	exit 1
fi
