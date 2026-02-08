'use strict';

import St from 'gi://St';
import GLib from 'gi://GLib';
import { Extension, gettext as _ } from 'resource:///org/gnome/shell/extensions/extension.js';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import * as PanelMenu from 'resource:///org/gnome/shell/ui/panelMenu.js';
import * as PopupMenu from 'resource:///org/gnome/shell/ui/popupMenu.js';

const GNOME_UNDERCOVER_COMMAND = 'gnome-undercover.sh';
const SETTINGS_COMMAND = 'gnome-undercover-settings.py';

class GnomeUndercoverIndicator extends PanelMenu.Button {
    _init() {
        super._init(0.0, _('GNOME Undercover'));

        this.add_child(new St.Icon({
            icon_name: 'security-high-symbolic', // A placeholder icon
            style_class: 'system-status-icon',
        }));

        // Create Menu Items
        this._buildMenu();
    }

    _buildMenu() {
        // Toggle Item
        this._toggleItem = new PanelMenu.SystemIndicator(); // Or just a MenuItem
        let toggleItem = new PopupMenu.PopupMenuItem(_('Switch Mode'));
        toggleItem.connect('activate', () => this._toggleUndercover());
        this.menu.addMenuItem(toggleItem);

        this.menu.addMenuItem(new PopupMenu.PopupSeparatorMenuItem());

        // Settings Item
        let settingsItem = new PopupMenu.PopupMenuItem(_('Settings'));
        settingsItem.connect('activate', () => this._openSettings());
        this.menu.addMenuItem(settingsItem);
    }

    _toggleUndercover() {
        try {
            // Find the script in standard locations
            const [res, out, err, status] = GLib.spawn_command_line_sync(`which ${GNOME_UNDERCOVER_COMMAND}`);
            if (status === 0) {
                const scriptPath = new TextDecoder().decode(out).trim();
                GLib.spawn_command_line_async(scriptPath);
            } else {
                Main.notifyError('GNOME Undercover', `Script not found: ${GNOME_UNDERCOVER_COMMAND}`);
            }
        } catch (e) {
            Main.notifyError('GNOME Undercover', `Error executing script: ${e.message}`);
        }
    }
    _openSettings() {
        try {
            const [res, out, err, status] = GLib.spawn_command_line_sync(`which ${SETTINGS_COMMAND}`);
            if (status === 0) {
                const scriptPath = new TextDecoder().decode(out).trim();
                GLib.spawn_command_line_async(scriptPath);
            } else {
                Main.notifyError('GNOME Undercover', `Settings app not found: ${SETTINGS_COMMAND}`);
            }
        } catch (e) {
            Main.notifyError('GNOME Undercover', `Error opening settings: ${e.message}`);
        }
    }
}

export default class GnomeUndercoverExtension extends Extension {
    constructor(metadata) {
        super(metadata);
        this._indicator = null;
    }

    enable() {
        this._indicator = new GnomeUndercoverIndicator();
        Main.panel.addToStatusArea(this.uuid, this._indicator);
    }

    disable() {
        this._indicator.destroy();
        this._indicator = null;
    }
}
