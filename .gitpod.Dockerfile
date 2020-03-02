FROM gitpod/workspace-full

SHELL [ "/bin/bash", "-c" ]

# Install shellcheck
RUN brew install shellcheck

# Install commitizen
RUN npm install -g commitizen

# Install Vagrant
# Use it to validate Vagrantfile: `vagrant validate -p`
RUN set -exo pipefail; \
  wget -qO- https://raw.githubusercontent.com/felipecassiors/scripts/master/install_vagrant.sh | bash

# More information: https://www.gitpod.io/docs/42_config_docker/
