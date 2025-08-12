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

# Theme and extension repositories
FLUENT_GTK_THEME_REPO="https://github.com/vinceliuice/Fluent-gtk-theme.git"
FLUENT_ICON_THEME_REPO="https://github.com/vinceliuice/Fluent-icon-theme.git"
BIBATA_CURSOR_THEME_REPO="https://github.com/KaizIqbal/Bibata_Cursor.git"

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

# Function to print error messages
error() {
    echo -e "${RED}✖${NC}  $1" >&2
    exit 1
}

# Function to print headers
header() {
    echo -e "\n${BLUE}--- $1 ---${NC}"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# --- Installation Functions ---

# 1. Install Dependencies
execute_dependency_installation() {
    msg "Attempting to install missing packages..."
    if command_exists apt; then
        sudo apt update
        sudo apt install -y git gnome-shell-extensions gnome-tweaks sassc libglib2.0-dev jq
    elif command_exists dnf; then
        sudo dnf install -y git gnome-shell-extensions gnome-tweaks sassc glib2-devel jq
    elif command_exists pacman; then
        sudo pacman -Syu --noconfirm git gnome-shell-extensions gnome-tweaks sassc glib2 jq
    else
        error "Unsupported package manager. Please install dependencies manually."
    fi
    msg "Dependency installation complete."
}

install_dependencies() {
    header "Step 1: Checking Dependencies"
    local REQUIRED_DEPS=("git" "gnome-shell" "gnome-tweaks" "sassc" "jq")
    local missing_deps=()

    for dep in "${REQUIRED_DEPS[@]}"; do
        if ! command_exists "$dep"; then
            missing_deps+=("$dep")
        fi
    done

    if [ ${#missing_deps[@]} -gt 0 ]; then
        warning "The following dependencies are missing: ${missing_deps[*]}"
        read -p "$(echo -e "${YELLOW}May I install them for you? (y/N)${NC} ")" -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            execute_dependency_installation
        else
            error "Dependencies are required to continue. Aborting."
        fi
    else
        msg "All dependencies are already installed."
    fi
}

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

# Function to print error messages
error() {
    echo -e "${RED}✖${NC}  $1" >&2
    exit 1
}

# Function to print headers
header() {
    echo -e "\n${BLUE}--- $1 ---${NC}"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

check_success() {
    if [ $? -ne 0 ]; then
        error "$1"
    fi
}

# --- Installation Functions ---

# 1. Install Dependencies
execute_dependency_installation() {
    msg "Attempting to install missing packages..."
    if command_exists apt; then
        sudo apt update && sudo apt install -y git gnome-shell-extensions gnome-tweaks sassc libglib2.0-dev jq
        check_success "Failed to install dependencies with apt."
    elif command_exists dnf; then
        sudo dnf install -y git gnome-shell-extensions gnome-tweaks sassc glib2-devel jq
        check_success "Failed to install dependencies with dnf."
    elif command_exists pacman; then
        sudo pacman -Syu --noconfirm git gnome-shell-extensions gnome-tweaks sassc glib2 jq
        check_success "Failed to install dependencies with pacman."
    else
        error "Unsupported package manager. Please install dependencies manually."
    fi
    msg "Dependency installation complete."
}

install_dependencies() {
    header "Step 1: Checking Dependencies"
    local REQUIRED_DEPS=("git" "gnome-shell" "gnome-tweaks" "sassc" "jq")
    local missing_deps=()

    for dep in "${REQUIRED_DEPS[@]}"; do
        if ! command_exists "$dep"; then
            missing_deps+=("$dep")
        fi
    done

    if [ ${#missing_deps[@]} -gt 0 ]; then
        warning "The following dependencies are missing: ${missing_deps[*]}"
        read -p "$(echo -e "${YELLOW}May I install them for you? (y/N)${NC} ")" -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            execute_dependency_installation
        else
            error "Dependencies are required to continue. Aborting."
        fi
    else
        msg "All dependencies are already installed."
    fi
}

# 3. Clone and Install Themes
install_themes() {
    local color_variant="$1"
    local tweaks_args="$2"

    header "Step 3: Cloning and Installing Themes"
    msg "Creating temporary directory for theme installation..."
    rm -rf "$TEMP_DIR"
    mkdir -p "$TEMP_DIR"; check_success "Failed to create temporary directory."
    cd "$TEMP_DIR"; check_success "Failed to navigate to temporary directory."

    msg "Cloning Fluent GTK theme..."
    git clone "$FLUENT_GTK_THEME_REPO"; check_success "Failed to clone Fluent GTK theme repository."
    msg "Installing Fluent GTK theme..."
    (cd Fluent-gtk-theme && ./install.sh --tweaks $tweaks_args -c dark -t "$color_variant" --dest "$THEME_DIR_USER")
    check_success "Failed to install Fluent GTK theme."

    msg "Cloning Fluent icon theme..."
    git clone "$FLUENT_ICON_THEME_REPO"; check_success "Failed to clone Fluent icon theme repository."
    msg "Installing Fluent icon theme..."
    (cd Fluent-icon-theme && ./install.sh -c "$color_variant" --dest "$ICONS_DIR_USER")
    check_success "Failed to install Fluent icon theme."

    msg "Cloning Bibata cursor theme..."
    git clone "$BIBATA_CURSOR_THEME_REPO"; check_success "Failed to clone Bibata cursor theme repository."
    msg "Installing Bibata cursor theme..."
    (cd Bibata_Cursor && ./install.sh)
    check_success "Failed to install Bibata cursor theme."

    # Copy wallpaper
    msg "Installing wallpaper..."
    mkdir -p "$HOME/.local/share/backgrounds/gnome-undercover"; check_success "Failed to create wallpaper directory."
    cp "$TEMP_DIR/Fluent-gtk-theme/wallpaper/fluent-wallpaper-dark.png" "$HOME/.local/share/backgrounds/gnome-undercover/wallpaper.png"
    check_success "Failed to copy wallpaper."

    msg "Themes, icons, and wallpaper installed."
}

# 2. Interactive Setup
interactive_theme_setup() {
    header "Step 2: Theme Customization"

    local theme_color="teal" # Default color
    local tweaks="round"     # Default tweaks

    # Ask for color theme
    echo "Please choose a color variant for the theme:"
    select color_choice in "Default (Blue)" "Teal" "Green" "Red" "Orange" "Purple" "Pink" "Grey"; do
        case $color_choice in
            "Default (Blue)") theme_color="default"; break;;
            "Teal") theme_color="teal"; break;;
            "Green") theme_color="green"; break;;
            "Red") theme_color="red"; break;;
            "Orange") theme_color="orange"; break;;
            "Purple") theme_color="purple"; break;;
            "Pink") theme_color="pink"; break;;
            "Grey") theme_color="grey"; break;;
            *) echo "Invalid option. Please try again.";;
        esac
    done

    # Ask for blur tweak
    read -p "$(echo -e "${YELLOW}Enable blur effect? (Requires 'Blur My Shell' extension) (y/N)${NC} ")" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        tweaks="$tweaks blur"
    fi

    msg "Selected Color: $theme_color"
    msg "Selected Tweaks: $tweaks"

    install_themes "$theme_color" "$tweaks"
}

