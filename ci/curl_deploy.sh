#/bin/bash

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

create_version() {
	echo "Creating version $VERSION in Vagrant Cloud..." && \
	curl -fsS \
		--header "Content-Type: application/json" \
		--header "Authorization: Bearer $VAGRANT_CLOUD_TOKEN" \
		"$BASE_URL/versions" \
		--data "$(jq -n \
			--arg version "$VERSION" \
			--arg description "$DESCRIPTION" \
			'
			{
				"version": {
					"version": $version,
					"description": $description
				}
			}
			'
		)" \
		| jq .
}

delete_version() {
	echo "Deleting version $VERSION in Vagrant Cloud..." && \
	curl -fsS \
		--header "Authorization: Bearer $VAGRANT_CLOUD_TOKEN" \
		--request DELETE \
		"$VERSION_BASE_URL" \
		| jq .
}

create_provider() {
	echo "Creating provider $VERSION in Vagrant Cloud..." && \
	curl -fsS \
		--header "Content-Type: application/json" \
		--header "Authorization: Bearer $VAGRANT_CLOUD_TOKEN" \
		"$VERSION_BASE_URL/providers" \
		--data "$(jq -n \
			--arg provider "$PROVIDER" \
			--arg checksum "$(md5sum "$FILE" | cut -d " " -f 1)" \
			'
			{
				"provider": {
					"name": $provider,
					"checksum_type": "md5",
					"checksum": $checksum
				}
			}
			'
		)" \
		| jq .
}

upload_box() {
	echo "Fetching upload url..." && \
	local readonly UPLOAD_PATH="$(curl -fsS \
		--header "Authorization: Bearer $VAGRANT_CLOUD_TOKEN" \
		"$PROVIDER_BASE_URL/upload" \
		| jq -r .upload_path)" && \

	echo "Uploading box..." && \
	curl -f \
		--request PUT \
		--upload-file "$FILE" \
		"$UPLOAD_PATH" || {
			echo "Ignoring fail, this is probably a server issue."
			echo "Sleeping some time for the box to be available on cloud..."
			sleep 5m
		}
}

release_version() {
	echo "Releasing the version on Vagrant Cloud..." && \
	curl -fsS \
		--header "Authorization: Bearer $VAGRANT_CLOUD_TOKEN" \
		"$VERSION_BASE_URL/release" \
		--request PUT \
		| jq .
}

echo "Deploying version $VERSION to Vagrant Cloud..."
echo "URL: $VERSION_BASE_URL"

# Try to delete the version if it exist
{
	create_version
} || {
	echo "Failed creating version, trying to delete it first..."
	delete_version
	create_version
}

{
	create_provider && \
	upload_box && \
	source ${__dir}/test_deployed_box.sh
} || {
	echo "Deploy failed"
	delete_version
	exit 1
}

echo "Deploy suceeded"
release_version
