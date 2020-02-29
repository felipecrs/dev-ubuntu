#!/bin/bash
set -euxo pipefail

pushd /tmp/
git clone https://github.com/home-sweet-gnome/dash-to-panel.git
pushd dash-to-panel/
make install
popd
popd

mkdir -p "$HOME/Pictures/Wallpapers/"
wget -q https://w.wallhaven.cc/full/ox/wallhaven-ox19m9.jpg -O "$HOME/Pictures/Wallpapers/wallhaven-ox19m9.jpg"
gsettings set org.gnome.desktop.background picture-uri "file://$HOME/Pictures/Wallpapers/wallhaven-ox19m9.jpg"
gsettings set org.gnome.desktop.screensaver picture-uri "file://$HOME/Pictures/Wallpapers/wallhaven-ox19m9.jpg"

sudo add-apt-repository -y ppa:daniruiz/flat-remix
sudo apt-get update
sudo apt-get install -y gnome-shell-extensions flat-remix flat-remix-gtk flat-remix-gnome

gnome-shell-extension-tool -e user-theme@gnome-shell-extensions.gcampax.github.com
gnome-shell-extension-tool -e dash-to-panel@jderose9.github.com
gsettings set org.gnome.desktop.interface gtk-theme "Flat-Remix-GTK-Blue-Dark-Solid"
gsettings set org.gnome.desktop.interface icon-theme "Flat-Remix-Blue-Dark"
gsettings set org.gnome.shell.extensions.user-theme name "Flat-Remix-Dark-fullPanel"

# Turn off blank screen to do not ask for password every time
# you pass 5 minutes away of the VM
gsettings set org.gnome.desktop.session idle-delay 0

# Turn off animations
gsettings set org.gnome.desktop.interface enable-animations false

# Enable login shell (why isn't enabled by default? Without it the folder)
# $HOME/.local/bin doesn't get added to $PATH, because ~/.profile isn't read.
profile="$(gsettings get org.gnome.Terminal.ProfilesList default)"
profile="${profile:1:-1}"
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" login-shell true

# We set the default favorites. Why anyone would use Rythmbox in the development VM at all?
gsettings set org.gnome.shell favorite-apps "['ubiquity.desktop', 'google-chrome.desktop', 'firefox.desktop', 'org.gnome.Nautilus.desktop', 'code_code.desktop', 'org.gnome.Terminal.desktop', 'postman_postman.desktop', 'org.gnome.Software.desktop']"

# Set VS Code as default editor for Git
git config --global core.editor "code --wait"

# Set VS Code as default merge tool for Git
git config --global merge.tool vscode
git config --global mergetool.vscode.cmd 'code --wait $MERGED'

# Set VS Code as default diff tool for Git
git config --global diff.tool vscode
git config --global difftool.vscode.cmd 'code --wait --diff $LOCAL $REMOTE'

# Disable graphical password prompt for Vagrant
cat <<-EOT | sudo tee -a /var/lib/polkit-1/localauthority/50-local.d/disable-passwords.pkla
	[All]
	Identity=unix-user:vagrant
	Action=*
	ResultActive=yes
EOT

# Enable Automatic Login (but will still ask for login password when trying to unlock the keyring - such as opening Google Chrome)
# sudo sed -i 's/#  AutomaticLoginEnable = true/  AutomaticLoginEnable = true/g' /etc/gdm3/custom.conf
# sudo sed -i 's/#  AutomaticLogin = user1/  AutomaticLogin = vagrant/g' /etc/gdm3/custom.conf

# Add Open in Code to context menu
wget -qO- https://raw.githubusercontent.com/harry-cpp/code-nautilus/master/install.sh | bash

# Install Bash-it
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
~/.bash_it/install.sh --silent

# Configure Git to save passwords using keyring
sudo apt-get install -qq libsecret-1-0 libsecret-1-dev
sudo make --directory /usr/share/doc/git/contrib/credential/libsecret
git config --global credential.helper /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret
