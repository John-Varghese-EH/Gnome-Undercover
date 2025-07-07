# Gnome-Undercover 🕵🏻

**Seamlessly transform your GNOME desktop into a convincing Windows environment and back—instantly, with one command or click.**

Gnome-Undercover is a powerful tool that toggles your GNOME desktop between its native look and a polished Windows-like appearance. Whether you need privacy in public, a professional disguise, or just want to refresh your workspace, Gnome-Undercover makes it effortless.

---

> [!NOTE]
> **🚧 Work in Progress:**  
> Gnome-Undercover is still evolving! Help make it better and faster—contributions, feedback, and ideas are warmly welcome.  
> *Star the repo and join the project!*

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

## 🕵️ Inspiration: Kali Undercover & Why Gnome-Undercover

The popular **Kali Undercover** mode is a fantastic tool for quickly disguising your Kali Linux desktop to look like Windows, providing privacy and blending in during sensitive situations. However, **Kali Undercover has a major limitation: it only supports the Xfce desktop environment**, which is the default for Kali Linux.  
If you use GNOME—a modern, user-friendly, and highly customizable desktop environment—Kali Undercover simply won’t work for you.

**Why GNOME?**  
GNOME is increasingly popular among Kali users for its intuitive interface, advanced productivity features, and extensive customization options. With GNOME, you can enjoy a seamless workflow, elegant design, and access to a wide range of extensions and themes, making it a preferred choice for both new and experienced users.

> *“Kali Linux, a powerful Debian-based distribution widely used for advanced penetration testing and network security assessments, boasts a highly customizable environment. One popular option for enhancing the user interface and improving overall usability is to install GNOME on Kali Linux, a user-friendly desktop environment.”* 

**Gnome-Undercover** fills this gap by bringing undercover functionality to GNOME, allowing Kali users (and anyone running GNOME) to instantly switch between their native desktop and a convincing Windows-like environment—something Kali Undercover cannot do.

---

## 🎉 Fun Add-on: Activate-linux

Want to take your Windows disguise to the next level?  
Pair Gnome-Undercover with [activate-linux](https://github.com/MrGlockenspiel/activate-linux)—a hilarious open-source prank that displays the classic “Activate Windows” watermark on your Linux desktop!

> **Description:**  
> _Fool your friends, colleagues, or even yourself with a touch of Windows authenticity. **Activate-linux** is the perfect companion for your undercover adventures!_

**Try it out:**  
[github.com/MrGlockenspiel/activate-linux](https://github.com/MrGlockenspiel/activate-linux)

---

## 🙏 Credits

- [B00merang Project](https://github.com/B00merang-Project) for Windows 10 themes and icons  
- [Dash to Panel](https://extensions.gnome.org/extension/1160/dash-to-panel/)  
- [Arc Menu](https://extensions.gnome.org/extension/1228/arc-menu/)  

---

## 📜 License

[LICENSE](LICENSE)

---

  [![Buy me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/CyberTrinity)
  [![Patreon](https://img.shields.io/badge/Patreon-F96854?style=for-the-badge&logo=patreon&logoColor=white)](https://patreon.com/CyberTrinity)
  [![Sponsor](https://img.shields.io/badge/sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white)](https://github.com/sponsors/John-Varghese-EH)

---

 Crafted with ❤️ by **[John Varghese](https://github.com/John-Varghese-EH)**  
 [github.com/John-Varghese-EH/Gnome-Undercover](https://github.com/John-Varghese-EH/Gnome-Undercover)
