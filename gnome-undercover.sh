#!/usr/bin/env bash

# Gnome-Undercover: Advanced GNOME <-> Windows theme switcher

set -euo pipefail

# --- CONFIGURATION ---
TARGET_VERSION="win11" # Default to Windows 11
WIN11_THEME="Fluent-round-teal-Dark"
WIN11_ICONS="Fluent-teal-Dark"
WIN11_SHELL="Fluent-round-teal-Dark"

WIN10_THEME="Windows-10-Dark"
WIN10_ICONS="Windows-10"
WIN10_SHELL="Fluent-round-teal-Dark" # Fallback or use Win10 if available

WIN_WALLPAPER="$HOME/.local/share/backgrounds/gnome-undercover/wallpaper.png"
WIN_TERMINAL_PROFILE_NAME="Windows10"
WIN_EXTENSIONS=("dash-to-panel@jderose9.github.com" "arcmenu@arcmenu.com")

BACKUP_DIR="$HOME/.config/gnome-undercover-backup"
BACKUP_VERSION_FILE="$BACKUP_DIR/version"
BACKUP_VERSION="1"
DUMP_FILE="$BACKUP_DIR/dconf.dump"

# --- MOCKABLE COMMANDS ---
_gsettings() { command gsettings "$@"; }
_dconf() { command dconf "$@"; }
_gnome_extensions() { command gnome-extensions "$@"; }
_notify_send() { command notify-send "$@"; }
_command() { command "$@"; }

# --- UTILITY FUNCTIONS ---
function notify() {
    _command -v notify-send &>/dev/null && _notify_send "Gnome-Undercover" "$1"
}

function error_exit() {
    notify "Error: $1"
    echo "Error: $1" >&2
    exit 1
}

function check_dependencies() {
    for dep in gsettings dconf gnome-extensions; do
        _command -v "$dep" &>/dev/null || error_exit "Missing dependency: $dep"
    done
}

function backup_settings() {
    mkdir -p "$BACKUP_DIR"
    _dconf dump / > "$DUMP_FILE"
    echo "$BACKUP_VERSION" > "$BACKUP_VERSION_FILE"
}

function restore_settings() {
    if [[ -f "$DUMP_FILE" ]]; then
        _dconf load / < "$DUMP_FILE"
        rm -rf "$BACKUP_DIR"
        notify "Restored original GNOME appearance."
    else
        error_exit "No backup found. Cannot restore."
    fi
}

function apply_windows_theme() {
    local theme=""
    local icons=""
    local shell=""
    
    if [[ "$TARGET_VERSION" == "win10" ]]; then
        theme="$WIN10_THEME"
        icons="$WIN10_ICONS"
        shell="$WIN10_SHELL" # Ideally we'd have a Win10 shell theme too
        notify "Applying Windows 10 theme..."
    else
        theme="$WIN11_THEME"
        icons="$WIN11_ICONS"
        shell="$WIN11_SHELL"
        notify "Applying Windows 11 theme..."
    fi

    # GTK, Shell, Icons, Wallpaper
    _gsettings set org.gnome.desktop.interface gtk-theme "$theme"
    _gsettings set org.gnome.desktop.interface icon-theme "$icons"
    _gsettings set org.gnome.desktop.wm.preferences theme "$theme"
    _gsettings set org.gnome.shell.extensions.user-theme name "$shell"
    _gsettings set org.gnome.desktop.background picture-uri "file://$WIN_WALLPAPER"

    # GNOME Terminal profile (optional)
    set_terminal_profile "$WIN_TERMINAL_PROFILE_NAME"

    # Enable required extensions
    for ext in "${WIN_EXTENSIONS[@]}"; do
        _gnome_extensions enable "$ext" || true
    done

    configure_extensions
    
    notify "Switched to Windows-like appearance."
}

