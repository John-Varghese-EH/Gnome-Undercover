#!/usr/bin/env bash

set -euo pipefail

echo "[*] Installing dependencies..."
sudo apt update
sudo apt install -y gnome-tweaks gnome-shell-extensions dconf-cli wget unzip

echo "[*] Downloading and installing Windows 10 GTK and icon themes..."
THEMES_DIR="/usr/share/themes"
ICONS_DIR="/usr/share/icons"
TMP_DIR="/tmp/gnome-undercover"
mkdir -p "$TMP_DIR"
cd "$TMP_DIR"

wget -O Windows-10.tar.gz https://github.com/B00merang-Project/Windows-10/archive/refs/heads/master.tar.gz
tar -xf Windows-10.tar.gz
sudo cp -r Windows-10*/ "$THEMES_DIR/Windows-10"

wget -O Windows-10-Icons.tar.gz https://github.com/B00merang-Project/Windows-10-Icons/archive/refs/heads/master.tar.gz
tar -xf Windows-10-Icons.tar.gz
sudo cp -r Windows-10-Icons*/ "$ICONS_DIR/Windows-10"

sudo mkdir -p /usr/share/backgrounds/Windows10
wget -O /usr/share/backgrounds/Windows10/win10-wallpaper.jpg https://wallpapercave.com/wp/wp2757874.jpg

echo "[*] Installing GNOME Shell extensions (Dash to Panel, Arc Menu)..."
EXT_DIR="$HOME/.local/share/gnome-shell/extensions"
mkdir -p "$EXT_DIR"
wget -O dash-to-panel.zip https://extensions.gnome.org/extension-data/dash-to-paneljderose9.github.com.v56.shell-extension.zip
wget -O arc-menu.zip https://extensions.gnome.org/extension-data/arc-menu@linxgem33.com.v47.shell-extension.zip
unzip -o dash-to-panel.zip -d "$EXT_DIR/dash-to-panel@jderose9.github.com"
unzip -o arc-menu.zip -d "$EXT_DIR/arc-menu@linxgem33.com"

echo "[*] Installation complete. You can now run ./gnome-undercover.sh to toggle modes."
