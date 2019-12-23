#!/bin/bash -euo pipefail

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

vagrant cloud auth login
vagrant cloud publish --force "$box" "$version" "$provider" "$file"
${__dir}/test_deployed_box.sh
vagrant cloud release "$box" "$version"
