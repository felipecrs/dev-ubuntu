#/bin/bash -v

set -e -o pipefail

if git describe --contains &> /dev/null; then # Test if current commit is already tagged
    echo "Running upon a tagged commit"
    PREVIOUSLY_TAGGED_COMMIT=true
    GIT_TAG="$(git tag --points-at)"
    VERSION=${GIT_TAG#v*}
else
    echo "Running upon a untagged commit, bumping patch number and tagging it..."
    PREVIOUSLY_TAGGED_COMMIT=false
    GIT_TAG=$(bump patch --dry-run)
    VERSION=${GIT_TAG#v*}
    git config --local user.email "travis@travis-ci.org"
    git config --local user.name "Travis CI"
    git tag -a "$GIT_TAG" -m "Version $VERSION
Available on https://app.vagrantup.com/felipecassiors/boxes/ubuntu1804-4dev/versions/$VERSION
Built by Travis on $TRAVIS_BUILD_WEB_URL"
fi

BASE_URL="https://app.vagrantup.com/api/v1/box/felipecassiors/ubuntu1804-4dev"
VERSION_BASE_URL="$BASE_URL/version/$VERSION"
PROVIDER="virtualbox"
PROVIDER_BASE_URL="$VERSION_BASE_URL/provider/$PROVIDER"

echo "Calculating changelog..."
latest_version="$(git tag | sort -r --version-sort | head -1)"
second_latest_version="$(git tag | sort -r --version-sort | head -2 | awk '{split($0, tags, "\n")} END {print tags[1]}')"
DESCRIPTION="## Changelog

$(git log $second_latest_version...$latest_version  --pretty=format:"- [%h](http://github.com/felipecassiors/ubuntu1804-4dev/commit/%H) %s")

[**Built by Travis**]($TRAVIS_BUILD_WEB_URL)

[**View source code in GitHub**](https://github.com/felipecassiors/ubuntu1804-4dev/tree/$GIT_TAG)"

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
            --arg checksum "$(md5sum package.box | cut -d " " -f 1)" \
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

fetch_upload_url() {
    echo "Fetching upload url..." && \
    upload_path="$(curl -fsS \
        --header "Authorization: Bearer $VAGRANT_CLOUD_TOKEN" \
        "$PROVIDER_BASE_URL/upload" \
        | jq -r .upload_path)"
}

upload_box() {
    echo "Uploading box..."
    curl -f \
        --request PUT \
        --upload-file package.box \
        "$upload_path" || { 
            echo "Ignoring fail, this is probably a server issue."
            echo "Sleeping some time for the box to be available on cloud..."
            sleep 5m
        }
}

test_deployed_box() {
    (       
        echo "Testing the deployed box..." && \
        set -x && \
        echo "  Fetching download url..." && \
        download_url=$(curl -fsS \
            --header "Authorization: Bearer $VAGRANT_CLOUD_TOKEN" \
            "$PROVIDER_BASE_URL" \
            | jq -r .download_url) && \
        
        echo "  Adding box to vagrant..." && \
        vagrant box add test-deploy "$download_url" && \
        
        echo "  Performing vagrant init and up..." && \
        ( rmdir temp/ &> /dev/null; mkdir temp/ ) && \
        pushd temp/ > /dev/null && \
        vagrant init test-deploy && \
        vagrant up && \
        popd > /dev/null
    )
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
    fetch_upload_url && \
    # uploading big box is returning error however the box appears to be uploaded properly,
    # so we continue: if the test succeed, we're in business.
    upload_box && \
    test_deployed_box
} || {
    echo "Deploy failed"
    delete_version
    exit 1
}

echo "Deploy suceeded"
release_version

if [ "$PREVIOUSLY_TAGGED_COMMIT" = false ]; then
    echo "Pushing tag to GitHub..."
    git remote add origin-tags https://${GITHUB_TOKEN}@github.com/felipecassiors/ubuntu1804-4dev.git
    # Force is to replace the tag on remote if it already exists
    git push origin-tags --tags --force
fi
