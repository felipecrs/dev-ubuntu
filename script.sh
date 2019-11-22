#!/bin/bash

set -x

APT_GET="sudo DEBIAN_FRONTEND=noninteractive apt-get"

# Reset machine-id to be able to enable Livepatch
sudo rm /etc/machine-id /var/lib/dbus/machine-id && sudo systemd-machine-id-setup

# Add Git repository
sudo add-apt-repository -y ppa:git-core/ppa

$APT_GET update
$APT_GET --with-new-pkgs -y upgrade

# dkms: Required for VirtualBox Guest Additions
$APT_GET install -y curl \
                    git \
                    build-essential \
                    python3-pip \
                    python-pip \
                    dkms

# Install/update VirtualBox Guest Additions
## Check version installed before
echo "VBox Guest Additions (before update)"
lsmod | grep -io vboxguest | xargs modinfo | grep -iw version
BASE_URL="https://download.virtualbox.org/virtualbox"
VERSION=$(curl -fsS ${BASE_URL}/LATEST-STABLE.TXT)
curl -fsS ${BASE_URL}/${VERSION}/VBoxGuestAdditions_${VERSION}.iso -o VBoxGuestAdditions.iso
sudo mkdir -p /mnt/cdrom
sudo mount -o loop ./VBoxGuestAdditions.iso /mnt/cdrom
yes | sudo /mnt/cdrom/VBoxLinuxAdditions.run --nox11
sudo umount /mnt/cdrom
rm -r /mnt/cdrom
rm ./VBoxGuestAdditions.iso
## Check version installed
echo "VBox Guest Additions (after update)"
lsmod | grep -io vboxguest | xargs modinfo | grep -iw version

curl -fsS -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
$APT_GET install -y ./google-chrome-stable_current_amd64.deb
rm ./google-chrome-stable_current_amd64.deb

sudo snap install code --classic
sudo snap install postman
sudo snap install jq
sudo snap install ruby --classic
sudo snap install node --channel=12/stable --classic

sudo npm install -g npm

# sudo gem install haste

# Install Docker
curl -fsSL https://get.docker.com | sudo sh
# sudo groupadd docker
sudo usermod -aG docker vagrant
newgrp docker

# Install argbash
# $APT_GET install -y autoconf
# curl -s https://api.github.com/repos/matejak/argbash/releases/latest | jq .tarball_url | xargs wget -O argbash.tar.gz
# tar -zxvf argbash.tar.gz
# pushd matejak-argbash-*/resources
# sudo make install PREFIX=/usr INSTALL_COMPLETION=yes
# popd
# rm ./argbash.tar.gz

# Install argbash-docker
printf '%s\n' '#!/bin/bash' 'docker run -it --rm -v "$(pwd):/work" -u $(id -u):$(id -g) matejak/argbash "$@"' | sudo tee /usr/bin/argbash
printf '%s\n' '#!/bin/bash' 'docker run -it -e PROGRAM=argbash-init --rm -v "$(pwd):/work" -u $(id -u):$(id -g) matejak/argbash "$@"' | sudo tee /usr/bin/argbash-init
sudo chmod +x /usr/bin/argbash /usr/bin/argbash-init

# Remove password from Login keyring
# wget -q http://launchpadlibrarian.net/346793276/python-gnomekeyring_2.32.0+dfsg-4build1_amd64.deb
# $APT_GET install -y ./python-gnomekeyring_2.32.0+dfsg-4build1_amd64.deb
# python -c "import gnomekeyring;gnomekeyring.change_password_sync('login', 'vagrant', '');"
# $APT_GET remove -y python-gnomekeyring
# rm ./python-gnomekeyring_2.32.0+dfsg-4build1_amd64.deb
# $APT_GET autoremove -y
