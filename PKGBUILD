# Maintainer: John Varghese <john@example.com>
pkgname=gnome-undercover
pkgver=1.0.0
pkgrel=1
pkgdesc="Transform your GNOME desktop into Windows 10/11"
arch=('any')
url="https://github.com/John-Varghese/Gnome-Undercover"
license=('GPL-3.0')
depends=('bash' 'gnome-shell-extensions' 'gnome-tweaks' 'sassc' 'jq' 'make' 'gettext' 'ttf-liberation' 'python-gobject' 'gtk4')
makedepends=('git')
source=("git+$url.git")
sha256sums=('SKIP')

package() {
	cd "$srcdir/Gnome-Undercover"
    
    # Run the setup script with the system install flag implicity by manually placing files
    # Actually, we can just copy files as our previous manual install logic did.
    
    # 1. Scripts
    install -Dm755 scripts/gnome-undercover "$pkgdir/usr/bin/gnome-undercover"
    install -Dm755 scripts/gnome-undercover-settings "$pkgdir/usr/bin/gnome-undercover-settings"
    install -Dm755 scripts/gnome-undercover-setup "$pkgdir/usr/bin/gnome-undercover-setup"
    
    # 2. Assets (Desktop files, icons)
    install -Dm644 assets/gnome-undercover.desktop "$pkgdir/usr/share/applications/gnome-undercover.desktop"
    
    # We need to construct the settings desktop file manually or copy a pre-made one if we had it.
    # The setup script generates it on the fly. Let's create it here.
    mkdir -p "$pkgdir/usr/share/applications"
    cat <<EOF > "$pkgdir/usr/share/applications/gnome-undercover-settings.desktop"
[Desktop Entry]
Name=Gnome Undercover Settings
Comment=Configure Gnome Undercover
Exec=/usr/bin/gnome-undercover-settings
Icon=preferences-system
Terminal=false
Type=Application
Categories=Settings;
EOF

    # 3. Data files (Extension, specific assets)
    mkdir -p "$pkgdir/usr/share/gnome-undercover"
    cp -r assets "$pkgdir/usr/share/gnome-undercover/"
    cp -r gnome-undercover-extension "$pkgdir/usr/share/gnome-undercover/"
    cp gnome-undercover.png "$pkgdir/usr/share/gnome-undercover/"
    
    # 4. License and Readme
    install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
    install -Dm644 README.md "$pkgdir/usr/share/doc/$pkgname/README.md"
}
