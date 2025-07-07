#!/usr/bin/env bash

# Gnome-Undercover: Advanced GNOME <-> Windows theme switcher

set -euo pipefail

# --- CONFIGURATION ---
WIN_THEME="Windows-10"
WIN_ICONS="Windows-10"
WIN_SHELL_THEME="Windows-10"
WIN_WALLPAPER="/usr/share/backgrounds/Windows10/win10-wallpaper.jpg"
WIN_TERMINAL_PROFILE_NAME="Windows10"
WIN_EXTENSIONS=("dash-to-panel@jderose9.github.com" "arc-menu@linxgem33.com")

BACKUP_DIR="$HOME/.config/gnome-undercover-backup"
BACKUP_VERSION_FILE="$BACKUP_DIR/version"
BACKUP_VERSION="1"
DUMP_FILE="$BACKUP_DIR/dconf.dump"

# --- UTILITY FUNCTIONS ---
function notify() {
    command -v notify-send &>/dev/null && notify-send "Gnome-Undercover" "$1"
}

function error_exit() {
    notify "Error: $1"
    echo "Error: $1" >&2
    exit 1
}

function check_dependencies() {
    for dep in gsettings dconf gnome-extensions; do
        command -v "$dep" &>/dev/null || error_exit "Missing dependency: $dep"
    done
}

function backup_settings() {
    mkdir -p "$BACKUP_DIR"
    dconf dump / > "$DUMP_FILE"
    echo "$BACKUP_VERSION" > "$BACKUP_VERSION_FILE"
}

function restore_settings() {
    if [[ -f "$DUMP_FILE" ]]; then
        dconf load / < "$DUMP_FILE"
        rm -rf "$BACKUP_DIR"
        notify "Restored original GNOME appearance."
    else
        error_exit "No backup found. Cannot restore."
    fi
}

function apply_windows_theme() {
    # GTK, Shell, Icons, Wallpaper
    gsettings set org.gnome.desktop.interface gtk-theme "$WIN_THEME"
    gsettings set org.gnome.desktop.interface icon-theme "$WIN_ICONS"
    gsettings set org.gnome.desktop.wm.preferences theme "$WIN_THEME"
    gsettings set org.gnome.shell.extensions.user-theme name "$WIN_SHELL_THEME"
    gsettings set org.gnome.desktop.background picture-uri "file://$WIN_WALLPAPER"

    # GNOME Terminal profile (optional)
    set_terminal_profile "$WIN_TERMINAL_PROFILE_NAME"

    # Enable required extensions
    for ext in "${WIN_EXTENSIONS[@]}"; do
        gnome-extensions enable "$ext" || true
    done

    notify "Switched to Windows-like appearance."
}

function set_terminal_profile() {
    local profile_name="$1"
    local uuid
    uuid=$(gsettings get org.gnome.Terminal.ProfilesList list | grep -oP "'\K[^']+" | while read -r id; do
        name=$(gsettings get "org.gnome.Terminal.Legacy.Profile:/org/gnome/Terminal/Legacy/Profiles:/:$id/" visible-name)
        [[ "$name" == "'$profile_name'" ]] && echo "$id"
    done | head -n1)
    if [[ -n "$uuid" ]]; then
        gsettings set org.gnome.Terminal.ProfilesList default "$uuid"
    fi
}

function is_windows_mode() {
    [[ "$(gsettings get org.gnome.desktop.interface gtk-theme)" == "'$WIN_THEME'" ]]
}

function disable_windows_mode() {
    restore_settings
}

function enable_windows_mode() {
    backup_settings
    apply_windows_theme
}

# --- MAIN LOGIC ---
check_dependencies

if is_windows_mode; then
    disable_windows_mode
else
    enable_windows_mode
fi
