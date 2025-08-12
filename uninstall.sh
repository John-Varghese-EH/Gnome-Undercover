#!/bin/bash

# --- Configuration ---
SCRIPT_NAME="GNOME Undercover Uninstaller"
THEME_DIR_USER="$HOME/.themes"
ICONS_DIR_USER="$HOME/.icons"
EXTENSIONS_DIR_USER="$HOME/.local/share/gnome-shell/extensions"
APPLICATIONS_DIR_USER="$HOME/.local/share/applications"
SCRIPTS_DIR_USER="$HOME/.local/bin"
BACKGROUNDS_DIR_USER="$HOME/.local/share/backgrounds"

# --- Helper Functions ---

# Color definitions
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to print messages
msg() {
    echo -e "${GREEN}✔${NC}  $1"
}

# Function to print warnings
warning() {
    echo -e "${YELLOW}⚠${NC}  $1"
}

# Function to print headers
header() {
    echo -e "\n${BLUE}--- $1 ---${NC}"
}

# --- Uninstallation Functions ---

# 1. Remove Themes and Icons
remove_themes() {
    header "Removing Themes and Icons"
    rm -rf "$THEME_DIR_USER/Fluent-round-teal-Dark"
    rm -rf "$ICONS_DIR_USER/Fluent-Dark"
    rm -rf "$ICONS_DIR_USER/Fluent-teal-Dark"
    rm -rf "$ICONS_DIR_USER/Bibata-Modern-Ice"
    msg "Theme, icon, and cursor files removed."
}

# 2. Remove Core Script and Assets
remove_core_files() {
    header "Removing Core Script and Assets"
    rm -f "$SCRIPTS_DIR_USER/gnome-undercover"
    rm -f "$APPLICATIONS_DIR_USER/gnome-undercover.desktop"
    rm -f "$HOME/.local/share/icons/hicolor/scalable/apps/gnome-undercover.svg"
    if command -v gtk-update-icon-cache >/dev/null 2>&1; then
        gtk-update-icon-cache -f -t "$HOME/.local/share/icons/hicolor" || true
    fi
    rm -rf "$BACKGROUNDS_DIR_USER/gnome-undercover"
    msg "Core files removed."
}

# 3. Remove GNOME Shell Extension
remove_extension() {
    header "Removing GNOME Shell Extension"
    local extension_uuid="gnome-undercover@John-Varghese-EH"

    if gnome-extensions list --enabled | grep -q "$extension_uuid"; then
        gnome-extensions disable "$extension_uuid"
        msg "Extension disabled."
    fi

    rm -rf "$EXTENSIONS_DIR_USER/$extension_uuid"
    msg "Extension files removed."
}

# 4. Remove Config Files
remove_configs() {
    header "Removing Configuration Files"
    rm -rf "$HOME/.config/gnome-undercover"
    msg "Configuration files removed."
}

# --- Main Execution ---

main() {
    header "$SCRIPT_NAME"
    echo -e "This will remove all components of GNOME Undercover from your user account."
    read -p "$(echo -e "${YELLOW}Are you sure you want to continue? (y/N)${NC} ")" -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Uninstallation cancelled."
        exit 1
    fi

    # It's good practice to switch back before uninstalling
    if [ -f "$SCRIPTS_DIR_USER/gnome-undercover" ]; then
        warning "Attempting to restore original GNOME settings first..."
        # We need to check if it's in Windows mode before running
        if [ -f "$HOME/.config/gnome-undercover/state" ]; then
             "$SCRIPTS_DIR_USER/gnome-undercover"
             msg "Restored original GNOME settings."
        else
             msg "Already in GNOME mode. No settings to restore."
        fi
    fi

    remove_themes
    remove_core_files
    remove_extension
    remove_configs

    msg "\nUninstallation complete!"
    echo "You may need to log out and back in for all changes to be fully reverted."
}

main "$@"
