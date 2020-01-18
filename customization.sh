#!/bin/bash
set -euxo pipefail

# Turn off blank screen to do not ask for password every time
# you pass 5 minutes away of the VM
gsettings set org.gnome.desktop.session idle-delay 0

# Turn on dark mode
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

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
cat <<-_EOT_ | sudo tee -a /var/lib/polkit-1/localauthority/50-local.d/disable-passwords.pkla
	[All]
	Identity=unix-user:vagrant
	Action=*
	ResultActive=yes
_EOT_

# Enable Automatic Login (but will still ask for login password when trying to unlock the keyring - such as opening Google Chrome)
# sudo sed -i 's/#  AutomaticLoginEnable = true/  AutomaticLoginEnable = true/g' /etc/gdm3/custom.conf
# sudo sed -i 's/#  AutomaticLogin = user1/  AutomaticLogin = vagrant/g' /etc/gdm3/custom.conf

# Add Open in Code to context menu
wget -qO- https://raw.githubusercontent.com/cra0zy/code-nautilus/master/install.sh | bash

# Install Bash-it
echo 'export BASH_IT_THEME="powerline-multiline"' >>~/.bashrc
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
~/.bash_it/install.sh --silent
sed -i 's/# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1/export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1/g' ~/.bashrc
