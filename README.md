# GNOME Undercover 🕵🏻

**Seamlessly transform your GNOME desktop into a convincing Windows 11 environment and back—instantly.**

This project provides a simple, graphical installer to transform your modern GNOME desktop into a polished Windows 11 look-alike, and a one-click script to switch back and forth.

It's perfect for privacy, for working in public spaces, or for users who prefer the Windows UI but love the power of Linux underneath.

---

## ✨ Features

- **Graphical Installation Wizard:** A user-friendly, step-by-step installer guides you through the setup.
- **Interactive Customization:** Choose your favorite accent color and visual tweaks during installation.
- **One-Click Transformation:** After installation, instantly switch between your native GNOME desktop and the Windows 11 look.
- **Complete Visual Overhaul:** Changes the GTK, Shell, icon, and cursor themes, plus the wallpaper.
- **Authentic Windows 11 Shell:** Automatically configures Dash to Panel and Arc Menu to create a convincing taskbar and start menu.
- **Safe Backup & Restore:** Your original theme settings are safely backed up and restored when you toggle the theme.

---

## 🚀 Installation

The installation is handled by a graphical wizard.

### 1. Clone the Repository

```bash
git clone https://github.com/John-Varghese-EH/Gnome-Undercover.git
cd Gnome-Undercover
```

### 2. Run the Installer

The installer will first check for necessary dependencies (like `git`, `python3-gi`, etc.) and guide you through installing them if they are missing.

```bash
python3 installer_gui/main.py
```

Follow the on-screen instructions in the wizard to customize and install the theme suite.

---

## 🖱️ Usage

After installation, you can switch between "Windows 11 Mode" and your original GNOME desktop in two ways:

- **From the App Grid:**  
  Search for “GNOME Undercover” in your applications and click the icon to toggle modes.

- **From the Panel:**
  Click the new icon in your panel to toggle modes.

**How it Works:**
- **First run:** Your original GNOME settings are backed up, and the Windows 11 look is applied.
- **Second run (or next click):** Your original GNOME appearance is restored.

---

## 🧹 Uninstallation

Currently, uninstallation is a manual process. A future version of the graphical installer will include an uninstallation option.

To manually remove the components, you will need to:
1.  Delete the theme files from `~/.themes` and `~/.icons`.
2.  Delete the core script from `~/.local/bin`.
3.  Delete the `.desktop` file from `~/.local/share/applications`.
4.  Disable and remove the `gnome-undercover@...` extension from `~/.local/share/gnome-shell/extensions`.
5.  Delete the configuration directory at `~/.config/gnome-undercover`.

---

## 🙏 Credits

This project stands on the shoulders of giants. It would not be possible without the amazing work of the open-source community. Special thanks to the creators of the themes and extensions used:

- **Fluent GTK & Icon Themes:** Created by [vinceliuice](https://github.com/vinceliuice)
- **Bibata Cursor Theme:** Created by [KaizIqbal](https://github.com/KaizIqbal)
- **Dash to Panel Extension:** Developed by the [Dash to Panel Team](https://github.com/home-sweet-gnome/dash-to-panel)
- **ArcMenu Extension:** Developed by the [ArcMenu Team](https://gitlab.com/arcmenu/ArcMenu)

---

## 📜 License

This project is licensed under the **GPLv3**.
