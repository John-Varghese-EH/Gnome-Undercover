#!/usr/bin/env bats

load 'bats-support/load'
load 'bats-assert/load'

# The script to test
SCRIPT_UNDER_TEST="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)/../gnome-undercover.sh"
MOCK_CALLS_LOG=""

setup() {
    MOCK_CALLS_LOG=$(mktemp)

    # Source the script to make functions available
    source "$SCRIPT_UNDER_TEST"

    # Override the command functions for testing
    _gsettings() {
        if [[ "$1" == "get" && "$3" == "gtk-theme" ]]; then
            echo "'Adwaita'" # Default: not in Windows mode
        else
            echo "gsettings $@" >> "$MOCK_CALLS_LOG"
        fi
    }
    _dconf() { echo "dconf $@" >> "$MOCK_CALLS_LOG"; }
    _gnome_extensions() { echo "gnome-extensions $@" >> "$MOCK_CALLS_LOG"; }
    _notify_send() { echo "notify-send $@" >> "$MOCK_CALLS_LOG"; }
    _command() {
        # Allow dependency checks to pass
        if [[ "$1" == "-v" ]]; then return 0; fi
        command "$@"
    }

    # Mock out the problematic function
    set_terminal_profile() {
        echo "set_terminal_profile $@" >> "$MOCK_CALLS_LOG"
    }
}

teardown() {
    rm -f "$MOCK_CALLS_LOG"
}

@test "enables Windows mode when not active" {
    # The default _gsettings mock simulates "not active"
    main

    grep "dconf dump" "$MOCK_CALLS_LOG"
    grep "gsettings set org.gnome.desktop.interface gtk-theme" "$MOCK_CALLS_LOG"
    grep "notify-send Switched to Windows-like appearance." "$MOCK_CALLS_LOG"
}

@test "disables Windows mode when active" {
    # Override _gsettings for this test
    _gsettings() {
        if [[ "$1" == "get" && "$3" == "gtk-theme" ]]; then
            echo "'Fluent-round-teal-Dark'"
        else
            echo "gsettings $@" >> "$MOCK_CALLS_LOG"
        fi
    }

    # Create a dummy backup
    mkdir -p "$HOME/.config/gnome-undercover-backup"
    touch "$HOME/.config/gnome-undercover-backup/dconf.dump"

    main

    grep "dconf load" "$MOCK_CALLS_LOG"
    grep "notify-send Restored original GNOME appearance." "$MOCK_CALLS_LOG"
}

@test "exits if a dependency is missing" {
    # Override _command to simulate a missing dependency
    _command() {
        if [[ "$2" == "dconf" ]]; then return 1; fi
        return 0
    }

    run main

    assert_failure
    assert_output --partial "Missing dependency: dconf"
}
