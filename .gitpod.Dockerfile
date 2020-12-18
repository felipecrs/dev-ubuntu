FROM gitpod/workspace-full

# Install commitizen
RUN npm install -g commitizen

# Install Vagrant
# Use it to validate Vagrantfile:
#   vagrant validate -p
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/felipecrs/scripts/master/install_vagrant.sh)"
