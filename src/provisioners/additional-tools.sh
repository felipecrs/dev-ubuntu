#!/bin/bash

set -euxo pipefail

readonly APT_GET=("sudo" "DEBIAN_FRONTEND=noninteractive" "apt-get")
readonly APT_GET_INSTALL=("${APT_GET[@]}" "install" "-yq")
readonly CURL=("curl" "-fsSL")

"${APT_GET[@]}" update
"${APT_GET_INSTALL[@]}" curl

# Add Git repository
sudo add-apt-repository --no-update -y ppa:git-core/ppa
# Add VS Code repository
"${CURL[@]}" https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo add-apt-repository --no-update -y "deb https://packages.microsoft.com/repos/code stable main"
# Add Adopt OpenJDK repository
"${CURL[@]}" https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add -
sudo add-apt-repository --no-update -y https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
# Add Kubernetes repository
"${CURL[@]}" https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo add-apt-repository --no-update -y "deb https://apt.kubernetes.io/ kubernetes-xenial main"
# Add Yarn repository
"${CURL[@]}" https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
sudo add-apt-repository --no-update -y "deb https://dl.yarnpkg.com/debian/ stable main"
# Add Node repository
"${CURL[@]}" https://deb.nodesource.com/setup_lts.x | sudo -E bash -

"${APT_GET_INSTALL[@]}" \
	git \
	python3-pip \
	adoptopenjdk-8-hotspot \
	gnome-shell-extensions \
	bash-completion \
	fonts-powerline \
	linux-generic \
	build-essential \
	dkms \
	jq \
	code \
	shellcheck \
	kubectl \
	nodejs \
	yarn

# Set aliases for python and pip
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1
sudo update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1

wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
"${APT_GET_INSTALL[@]}" ./google-chrome-stable_current_amd64.deb
rm -f google-chrome-stable_current_amd64.deb

# Install Postman
sudo snap install postman

# Upgrade NPM
sudo npm install -g npm@latest

# Install Docker
"${CURL[@]}" https://get.docker.com | sudo -E sh -
sudo usermod -aG docker vagrant

# Install Docker Compose
version=$("${CURL[@]}" https://api.github.com/repos/docker/compose/releases/latest | jq .tag_name -er)
sudo "${CURL[@]}" -o /usr/local/bin/docker-compose "https://github.com/docker/compose/releases/download/${version}/docker-compose-$(uname -s)-$(uname -m)"
sudo chmod +x /usr/local/bin/docker-compose

# Install KinD
version=$("${CURL[@]}" https://api.github.com/repos/kubernetes-sigs/kind/releases/latest | jq .tag_name -er)
sudo "${CURL[@]}" -o /usr/local/bin/kind "https://github.com/kubernetes-sigs/kind/releases/download/${version}/kind-$(uname -s)-amd64"
sudo chmod +x /usr/local/bin/kind

# Install Helm 3
"${CURL[@]}" https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | sudo -E bash -

# Install argbash
# "${APT_GET[@]}" install -y autoconf
# curl -s https://api.github.com/repos/matejak/argbash/releases/latest | jq .tarball_url | xargs wget -O argbash.tar.gz
# tar -zxvf argbash.tar.gz
# pushd matejak-argbash-*/resources
# sudo make install PREFIX=/usr INSTALL_COMPLETION=yes
# popd
# rm ./argbash.tar.gz

# Install argbash-docker
printf '%s\n' '#!/bin/bash' 'docker run -it --rm -v "$(pwd):/work" -u "$(id -u):$(id -g)" matejak/argbash "$@"' | sudo tee /usr/local/bin/argbash
printf '%s\n' '#!/bin/bash' 'docker run -it -e PROGRAM=argbash-init --rm -v "$(pwd):/work" -u "$(id -u):$(id -g)" matejak/argbash "$@"' | sudo tee /usr/local/bin/argbash-init
sudo chmod +x /usr/local/bin/argbash /usr/local/bin/argbash-init

# Install Remote - Containers extension for VS Code
code --install-extension ms-vscode-remote.remote-containers