# 4. Install Core Script and Assets
install_core_files() {
    header "Step 4: Installing Core Files"

    # Install the main script
    mkdir -p "$SCRIPTS_DIR_USER"; check_success "Failed to create script directory."
    cp "scripts/gnome-undercover.sh" "$SCRIPTS_DIR_USER/gnome-undercover"; check_success "Failed to copy main script."
    chmod +x "$SCRIPTS_DIR_USER/gnome-undercover"; check_success "Failed to make script executable."

    # Update wallpaper path in script
    sed -i "s|file:///usr/share/backgrounds/gnome-undercover/wallpaper.jpg|file://$HOME/.local/share/backgrounds/gnome-undercover/wallpaper.png|g" "$SCRIPTS_DIR_USER/gnome-undercover"
    check_success "Failed to update wallpaper path in script."

    # Install the .desktop file
    mkdir -p "$APPLICATIONS_DIR_USER"; check_success "Failed to create applications directory."
    cp "assets/gnome-undercover.desktop" "$APPLICATIONS_DIR_USER/"; check_success "Failed to copy .desktop file."

    # Install the icon for the .desktop file
    local icon_to_find="start-here.svg"
    local icon_path=$(find "$ICONS_DIR_USER/Fluent-Dark" -name "$icon_to_find" -o -name "distributor-logo-windows.svg" | head -n 1)

    if [ -n "$icon_path" ]; then
        msg "Found icon for desktop shortcut at $icon_path"
        mkdir -p "$HOME/.local/share/icons/hicolor/scalable/apps"; check_success "Failed to create icon directory."
        cp "$icon_path" "$HOME/.local/share/icons/hicolor/scalable/apps/gnome-undercover.svg"; check_success "Failed to copy icon."
        gtk-update-icon-cache -f -t "$HOME/.local/share/icons/hicolor" || warning "Failed to update icon cache. Icons may not appear immediately."
    else
        warning "Could not find a suitable icon for the .desktop file. The shortcut will not have an icon."
    fi

    msg "Core files installed."
}

# 5. Install GNOME Shell Extension
install_extension() {
    header "Step 5: Installing GNOME Shell Extension"
    local extension_uuid
    extension_uuid=$(jq -r '.uuid' "gnome-undercover-extension/metadata.json")
    check_success "Failed to read UUID from metadata.json. Is 'jq' installed and is the file present?"

    if [ -z "$extension_uuid" ]; then
        error "Could not read UUID from metadata.json."
    fi

    local target_dir="$EXTENSIONS_DIR_USER/$extension_uuid"
    mkdir -p "$target_dir"; check_success "Failed to create extension directory."
    cp -r gnome-undercover-extension/* "$target_dir/"; check_success "Failed to copy extension files."

    msg "Enabling extensions... You may need to log out and back in for all changes to take effect."
    gnome-extensions enable "user-theme@gnome-shell-extensions.gcampax.github.io"
    check_success "Failed to enable User Themes extension. Is 'gnome-shell-extensions' package installed correctly?"
    gnome-extensions enable "$extension_uuid"
    check_success "Failed to enable GNOME Undercover extension."

    msg "Extension installed and enabled."
}

# --- Main Execution ---

main() {
    header "$SCRIPT_NAME"
    install_dependencies
    interactive_theme_setup
    install_core_files
    install_extension

    msg "\nInstallation complete!"
    echo "To apply the theme, use the 'GNOME Undercover' application or the new panel button."
    echo "You may need to log out and back in for all changes to be visible."
}

main "$@"
