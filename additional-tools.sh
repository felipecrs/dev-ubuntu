#!/bin/bash
set -euxo pipefail

APT_GET="sudo DEBIAN_FRONTEND=noninteractive apt-get"

# Reset machine-id to be able to enable Livepatch
# sudo rm /etc/machine-id /var/lib/dbus/machine-id && sudo systemd-machine-id-setup

# Add Git repository
sudo add-apt-repository -y ppa:git-core/ppa

$APT_GET update

$APT_GET install -qq curl git python3-pip python-pip openjdk-8-jdk gnome-tweaks

wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
$APT_GET install -qq ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

sudo snap install code --classic
sudo snap install postman
sudo snap install jq
sudo snap install ruby --classic
sudo snap install node --channel=12/stable --classic

sudo npm install -g npm

# sudo gem install haste

# Install Docker
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker vagrant
newgrp docker

# Install Docker Compose
VERSION=$(curl -fsL https://api.github.com/repos/docker/compose/releases/latest | jq .name -r)
sudo curl -fsSL "https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install argbash
# $APT_GET install -y autoconf
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
