#!/bin/bash

set -euo pipefail

echo "Validating Vagrantfile..."
vagrant validate
echo

echo "Validating src/Vagrantfile..."
cd src

# Workaround for validating Vagrantfiles without config.vm.box.
# See https://github.com/hashicorp/vagrant/issues/12125
if ! output="$(vagrant validate 2>&1)"; then
	exit_code=$?

	expected_output="$(
		cat <<-'EOF'
			There are errors in the configuration of this machine. Please fix
			the following errors and try again:

			vm:
			* A box must be specified.
		EOF
	)"

	# Compare disregarding CR line endings characters so it works on Windows
	if [[ "${output//$'\r'/}" == "${expected_output//$'\r'/}" ]]; then
		echo "src/Vagrantfile validated successfully."
	else
		echo "$output"
		exit $exit_code
	fi
fi
cd - >/dev/null
