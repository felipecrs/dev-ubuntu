#!/bin/bash
set -euxo pipefail

APT_GET="sudo DEBIAN_FRONTEND=noninteractive apt-get"

$APT_GET update
$APT_GET dist-upgrade -qq
$APT_GET install -qq ubuntu-desktop

cd /tmp/
git clone https://github.com/home-sweet-gnome/dash-to-panel.git
cd dash-to-panel/
make install

mkdir -p "$HOME/Pictures/"
wget -q https://w.wallhaven.cc/full/ox/wallhaven-ox19m9.jpg -O "$HOME/Pictures/wallhaven-ox19m9.jpg"
gsettings set org.gnome.desktop.background picture-uri "file://$HOME/Pictures/wallhaven-ox19m9.jpg"
gsettings set org.gnome.desktop.screensaver picture-uri "file://$HOME/Pictures/wallhaven-ox19m9.jpg"

sudo add-apt-repository -y ppa:daniruiz/flat-remix
sudo apt-get update
sudo apt-get install -y gnome-shell-extensions flat-remix flat-remix-gtk flat-remix-gnome

gnome-shell-extension-tool -e user-theme@gnome-shell-extensions.gcampax.github.com
gnome-shell-extension-tool -e dash-to-panel@jderose9.github.com
gsettings set org.gnome.desktop.interface gtk-theme "Flat-Remix-GTK-Blue-Dark-Solid"
gsettings set org.gnome.desktop.interface icon-theme "Flat-Remix-Blue-Dark"
gsettings set org.gnome.shell.extensions.user-theme name "Flat-Remix-Dark-fullPanel"
