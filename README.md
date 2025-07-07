# Gnome-Undercover

**Seamlessly transform your GNOME desktop into a convincing Windows environment and back—instantly, with one command or click.**

---

Gnome-Undercover is a powerful tool that toggles your GNOME desktop between its native look and a polished Windows-like appearance. Whether you need privacy in public, a professional disguise, or just want to refresh your workspace, Gnome-Undercover makes it effortless.

---

## ✨ Features

- **One-Click Transformation:** Instantly switch between GNOME and Windows-like layouts.
- **Comprehensive Theming:** Changes GTK, Shell, icons, wallpaper, GNOME Terminal profile, and more.
- **Extension Automation:** Enables Dash to Panel and Arc Menu for an authentic Windows taskbar and start menu.
- **Atomic Backup & Restore:** Your original GNOME settings are safely backed up and restored.
- **App Launcher Integration:** Launch Gnome-Undercover directly from your app grid with a custom icon.
- **Professional Polish:** Designed for reliability, security, and a seamless user experience.

---

## 🚀 Quick Start

### 1. Clone the Repository

```
git clone https://github.com/John-Varghese-EH/Gnome-Undercover.git
cd Gnome-Undercover
```

### 2. Install (Run as User)

```
chmod +x install-gnome-undercover.sh gnome-undercover.sh
./install-gnome-undercover.sh
```

This will:
- Install required dependencies
- Download and set up Windows-like themes, icons, wallpaper, and extensions
- Create a desktop launcher in your application grid

---

## 🖱️ Usage

- **From the App Grid:**  
  Search for “Gnome-Undercover” in your applications and click the icon to toggle modes.

- **From the Terminal:**  
```
./gnome-undercover.sh
```

- **What Happens:**  
- **First run:** Your GNOME settings are backed up and the Windows-like look is applied.
- **Second run (or next click):** Your original GNOME appearance is restored.

---

## 🎨 Customization

- **Themes & Icons:**  
Edit `gnome-undercover.sh` to change the theme or icon set.
- **Extensions:**  
Add or remove GNOME Shell extensions for a more tailored experience.
- **Wallpaper:**  
Replace `gnome-undercover.png` and update the script for a personalized touch.

---

## 🛠️ Troubleshooting

- **Launcher Not Visible?**  
Log out and back in, or run:
```
update-desktop-database ~/.local/share/applications
```
- **Theme/Extension Issues?**  
Ensure your GNOME version is compatible and all dependencies are installed.

---

## 🧹 Uninstallation

To remove all installed resources:

```
sudo rm -rf /usr/share/themes/Windows-10
sudo rm -rf /usr/share/icons/Windows-10
sudo rm -rf /usr/share/backgrounds/Windows10
rm -rf ~/.local/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com
rm -rf ~/.local/share/gnome-shell/extensions/arc-menu@linxgem33.com
rm -f ~/.local/share/applications/gnome-undercover.desktop
```
---

## 🙏 Credits

- [B00merang Project](https://github.com/B00merang-Project) for Windows 10 themes and icons  
- [Dash to Panel](https://extensions.gnome.org/extension/1160/dash-to-panel/)  
- [Arc Menu](https://extensions.gnome.org/extension/1228/arc-menu/)  

---

## 📜 License

[LICENSE](LICENSE)

---

> Crafted with ❤️ by **[John Varghese](https://github.com/John-Varghese-EH)**  
> [github.com/John-Varghese-EH/Gnome-Undercover](https://github.com/John-Varghese-EH/Gnome-Undercover)
