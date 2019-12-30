#!/bin/bash
set -euxo pipefail

# Turn off blank screen to do not ask for password every time
# you pass 5 minutes away of the VM
gsettings set org.gnome.desktop.session idle-delay 0

# Turn on dark mode
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

# Turn on home icon on desktop
gsettings set org.gnome.nautilus.desktop home-icon-visible true

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
