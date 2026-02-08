# GNOME Undercover 🕵🏻

[![Build](https://github.com/John-Varghese-EH/Gnome-Undercover/actions/workflows/build-deb.yml/badge.svg)](https://github.com/John-Varghese-EH/Gnome-Undercover/actions/workflows/build-deb.yml)
[![PPA](https://img.shields.io/badge/PPA-Launchpad-E95420?logo=ubuntu&logoColor=white)](https://launchpad.net/gnome-undercover)
[![AUR](https://img.shields.io/badge/AUR-Arch_Linux-1793D1?logo=archlinux&logoColor=white)](https://aur.archlinux.org/packages/gnome-undercover)
[![COPR](https://img.shields.io/badge/COPR-Fedora-51A2DA?logo=fedora&logoColor=white)](https://copr.fedorainfracloud.org/coprs/gnome-undercover/)
[![License](https://img.shields.io/badge/License-GPL--3.0-blue.svg)](LICENSE)
[![GitHub](https://img.shields.io/github/stars/John-Varghese-EH/Gnome-Undercover?style=social)](https://github.com/John-Varghese-EH/Gnome-Undercover)

**Seamlessly transform your GNOME desktop into a convincing Windows 11 environment and back—instantly, with one command or click.**

This project GNOME-Undercover is to use modern Windows 11 themes and a more robust installation process. It provides a simple, one-click script that transforms your GNOME desktop into a polished Windows 11 look-alike, and safely restores your original settings when you switch back.

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

## 📦 Installation via Package Managers

### 🐧 Debian/Ubuntu/Mint/Kali (`apt`)
Hosted via **PPA** (Personal Package Archive).
```bash
sudo add-apt-repository ppa:gnome-undercover/ppa
sudo apt update
sudo apt install gnome-undercover
```
*(Official Launchpad PPA: [launchpad.net/gnome-undercover](https://launchpad.net/gnome-undercover))*

### 🏹 Arch Linux/Manjaro (`pacman`)
Available via **AUR** (Arch User Repository).
```bash
yay -S gnome-undercover
```
*(Note: You need to push the PKGBUILD to the AUR first)*

### 🎩 Fedora/RedHat/OpenSUSE (`dnf`/`zypper`)
Hosted via **COPR**.
```bash
sudo dnf install gnome-undercover
```
*(Note: You need to set up a COPR repository first)*

### 🔧 Manual Install (`.deb` build)
If you prefer building from source:

1. Install build dependencies:
   ```bash
   sudo apt install devscripts build-essential debhelper dh-python python3-all python3-setuptools
   ```
2. Build the package:
   ```bash
   debuild -us -uc
   ```
3. Install:
   ```bash
   sudo dpkg -i ../gnome-undercover_*.deb
   sudo apt install -f  # To fix any missing dependencies
   ```

## 🚀 Installation (Source)

### 1. Clone the Repository

```bash
git clone https://github.com/John-Varghese-EH/Gnome-Undercover.git
cd Gnome-Undercover
```

### 2. Run the Installer

This script will guide you through the process, asking for `sudo` permission only when needed to install required system packages.

```bash
./scripts/gnome-undercover-setup
```

The installer will automatically:
- Install required dependencies (`git`, `gnome-tweaks`, `sassc`, `jq`, etc.).
- Download and set up the Windows 11 themes, icons, wallpaper, and extensions.
- Create a desktop launcher in your application grid.
- Install a panel button for easy access.

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

## Author

**John Varghese**

- GitHub: [@John-Varghese-EH](https://github.com/John-Varghese-EH)
- Instagram: [@cyber__trinity](https://instagram.com/cyber__trinity)

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
