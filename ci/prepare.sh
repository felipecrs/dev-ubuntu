#!/bin/bash

# This script is intended to be sourced by another

if [ "$TRAVIS_BRANCH" = master ]; then
	BASE_URL="https://app.vagrantup.com/api/v1/box/felipecassiors/ubuntu1804-4dev"
else
	BASE_URL="https://app.vagrantup.com/api/v1/box/felipecassiors/ubuntu1804-4dev-dev"
fi
VERSION="$(jq -r ".version" package.json)"
DESCRIPTION="$CHANGELOG"
VERSION_BASE_URL="$BASE_URL/version/$VERSION"
PROVIDER="virtualbox"
PROVIDER_BASE_URL="$VERSION_BASE_URL/provider/$PROVIDER"
FILE="package.box"
