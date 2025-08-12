# GNOME Undercover 🕵🏻

**Seamlessly transform your GNOME desktop into a convincing Windows 11 environment and back—instantly, with one command or click.**

This project is an enhanced version of the original Gnome-Undercover concept, rebuilt to use modern Windows 11 themes and a more robust installation process. It provides a simple, one-click script that transforms your GNOME desktop into a polished Windows 11 look-alike, and safely restores your original settings when you switch back.

---

> [!NOTE]
> **🚧 Work in Progress:**  
> This project is actively being developed! Help make it better and faster—contributions, feedback, and ideas are warmly welcome.
> *Star the repo and join the project!*

---

## ✨ Features

- **One-Click Transformation:** Instantly switch between your native GNOME desktop and a Windows 11 look.
- **Complete Visual Overhaul:** Changes the GTK, Shell, icon, and cursor themes, plus the wallpaper.
- **Authentic Windows 11 Shell:** Automatically enables and configures Dash to Panel and Arc Menu to create a convincing taskbar and start menu.
- **Safe Backup & Restore:** Your original theme and extension settings are safely backed up before the first switch and perfectly restored when you toggle back.
- **Easy to Use:** Launch the switcher from your applications menu or a dedicated panel button.
- **Automated Installation:** A single, user-friendly script handles all dependencies and setup.

---

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/John-Varghese-EH/Gnome-Undercover.git
cd Gnome-Undercover
```

### 2. Run the Installer

This script will guide you through the process, asking for `sudo` permission only when needed to install required system packages.

```bash
chmod +x install.sh
./install.sh
```

The installer will guide you through the following steps:
1.  **Dependency Check:** It will verify you have all the necessary software and ask for permission to install anything that's missing.
2.  **Theme Customization:** It will present you with an interactive menu to choose your preferred color theme and enable optional tweaks like the blur effect.
3.  **Installation:** It will then download and install all the themes, icons, scripts, and extensions based on your selections.

---

## 🖱️ Usage

After installation, you can switch between "Windows 11 Mode" and your original GNOME desktop in two ways:

- **From the App Grid:**  
  Search for “GNOME Undercover” in your applications and click the icon to toggle modes.

- **From the Panel:**
  Click the new icon in your top panel to toggle modes.

**How it Works:**
- **First run:** Your original GNOME settings are backed up, and the Windows 11 look is applied.
- **Second run (or next click):** Your original GNOME appearance is restored.

---

## 🧹 Uninstallation

To completely remove Gnome-Undercover and all its components, run the uninstallation script from the project directory:

```bash
chmod +x uninstall.sh
./uninstall.sh
```
This will safely restore your original settings, remove all installed themes and icons, and delete the scripts and launchers.

---

## 🙏 Credits

This project stands on the shoulders of giants. It would not be possible without the amazing work of the open-source community. Special thanks to the creators of the themes and extensions used:

- **Fluent GTK & Icon Themes:** Created by [vinceliuice](https://github.com/vinceliuice)
- **Bibata Cursor Theme:** Created by [KaizIqbal](https://github.com/KaizIqbal)
- **Dash to Panel Extension:** Developed by the [Dash to Panel Team](https://github.com/home-sweet-gnome/dash-to-panel)
- **ArcMenu Extension:** Developed by the [ArcMenu Team](https://gitlab.com/arcmenu/ArcMenu)

---

## 📜 License

This project is licensed under the **GPLv3**. See the `LICENSE` file for details.