function configure_extensions() {
    # Common icon path for both Windows versions
    local icon_path="'/usr/share/icons/Windows-10/scalable/places/start-here-symbolic.svg'"
    
    # ArcMenu: Set Layout
    if [[ "$TARGET_VERSION" == "win10" ]]; then
        _dconf write /org/gnome/shell/extensions/arcmenu/menu-layout "'Windows'" || true
        # Dash to Panel: Left position
        _dconf write /org/gnome/shell/extensions/dash-to-panel/taskbar-position "'LEFT'" || true
    else
        # Windows 11
        _dconf write /org/gnome/shell/extensions/arcmenu/menu-layout "'Eleven'" || true
        # Dash to Panel: Center position
        _dconf write /org/gnome/shell/extensions/dash-to-panel/taskbar-position "'CENTEREDMONITOR'" || true
    fi
    
    # Common ArcMenu settings for both versions
    _dconf write /org/gnome/shell/extensions/arcmenu/arc-menu-icon "'Custom_Icon'" || true
    _dconf write /org/gnome/shell/extensions/arcmenu/custom-menu-button-icon "$icon_path" || true
    
    # Common Dash to Panel settings for both versions
    _dconf write /org/gnome/shell/extensions/dash-to-panel/panel-position "'BOTTOM'" || true
    _dconf write /org/gnome/shell/extensions/dash-to-panel/appicon-margin "4" || true
    _dconf write /org/gnome/shell/extensions/dash-to-panel/trans-panel-opacity "0.8" || true
}

function set_terminal_profile() {
    local profile_name="$1"
    local profile_list
    profile_list=$(_gsettings get org.gnome.Terminal.ProfilesList list)

    if [[ -z "$profile_list" ]]; then
        return
    fi

    # Extract all profile IDs at once to avoid loop with multiple gsettings calls
    local uuid=""
    local profile_ids
    profile_ids=$(echo "$profile_list" | grep -oP "'\K[^']+")
    
    # For each profile ID, check the name in a single pass
    for id in $profile_ids; do
        local name
        # Suppress errors for profiles that might not exist - this is expected
        name=$(_gsettings get "org.gnome.Terminal.Legacy.Profile:/org/gnome/Terminal/Legacy/Profiles:/:$id/" visible-name 2>/dev/null)
        if [[ "$name" == "'$profile_name'" ]]; then
            uuid="$id"
            break  # Stop as soon as we find it
        fi
    done
    
    if [[ -n "$uuid" ]]; then
        _gsettings set org.gnome.Terminal.ProfilesList default "$uuid"
    else
        create_terminal_profile "$profile_name"
    fi
}

function create_terminal_profile() {
    local profile_name="$1"
    local uuid
    uuid=$(uuidgen)
    
    # Create new profile
    _gsettings set org.gnome.Terminal.ProfilesList list "$(_gsettings get org.gnome.Terminal.ProfilesList list | sed "s/]/, '$uuid']/")"
    
    local profile_path="org.gnome.Terminal.Legacy.Profile:/org/gnome/Terminal/Legacy/Profiles:/:$uuid/"
    
    _gsettings set "$profile_path" visible-name "$profile_name"
    _gsettings set "$profile_path" background-color "'#0C0C0C'"
    _gsettings set "$profile_path" foreground-color "'#CCCCCC'"
    _gsettings set "$profile_path" use-theme-colors "false"
    _gsettings set "$profile_path" use-system-font "false"
    _gsettings set "$profile_path" font "'Monospace 10'" # Fallback standard
    
    # Set as default
    _gsettings set org.gnome.Terminal.ProfilesList default "$uuid"
}

function is_windows_mode() {
    current_theme=$(_gsettings get org.gnome.desktop.interface gtk-theme)
    # Check if either Win11 or Win10 theme is active
    [[ "$current_theme" == "'$WIN11_THEME'" ]] || [[ "$current_theme" == "'$WIN10_THEME'" ]]
}

function disable_windows_mode() {
    restore_settings
}

function enable_windows_mode() {
    backup_settings
    apply_windows_theme
}

# --- MAIN LOGIC ---
function main() {
    # Parse arguments
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            --win10) TARGET_VERSION="win10" ;;
            --win11) TARGET_VERSION="win11" ;;
            *) echo "Unknown parameter passed: $1"; exit 1 ;;
        esac
        shift
    done

    check_dependencies


    if is_windows_mode; then
        disable_windows_mode
    else
        enable_windows_mode
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi
