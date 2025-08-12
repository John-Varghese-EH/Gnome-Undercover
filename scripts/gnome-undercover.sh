#!/bin/bash

# Configuration
CONFIG_DIR="$HOME/.config/gnome-undercover"
STATE_FILE="$CONFIG_DIR/state"
ORIGINAL_SETTINGS_FILE="$CONFIG_DIR/original_settings.conf"

# Theme names will be refined during testing. These are based on the research.
WINDOWS_GTK_THEME="Fluent-round-Dark"
WINDOWS_SHELL_THEME="Fluent-round-Dark"
WINDOWS_ICON_THEME="Fluent-Dark"
WINDOWS_CURSOR_THEME="Bibata-Modern-Ice"
# Wallpaper path will be determined by the installer. Using a placeholder.
WINDOWS_WALLPAPER_URI="file:///usr/share/backgrounds/gnome-undercover/wallpaper.jpg"

# Extension UUIDs
DASH_TO_PANEL_UUID="dash-to-panel@jderose9.github.com"
ARCMENU_UUID="arcmenu@arcmenu.com"
USER_THEMES_UUID="user-theme@gnome-shell-extensions.gcampax.github.io"

# Ensure config directory exists
mkdir -p "$CONFIG_DIR"

function save_original_settings() {
    if [ ! -f "$ORIGINAL_SETTINGS_FILE" ]; then
        echo "Saving original GNOME settings..."
        # Using gsettings get to capture current settings
        echo "ORIGINAL_GTK_THEME='$(gsettings get org.gnome.desktop.interface gtk-theme)'" > "$ORIGINAL_SETTINGS_FILE"
        echo "ORIGINAL_ICON_THEME='$(gsettings get org.gnome.desktop.interface icon-theme)'" >> "$ORIGINAL_SETTINGS_FILE"
        echo "ORIGINAL_CURSOR_THEME='$(gsettings get org.gnome.desktop.interface cursor-theme)'" >> "$ORIGINAL_SETTINGS_FILE"
        echo "ORIGINAL_SHELL_THEME='$(gsettings get org.gnome.shell.extensions.user-theme name)'" >> "$ORIGINAL_SETTINGS_FILE"
        echo "ORIGINAL_WALLPAPER_URI='$(gsettings get org.gnome.desktop.background picture-uri)'" >> "$ORIGINAL_SETTINGS_FILE"
        echo "ORIGINAL_WALLPAPER_URI_DARK='$(gsettings get org.gnome.desktop.background picture-uri-dark)'" >> "$ORIGINAL_SETTINGS_FILE"

        # Save enabled state of our extensions
        echo "ORIGINAL_DASH_TO_PANEL_ENABLED=$(gnome-extensions list --enabled | grep -c $DASH_TO_PANEL_UUID)" >> "$ORIGINAL_SETTINGS_FILE"
        echo "ORIGINAL_ARCMENU_ENABLED=$(gnome-extensions list --enabled | grep -c $ARCMENU_UUID)" >> "$ORIGINAL_SETTINGS_FILE"

        echo "Original settings saved to $ORIGINAL_SETTINGS_FILE"
    fi
}

function switch_to_windows() {
    echo "Switching to Windows 11 theme..."

    # Enable prerequisite extensions
    gnome-extensions enable $USER_THEMES_UUID
    gnome-extensions enable $DASH_TO_PANEL_UUID
    gnome-extensions enable $ARCMENU_UUID

    # Apply themes
    gsettings set org.gnome.desktop.interface gtk-theme "$WINDOWS_GTK_THEME"
    gsettings set org.gnome.shell.extensions.user-theme name "$WINDOWS_SHELL_THEME"
    gsettings set org.gnome.desktop.interface icon-theme "$WINDOWS_ICON_THEME"
    gsettings set org.gnome.desktop.interface cursor-theme "$WINDOWS_CURSOR_THEME"
    gsettings set org.gnome.desktop.background picture-uri "$WINDOWS_WALLPAPER_URI"
    gsettings set org.gnome.desktop.background picture-uri-dark "$WINDOWS_WALLPAPER_URI"

    configure_dash_to_panel_windows
    configure_arcmenu_windows

    touch "$STATE_FILE"
    echo "Theme set to Windows."
}

function switch_to_gnome() {
    echo "Switching back to original GNOME theme..."
    if [ -f "$ORIGINAL_SETTINGS_FILE" ]; then
        source "$ORIGINAL_SETTINGS_FILE"

        gsettings set org.gnome.desktop.interface gtk-theme "$ORIGINAL_GTK_THEME"
        gsettings set org.gnome.desktop.interface icon-theme "$ORIGINAL_ICON_THEME"
        gsettings set org.gnome.desktop.interface cursor-theme "$ORIGINAL_CURSOR_THEME"
        gsettings set org.gnome.shell.extensions.user-theme name "$ORIGINAL_SHELL_THEME"
        gsettings set org.gnome.desktop.background picture-uri "$ORIGINAL_WALLPAPER_URI"
        gsettings set org.gnome.desktop.background picture-uri-dark "$ORIGINAL_WALLPAPER_URI_DARK"

        # Restore original extension settings
        restore_dash_to_panel_settings
        restore_arcmenu_settings

        # Restore extension states
        if [ "$ORIGINAL_DASH_TO_PANEL_ENABLED" -eq 0 ]; then
            gnome-extensions disable $DASH_TO_PANEL_UUID
        fi
        if [ "$ORIGINAL_ARCMENU_ENABLED" -eq 0 ]; then
            gnome-extensions disable $ARCMENU_UUID
        fi

        rm "$STATE_FILE"
        echo "Theme restored to original GNOME settings."
    else
        echo "Error: Original settings file not found. Cannot revert."
    fi
}

