#!/usr/bin/env bash

set -euxo pipefail

vagrant destroy -f
vagrant box update
vagrant up
vagrant package --vagrantfile src/Vagrantfile
vagrant box add --force test package.box
rm -f package.box
mkdir test || true
pushd test
vagrant init test
vagrant up
echo
read -rsn1 -p "Press any key to continue . . ."
echo
vagrant destroy -f
vagrant box remove test
popd
rm -rf test
