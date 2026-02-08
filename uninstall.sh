#!/bin/bash
# GNOME Undercover Uninstaller
# Author: John Varghese (https://github.com/John-Varghese-EH)
# Instagram: @cyber__trinity
# License: GPL-3.0

# --- Configuration ---
SCRIPT_NAME="GNOME Undercover Uninstaller"
THEME_DIR_USER="$HOME/.themes"
ICONS_DIR_USER="$HOME/.icons"
EXTENSIONS_DIR_USER="$HOME/.local/share/gnome-shell/extensions"
APPLICATIONS_DIR_USER="$HOME/.local/share/applications"
SCRIPTS_DIR_USER="$HOME/.local/bin"
BACKGROUNDS_DIR_USER="$HOME/.local/share/backgrounds"

# --- Helper Functions ---

# Function to print messages
msg() {
    echo "✔  $1"
}

# --- Uninstallation Functions ---

# 1. Remove Themes and Icons
remove_themes() {
    msg "Removing theme, icon, and cursor files..."
    rm -rf "$THEME_DIR_USER/Fluent-round-teal-Dark"
    rm -rf "$ICONS_DIR_USER/Fluent-Dark"
    rm -rf "$ICONS_DIR_USER/Fluent-teal-Dark"
    rm -rf "$ICONS_DIR_USER/Bibata-Modern-Ice"
    rm -rf "$THEME_DIR_USER/Fluent-gtk-theme"
    rm -rf "$ICONS_DIR_USER/Fluent-icon-theme"
    rm -rf "$ICONS_DIR_USER/Bibata_Cursor"
    rm -rf "$THEME_DIR_USER/Windows-10-Dark"
    rm -rf "$ICONS_DIR_USER/Windows-10"
    # Add any other theme/icon directories that might be created
}

# 2. Remove Core Script and Assets
remove_core_files() {
    msg "Removing core script and assets..."
    rm -f "$SCRIPTS_DIR_USER/gnome-undercover"
    rm -f "$SCRIPTS_DIR_USER/gnome-undercover-settings"
    rm -f "$APPLICATIONS_DIR_USER/gnome-undercover.desktop"
    rm -f "$APPLICATIONS_DIR_USER/gnome-undercover-settings.desktop"
    rm -f "$HOME/.local/share/icons/hicolor/scalable/apps/gnome-undercover.svg"
    gtk-update-icon-cache -f -t "$HOME/.local/share/icons/hicolor" || true
    rm -rf "$BACKGROUNDS_DIR_USER/gnome-undercover"
}

# 3. Remove GNOME Shell Extension
remove_extension() {
    msg "Removing and disabling GNOME Shell extension..."
    local extension_uuid="gnome-undercover@John-Varghese-EH"

    if gnome-extensions list --enabled | grep -q "$extension_uuid"; then
        gnome-extensions disable "$extension_uuid"
    fi

    rm -rf "$EXTENSIONS_DIR_USER/$extension_uuid"
    
    # Remove extra extensions
    rm -rf "$EXTENSIONS_DIR_USER/dash-to-panel@jderose9.github.com"
    rm -rf "$EXTENSIONS_DIR_USER/arcmenu@arcmenu.com"

    msg "Extension removed."
}

# 4. Remove Config Files
remove_configs() {
    msg "Removing configuration and state files..."
    rm -rf "$HOME/.config/gnome-undercover"
}

# --- Main Execution ---

main() {
    echo "--- $SCRIPT_NAME ---"
    echo "This will remove all components of GNOME Undercover."
    read -p "Are you sure you want to continue? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Uninstallation cancelled."
        exit 1
    fi

    # It's good practice to switch back before uninstalling
    if [ -f "$SCRIPTS_DIR_USER/gnome-undercover" ]; then
        msg "Attempting to restore original GNOME settings first..."
        # We need to check if it's in Windows mode before running
        if [ -f "$HOME/.config/gnome-undercover/state" ]; then
             "$SCRIPTS_DIR_USER/gnome-undercover"
        fi
    fi

    remove_themes
    remove_core_files
    remove_extension
    remove_configs

    echo ""
    echo "Uninstallation complete."
    echo "You may need to log out and back in for all changes to be fully reverted."
}

main "$@"