function configure_dash_to_panel_windows() {
    echo "Configuring Dash-to-Panel..."
    local schema="org.gnome.shell.extensions.dash-to-panel"
    # Save original settings before changing them
    echo "DTP_PANEL_POSITIONS='$(gsettings get $schema panel-positions)'" >> "$ORIGINAL_SETTINGS_FILE"
    echo "DTP_PANEL_SIZES='$(gsettings get $schema panel-sizes)'" >> "$ORIGINAL_SETTINGS_FILE"
    echo "DTP_SHOW_ACTIVITIES='$(gsettings get $schema show-activities-button)'" >> "$ORIGINAL_SETTINGS_FILE"
    echo "DTP_GROUP_APPS='$(gsettings get $schema group-apps)'" >> "$ORIGINAL_SETTINGS_FILE"
    echo "DTP_INTELLIHIDE='$(gsettings get $schema intellihide)'" >> "$ORIGINAL_SETTINGS_FILE"
    echo "DTP_ELEMENT_POSITIONS='$(gsettings get $schema panel-element-positions)'" >> "$ORIGINAL_SETTINGS_FILE"

    # Apply Windows 11 settings
    gsettings set $schema panel-positions '{ "0": "BOTTOM" }'
    gsettings set $schema panel-sizes '{ "0": 48 }'
    gsettings set $schema show-activities-button false
    gsettings set $schema group-apps true
    gsettings set $schema intellihide false # Can be set to true for auto-hide
    gsettings set $schema panel-element-positions '{ "0": "[{\\"element\\":\\"activitiesButton\\",\\"visible\\":false,\\"position\\":\\"left\\"},{\\"element\\":\\"showAppsButton\\",\\"visible\\":false,\\"position\\":\\"left\\"},{\\"element\\":\\"leftBox\\",\\"visible\\":true,\\"position\\":\\"left\\"},{\\"element\\":\\"taskbar\\",\\"visible\\":true,\\"position\\":\\"center\\"},{\\"element\\":\\"centerBox\\",\\"visible\\":true,\\"position\\":\\"center\\"},{\\"element\\":\\"rightBox\\",\\"visible\\":true,\\"position\\":\\"right\\"},{\\"element\\":\\"desktopButton\\",\\"visible\\":true,\\"position\\":\\"right\\"}]" }'
}

function restore_dash_to_panel_settings() {
    local schema="org.gnome.shell.extensions.dash-to-panel"
    gsettings set $schema panel-positions "$DTP_PANEL_POSITIONS"
    gsettings set $schema panel-sizes "$DTP_PANEL_SIZES"
    gsettings set $schema show-activities-button "$DTP_SHOW_ACTIVITIES"
    gsettings set $schema group-apps "$DTP_GROUP_APPS"
    gsettings set $schema intellihide "$DTP_INTELLIHIDE"
    gsettings set $schema panel-element-positions "$DTP_ELEMENT_POSITIONS"
}

function configure_arcmenu_windows() {
    echo "Configuring ArcMenu..."
    local schema="org.gnome.shell.extensions.arcmenu"
    # Save original settings
    echo "AM_MENU_LAYOUT='$(gsettings get $schema menu-layout)'" >> "$ORIGINAL_SETTINGS_FILE"
    echo "AM_MENU_ICON='$(gsettings get $schema menu-button-icon)'" >> "$ORIGINAL_SETTINGS_FILE"
    echo "AM_CUSTOM_ICON='$(gsettings get $schema custom-menu-button-icon)'" >> "$ORIGINAL_SETTINGS_FILE"
    echo "AM_POSITION='$(gsettings get $schema position-in-panel)'" >> "$ORIGINAL_SETTINGS_FILE"

    # Apply Windows 11 settings
    gsettings set $schema menu-layout 'Eleven'
    gsettings set $schema menu-button-icon 'Custom_Icon'
    # This assumes the Fluent theme places an icon here. This path might need adjustment in the installer.
    gsettings set $schema custom-menu-button-icon '/usr/share/icons/Fluent-Dark/apps/scalable/start-here.svg'
    gsettings set $schema position-in-panel 'Center'
}

function restore_arcmenu_settings() {
    local schema="org.gnome.shell.extensions.arcmenu"
    gsettings set $schema menu-layout "$AM_MENU_LAYOUT"
    gsettings set $schema menu-button-icon "$AM_MENU_ICON"
    gsettings set $schema custom-menu-button-icon "$AM_CUSTOM_ICON"
    gsettings set $schema position-in-panel "$AM_POSITION"
}

# --- Main Logic ---

# First, ensure original settings are saved if this is the first run
save_original_settings

# Toggle between states
if [ -f "$STATE_FILE" ]; then
    # Currently in Windows mode, switch back to GNOME
    switch_to_gnome
else
    # Currently in GNOME mode, switch to Windows
    switch_to_windows
fi
