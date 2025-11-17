#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
SCRIPT_NAME="GNOME Undercover Installer"
TEMP_DIR="/tmp/gnome-undercover-build"
THEME_DIR_USER="$HOME/.themes"
ICONS_DIR_USER="$HOME/.icons"
EXTENSIONS_DIR_USER="$HOME/.local/share/gnome-shell/extensions"
APPLICATIONS_DIR_USER="$HOME/.local/share/applications"
SCRIPTS_DIR_USER="$HOME/.local/bin"
CONFIG_DIR_USER="$HOME/.config/gnome-undercover"
SETTINGS_FILE="$CONFIG_DIR_USER/settings.conf"

# Theme and extension repositories
FLUENT_GTK_THEME_REPO="https://github.com/vinceliuice/Fluent-gtk-theme.git"
FLUENT_ICON_THEME_REPO="https://github.com/vinceliuice/Fluent-icon-theme.git"
BIBATA_CURSOR_THEME_REPO="https://github.com/KaizIqbal/Bibata_Cursor.git"

# --- Helper Functions ---

# Function to print messages
msg() {
    echo "✔  $1"
}

# Function to print error messages
error() {
    echo "✖  $1" >&2
    exit 1
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# --- Installation Functions ---

# 1. Install Dependencies
install_dependencies() {
    msg "Checking and installing dependencies..."
    if command_exists apt; then
        sudo apt update
        sudo apt install -y git gnome-shell-extensions gnome-tweaks sassc libglib2.0-dev jq
    elif command_exists dnf; then
        sudo dnf install -y git gnome-shell-extensions gnome-tweaks sassc glib2-devel jq
    elif command_exists pacman; then
        sudo pacman -Syu --noconfirm git gnome-shell-extensions gnome-tweaks sassc glib2 jq
    else
        error "Unsupported package manager. Please install dependencies manually: git, gnome-shell-extensions, gnome-tweaks, sassc, jq, glib2-devel (or equivalent)."
    fi
    msg "Dependencies installed."
}

# 2. Clone and Install Themes
install_themes() {
    msg "Creating temporary directory for theme installation..."
    rm -rf "$TEMP_DIR"
    mkdir -p "$TEMP_DIR"
    cd "$TEMP_DIR"

    msg "Cloning and installing Fluent GTK theme..."
    git clone "$FLUENT_GTK_THEME_REPO"
    (cd Fluent-gtk-theme && ./install.sh --tweaks round -c dark -t teal --dest "$THEME_DIR_USER")

    msg "Cloning and installing Fluent icon theme..."
    git clone "$FLUENT_ICON_THEME_REPO"
    (cd Fluent-icon-theme && ./install.sh -c teal --dest "$ICONS_DIR_USER")

    msg "Cloning and installing Bibata cursor theme..."
    git clone "$BIBATA_CURSOR_THEME_REPO"
    (cd Bibata_Cursor && ./install.sh) # Bibata's script installs to ~/.icons by default

    # Copy wallpaper
    msg "Installing wallpaper..."
    mkdir -p "$HOME/.local/share/backgrounds/gnome-undercover"
    cp "$TEMP_DIR/Fluent-gtk-theme/wallpaper/fluent-wallpaper-dark.png" "$HOME/.local/share/backgrounds/gnome-undercover/wallpaper.png"

    msg "Themes and icons installed."
}

# 3. Install Core Script and Assets
install_core_files() {
    msg "Installing core script and assets..."

    # Install the main script
    mkdir -p "$SCRIPTS_DIR_USER"
    cp "scripts/gnome-undercover.sh" "$SCRIPTS_DIR_USER/gnome-undercover"
    chmod +x "$SCRIPTS_DIR_USER/gnome-undercover"

    # Install the .desktop file
    mkdir -p "$APPLICATIONS_DIR_USER"
    cp "assets/gnome-undercover.desktop" "$APPLICATIONS_DIR_USER/"

    # Install the icon for the .desktop file
    local icon_to_find="start-here.svg"
    local icon_path=$(find "$ICONS_DIR_USER/Fluent-Dark" -name "$icon_to_find" -o -name "distributor-logo-windows.svg" | head -n 1)

    if [ -n "$icon_path" ]; then
        msg "Found icon for desktop shortcut at $icon_path"
        mkdir -p "$HOME/.local/share/icons/hicolor/scalable/apps"
        cp "$icon_path" "$HOME/.local/share/icons/hicolor/scalable/apps/gnome-undercover.svg"
        gtk-update-icon-cache -f -t "$HOME/.local/share/icons/hicolor"

        # Create settings file and write the icon path to it
        mkdir -p "$CONFIG_DIR_USER"
        {
            echo "ARCMENU_ICON_PATH='$icon_path'"
            echo "THEME_COLOR='teal'"
            echo "THEME_MODE='Dark'"
        } > "$SETTINGS_FILE"
    else
        msg "Warning: Could not find a suitable icon for the .desktop file. The shortcut will not have an icon."
    fi

    msg "Core files installed."
}

# 4. Install GNOME Shell Extension
install_extension() {
    msg "Installing GNOME Shell extension..."
    local extension_uuid
    extension_uuid=$(jq -r '.uuid' "gnome-undercover-extension/metadata.json")

    if [ -z "$extension_uuid" ]; then
        error "Could not read UUID from metadata.json. Is 'jq' installed?"
    fi

    local target_dir="$EXTENSIONS_DIR_USER/$extension_uuid"
    mkdir -p "$target_dir"
    cp -r gnome-undercover-extension/* "$target_dir/"

    msg "Enabling extensions... You may need to log out and back in for all changes to take effect."
    gnome-extensions enable "user-theme@gnome-shell-extensions.gcampax.github.io"
    gnome-extensions enable "$extension_uuid"

    msg "Extension installed and enabled."
}

# --- Main Execution ---

main() {
    echo "--- $SCRIPT_NAME ---"
    install_dependencies
    install_themes
    install_core_files
    install_extension
    echo ""
    echo "Installation complete!"
    echo "To apply the theme, use the 'GNOME Undercover' application or the new panel button."
    echo "You may need to log out and back in for all changes to be visible."
}

main "$@"
