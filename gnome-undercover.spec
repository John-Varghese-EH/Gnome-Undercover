Name:           gnome-undercover
Version:        1.0.0
Release:        1%{?dist}
Summary:        Transform your GNOME desktop into Windows 10/11

License:        GPL-3.0
URL:            https://github.com/John-Varghese/Gnome-Undercover
Source0:        %{name}-%{version}.tar.gz

BuildArch:      noarch
BuildRequires:  python3-devel
Requires:       python3-gobject gtk4 gnome-shell-extensions gnome-tweaks sassc jq make gettext liberation-fonts

%description
Gnome-Undercover is a tool to make your GNOME desktop look and feel like Windows.
It installs themes, icons, and extensions to mimic the Windows experience.

%prep
%setup -q

%install
mkdir -p %{buildroot}/usr/bin
mkdir -p %{buildroot}/usr/share/gnome-undercover
mkdir -p %{buildroot}/usr/share/applications

install -m 755 scripts/gnome-undercover %{buildroot}/usr/bin/gnome-undercover
install -m 755 scripts/gnome-undercover-settings %{buildroot}/usr/bin/gnome-undercover-settings
install -m 755 scripts/gnome-undercover-setup %{buildroot}/usr/bin/gnome-undercover-setup

cp -r assets %{buildroot}/usr/share/gnome-undercover/
cp -r gnome-undercover-extension %{buildroot}/usr/share/gnome-undercover/
cp gnome-undercover.png %{buildroot}/usr/share/gnome-undercover/

# Create desktop file
cat <<EOF > %{buildroot}/usr/share/applications/gnome-undercover.desktop
[Desktop Entry]
Name=Gnome Undercover
Comment=Transform your desktop
Exec=/usr/bin/gnome-undercover
Icon=/usr/share/gnome-undercover/gnome-undercover.png
Terminal=false
Type=Application
Categories=Utility;
EOF

cat <<EOF > %{buildroot}/usr/share/applications/gnome-undercover-settings.desktop
[Desktop Entry]
Name=Gnome Undercover Settings
Comment=Configure Gnome Undercover
Exec=/usr/bin/gnome-undercover-settings
Icon=preferences-system
Terminal=false
Type=Application
Categories=Settings;
EOF

%files
/usr/bin/gnome-undercover
/usr/bin/gnome-undercover-settings
/usr/bin/gnome-undercover-setup
/usr/share/gnome-undercover/
/usr/share/applications/gnome-undercover.desktop
/usr/share/applications/gnome-undercover-settings.desktop

%changelog
* Sun Feb 08 2026 John Varghese <john@example.com> - 1.0.0-1
- Initial release
