#/bin/bash
set -euo pipefail

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ${__dir}/prepare.sh
source ${__dir}/curl_deploy.sh
source ${__dir}/push_tags.sh
