#!/bin/bash

set -euxo pipefail

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

box='felipecrs/dev-ubuntu-test'
version="$(date +'%Y%m.%d.%H%M')"
provider='virtualbox'
file='package.box'
description="[**View source code in GitHub**](https://github.com/felipecrs/dev-ubuntu/commit/$(git rev-parse HEAD))"
short_description='Testing releases from https://github.com/felipecrs/dev-ubuntu'
checksum="$(md5sum "$file" | cut -d " " -f 1)"

vagrant cloud auth login
vagrant cloud publish --force \
	--checksum-type md5 \
	--checksum "$checksum" \
	--description "$description" \
	--short-description "$short_description" \
	"$box" "$version" "$provider" "$file" ||
	{
		echo "Ignoring fail, this is probably a server issue."
		echo "Sleeping some time for the box to be available on cloud..."
		sleep 5m
	}
export PROVIDER_BASE_URL="https://app.vagrantup.com/api/v1/box/$box/version/$version/provider/$provider"
"${__dir}/test_deployed_box.sh"
yes | vagrant cloud version release "$box" "$version"
