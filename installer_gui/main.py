import sys
import os
import gi
import threading
import subprocess
import shutil
import time

gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, Gdk, GLib

class InstallerWindow(Gtk.Window):
    def __init__(self):
        super().__init__(title="GNOME Undercover Installer")
        self.set_border_width(20)
        self.set_default_size(700, 500)
        self.set_position(Gtk.WindowPosition.CENTER)

        # Default theme options
        self.theme_color = "teal"
        self.tweaks = ["round"]

        self.vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        self.add(self.vbox)

        # --- Stack for Wizard Pages ---
        self.stack = Gtk.Stack()
        self.stack.set_transition_type(Gtk.StackTransitionType.SLIDE_LEFT_RIGHT)
        self.stack.set_transition_duration(500)

        # --- Wizard Pages ---
        page1 = self.create_welcome_page()
        page2 = self.create_dependencies_page()
        page3 = self.create_customization_page()
        page4 = self.create_installation_page()
        page5 = self.create_finished_page()

        self.stack.add_titled(page1, "welcome", "Welcome")
        self.stack.add_titled(page2, "dependencies", "Dependencies")
        self.stack.add_titled(page3, "customize", "Customize")
        self.stack.add_titled(page4, "install", "Install")
        self.stack.add_titled(page5, "finished", "Finished")

        self.vbox.pack_start(self.stack, True, True, 0)

        # --- Navigation Buttons ---
        self.button_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
        self.vbox.pack_start(self.button_box, False, True, 10)

        self.back_button = Gtk.Button(label="Back")
        self.back_button.connect("clicked", self.on_back_clicked)
        self.button_box.pack_start(self.back_button, False, False, 0)

        self.next_button = Gtk.Button(label="Next")
        self.next_button.connect("clicked", self.on_next_clicked)
        self.button_box.pack_end(self.next_button, False, False, 0)

        self.update_nav_buttons()
        self.connect("destroy", Gtk.main_quit)

    def create_welcome_page(self):
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=20)
        title = Gtk.Label()
        title.set_markup("<span size='xx-large' weight='bold'>Welcome to GNOME Undercover</span>")

        subtitle = Gtk.Label(label="This wizard will help you install the theme suite.")
        subtitle.set_line_wrap(True)

        box.pack_start(title, False, False, 10)
        box.pack_start(subtitle, False, False, 10)
        return box

    def create_customization_page(self):
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=20)

        title = Gtk.Label()
        title.set_markup("<span size='large' weight='bold'>Customize Your Theme</span>")
        box.pack_start(title, False, False, 0)

        # Color Theme Selector
        color_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
        color_label = Gtk.Label(label="Accent Color:")
        color_combo = Gtk.ComboBoxText()
        colors = ["Default (Blue)", "Teal", "Green", "Red", "Orange", "Purple", "Pink", "Grey"]
        for color in colors:
            color_combo.append_text(color)
        color_combo.set_active(1) # Default to Teal
        color_combo.connect("changed", self.on_color_combo_changed)
        color_box.pack_start(color_label, False, False, 0)
        color_box.pack_start(color_combo, False, False, 0)
        box.pack_start(color_box, False, False, 10)

        # Tweaks
        tweaks_label = Gtk.Label(label="Visual Tweaks:")
        box.pack_start(tweaks_label, False, False, 0)

        round_check = Gtk.CheckButton(label="Use rounded window corners")
        round_check.set_active(True)
        round_check.connect("toggled", self.on_tweak_toggled, "round")
        box.pack_start(round_check, False, False, 0)

        blur_check = Gtk.CheckButton(label="Enable blur effect (requires 'Blur My Shell' extension)")
        blur_check.set_active(False)
        blur_check.connect("toggled", self.on_tweak_toggled, "blur")
        box.pack_start(blur_check, False, False, 0)

        return box

    def on_color_combo_changed(self, combo):
        text = combo.get_active_text()
        if text:
            # Convert "Default (Blue)" to "default" for the script
            if text == "Default (Blue)":
                self.theme_color = "default"
            else:
                self.theme_color = text.lower()
            print(f"Theme color set to: {self.theme_color}")

    def on_tweak_toggled(self, button, name):
        if button.get_active():
            if name not in self.tweaks:
                self.tweaks.append(name)
        else:
            if name in self.tweaks:
                self.tweaks.remove(name)
        print(f"Current tweaks: {self.tweaks}")

    def create_installation_page(self):
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)

        title = Gtk.Label()
        title.set_markup("<span size='large' weight='bold'>Installation Progress</span>")
        box.pack_start(title, False, False, 0)

        self.install_progress = Gtk.ProgressBar()
        box.pack_start(self.install_progress, False, False, 10)

        sw = Gtk.ScrolledWindow()
        sw.set_shadow_type(Gtk.ShadowType.IN)
        self.install_textview = Gtk.TextView()
        self.install_textview.set_editable(False)
        sw.add(self.install_textview)
        box.pack_start(sw, True, True, 0)

        self.start_install_button = Gtk.Button(label="Start Installation")
        self.start_install_button.connect("clicked", self.on_start_installation_clicked)
        box.pack_start(self.start_install_button, False, False, 10)

        return box

    def create_finished_page(self):
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=20)
        title = Gtk.Label()
        title.set_markup("<span size='xx-large' weight='bold'>Installation Complete!</span>")

        subtitle = Gtk.Label(label="You can now close this installer and use the theme switcher.")
        box.pack_start(title, False, False, 10)
        box.pack_start(subtitle, False, False, 10)

        close_button = Gtk.Button(label="Close")
        close_button.connect("clicked", Gtk.main_quit)
        box.pack_start(close_button, False, False, 10)

        return box

    def on_start_installation_clicked(self, widget):
        self.start_install_button.set_sensitive(False)
        self.back_button.set_sensitive(False)
        self.next_button.set_sensitive(False)

        thread = threading.Thread(target=self._installation_thread)
        thread.daemon = True
        thread.start()

    def _installation_thread(self):
        # --- Helper Functions for Thread ---
        def update_log(text):
            GLib.idle_add(self.install_textview.get_buffer().insert, self.install_textview.get_buffer().get_end_iter(), text, -1)

        def update_progress(fraction, text):
            GLib.idle_add(self.install_progress.set_fraction, fraction)
            GLib.idle_add(self.install_progress.set_text, text)

        def run_command(command, cwd=None):
            update_log(f"\n$ {' '.join(command)}\n")
            process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, cwd=cwd)
            for line in iter(process.stdout.readline, ''):
                update_log(line)
            process.wait()
            if process.returncode != 0:
                raise subprocess.CalledProcessError(process.returncode, command)

        # --- Installation Logic ---
        try:
            HOME = os.path.expanduser("~")
            TEMP_DIR = "/tmp/gnome-undercover-build"
            THEME_DIR_USER = os.path.join(HOME, ".themes")
            ICONS_DIR_USER = os.path.join(HOME, ".icons")
            EXTENSIONS_DIR_USER = os.path.join(HOME, ".local/share/gnome-shell/extensions")

            # 1. Create temp dir
            update_progress(0.05, "Creating temporary directory...")
            if os.path.exists(TEMP_DIR):
                shutil.rmtree(TEMP_DIR)
            os.makedirs(TEMP_DIR)

            # 2. Clone Repos
            update_progress(0.1, "Cloning theme repositories...")
            run_command(["git", "clone", "https://github.com/vinceliuice/Fluent-gtk-theme.git"], cwd=TEMP_DIR)
            run_command(["git", "clone", "https://github.com/vinceliuice/Fluent-icon-theme.git"], cwd=TEMP_DIR)
            run_command(["git", "clone", "https://github.com/KaizIqbal/Bibata_Cursor.git"], cwd=TEMP_DIR)

            # 3. Install Themes
            update_progress(0.4, "Installing themes...")
            tweaks_str = " ".join(self.tweaks)
            run_command(["./install.sh", "--tweaks", tweaks_str, "-c", "dark", "-t", self.theme_color, "--dest", THEME_DIR_USER], cwd=os.path.join(TEMP_DIR, "Fluent-gtk-theme"))
            run_command(["./install.sh", "-c", self.theme_color, "--dest", ICONS_DIR_USER], cwd=os.path.join(TEMP_DIR, "Fluent-icon-theme"))
            run_command(["./install.sh"], cwd=os.path.join(TEMP_DIR, "Bibata_Cursor"))

            # 4. Install Core Files & Extension (This part is simplified for brevity)
            update_progress(0.8, "Installing core files and extension...")
            # In a real app, you would copy files from the project dir
            # For now, we assume they are in the right place relative to the installer
            update_log("\nSkipping core file installation in this simulated environment.\n")
            update_log("Skipping extension installation in this simulated environment.\n")

            # Finalize
            update_progress(1.0, "Installation Complete!")
            update_log("\n--- Installation Successful! ---\n")
            GLib.idle_add(self.stack.set_visible_child_name, "finished")

        except (subprocess.CalledProcessError, FileNotFoundError, Exception) as e:
            error_message = f"\n--- AN ERROR OCCURRED ---\n{e}\n"
            update_log(error_message)
            update_progress(0.0, "Installation Failed!")
            GLib.idle_add(self.start_install_button.set_sensitive, True)
            GLib.idle_add(self.back_button.set_sensitive, True)

    def create_dependencies_page(self):
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)

        title = Gtk.Label()
        title.set_markup("<span size='large' weight='bold'>Dependency Check</span>")
        box.pack_start(title, False, False, 0)

        sw = Gtk.ScrolledWindow()
        sw.set_shadow_type(Gtk.ShadowType.IN)
        self.deps_textview = Gtk.TextView()
        self.deps_textview.set_editable(False)
        self.deps_textview.set_cursor_visible(False)
        sw.add(self.deps_textview)
        box.pack_start(sw, True, True, 0)

        self.deps_check_button = Gtk.Button(label="Check Dependencies")
        self.deps_check_button.connect("clicked", self.on_check_dependencies_clicked)
        box.pack_start(self.deps_check_button, False, False, 10)

        self.deps_install_button = Gtk.Button(label="Install Missing Dependencies")
        self.deps_install_button.set_sensitive(False)
        self.deps_install_button.connect("clicked", self.on_install_dependencies_clicked)
        box.pack_start(self.deps_install_button, False, False, 0)

        return box

    def on_install_dependencies_clicked(self, widget):
        self.deps_install_button.set_sensitive(False)
        self.log_to_deps_textview("\n--- Starting Dependency Installation ---\n")
        self.log_to_deps_textview("You may be prompted for your password.\n")

        thread = threading.Thread(target=self._install_dependencies_thread)
        thread.daemon = True
        thread.start()

    def _install_dependencies_thread(self):
        # This is a simplified example. A real app would need more robust package manager detection.
        # It also uses 'pkexec' to ask for privilege escalation graphically.
        command = []
        try:
            if subprocess.run(["which", "apt"], check=True, capture_output=True).returncode == 0:
                command = ["pkexec", "apt", "install", "-y", "git", "jq", "sassc", "gnome-shell-extensions", "gnome-tweaks", "libglib2.0-dev"]
        except (subprocess.CalledProcessError, FileNotFoundError):
            try:
                if subprocess.run(["which", "dnf"], check=True, capture_output=True).returncode == 0:
                    command = ["pkexec", "dnf", "install", "-y", "git", "jq", "sassc", "gnome-shell-extensions", "gnome-tweaks", "glib2-devel"]
            except (subprocess.CalledProcessError, FileNotFoundError):
                 GLib.idle_add(self.log_to_deps_textview, "Error: Unsupported package manager (only apt and dnf are supported in this demo).\n")
                 return

        if command:
            process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
            for line in iter(process.stdout.readline, ''):
                GLib.idle_add(self.log_to_deps_textview, line)

            process.wait()

            if process.returncode == 0:
                GLib.idle_add(self.log_to_deps_textview, "\n--- Dependency Installation Successful ---\n")
                GLib.idle_add(self.next_button.set_sensitive, True)
            else:
                GLib.idle_add(self.log_to_deps_textview, "\n--- Dependency Installation Failed ---\n")
                GLib.idle_add(self.deps_install_button.set_sensitive, True)

    def on_check_dependencies_clicked(self, widget):
        self.deps_check_button.set_sensitive(False)
        self.log_to_deps_textview("Checking for required packages...\n\n")

        thread = threading.Thread(target=self._check_dependencies_thread)
        thread.daemon = True
        thread.start()

    def _check_dependencies_thread(self):
        deps = ["git", "jq", "sassc", "gnome-shell", "python3-gi", "gir1.2-gtk-3.0"]
        missing_deps = []

        for dep in deps:
            try:
                # Use subprocess.run to check for command existence
                subprocess.run(["which", dep], check=True, capture_output=True)
                GLib.idle_add(self.log_to_deps_textview, f"✔ {dep} ... [FOUND]\n")
            except (subprocess.CalledProcessError, FileNotFoundError):
                GLib.idle_add(self.log_to_deps_textview, f"✖ {dep} ... [MISSING]\n")
                missing_deps.append(dep)

        if not missing_deps:
            GLib.idle_add(self.log_to_deps_textview, "\nAll dependencies are installed!")
            GLib.idle_add(self.next_button.set_sensitive, True)
        else:
            GLib.idle_add(self.log_to_deps_textview, "\nSome dependencies are missing. Please install them.")
            GLib.idle_add(self.deps_install_button.set_sensitive, True)

    def log_to_deps_textview(self, text):
        buffer = self.deps_textview.get_buffer()
        buffer.insert(buffer.get_end_iter(), text, -1)
        return False # Required for GLib.idle_add

    def on_back_clicked(self, widget):
        current_name = self.stack.get_visible_child_name()
        children = self.stack.get_children()

        current_index = -1
        for i, child in enumerate(children):
            if self.stack.get_child_name(child) == current_name:
                current_index = i
                break

        if current_index > 0:
            prev_child = children[current_index - 1]
            self.stack.set_visible_child(prev_child)

        self.update_nav_buttons()

    def on_next_clicked(self, widget):
        current_name = self.stack.get_visible_child_name()
        children = self.stack.get_children()

        current_index = -1
        for i, child in enumerate(children):
            if self.stack.get_child_name(child) == current_name:
                current_index = i
                break

        if current_index < len(children) - 1:
            next_child = children[current_index + 1]
            self.stack.set_visible_child(next_child)

        self.update_nav_buttons()

    def update_nav_buttons(self):
        current_name = self.stack.get_visible_child_name()
        children = self.stack.get_children()

        current_index = -1
        for i, child in enumerate(children):
            if self.stack.get_child_name(child) == current_name:
                current_index = i
                break

        self.back_button.set_sensitive(current_index > 0)
        self.next_button.set_sensitive(current_index < len(children) - 1)

def main():
    win = InstallerWindow()
    win.show_all()
    Gtk.main()

if __name__ == "__main__":
    sys.exit(main())
