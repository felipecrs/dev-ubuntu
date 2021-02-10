#!/bin/bash

# This script is intended to be sourced by another

if [ "$TRAVIS_BRANCH" = master ]; then
	BASE_URL="https://app.vagrantup.com/api/v1/box/felipecrs/dev-ubuntu-20.04"
else
	BASE_URL="https://app.vagrantup.com/api/v1/box/felipecrs/dev-ubuntu-20.04-alpha"
fi
VERSION="$(jq -r ".version" package.json)"
DESCRIPTION="$CHANGELOG"
VERSION_BASE_URL="$BASE_URL/version/$VERSION"
PROVIDER="virtualbox"
PROVIDER_BASE_URL="$VERSION_BASE_URL/provider/$PROVIDER"
FILE="package.box"
