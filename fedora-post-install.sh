#!/bin/bash

function enable_repos() {
    echo "===Enabling Repositories==="
    sleep 1
    sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
    sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
}

function upgrade() {
    echo "===Upgrading System==="
    sleep 1
    sudo dnf upgrade -y
}

function install_apps() {
    echo "===Installing Applications==="
    sleep 1
    # Repos
    echo "Installing from repositories..."
    sudo dnf groupinstall "Development Tools" -y
    sudo dnf group install --with-optional virtualization -y
    sudo dnf install gnome-tweaks gnome-extensions-app gnome-console simple-scan gparted adw-gtk3-theme libreoffice evince code steam mixxx xournalpp gcc gcc-c++ gdb cmake meson ninja-build blueprint-compiler libadwaita webp-pixbuf-loader fastfetch curl wget cabextract xorg-x11-font-utils fontconfig openssl ffmpeg aria2 yt-dlp libunity yelp-tools cava intltool sqlitebrowser gnuplot chromaprint-tools nodejs npm fop mm-common ruby tomcat hunspell-it langpacks-it flatpak-builder dconf-editor libvirt qemu dnsmasq nbd doxygen gnome-firmware -y --allowerasing
    sudo dnf install https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm -y
    sudo dnf install java-latest-openjdk-devel libadwaita-devel gtk4-devel-tools gtk4-devel gettext-devel glib2-devel gtest-devel json-devel libcurl-devel openssl-devel libsecret-devel libuuid-devel boost-devel libidn-devel libxml2-devel mm-devel boost-devel -y --allowerasing
    sudo dnf remove gnome-terminal -y
    # Flatpak
    echo "Installing from Flatpak..."
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
    flatpak update
    flatpak install -y flathub org.gnome.Sdk//47 org.gnome.Platform//47 org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark org.nickvision.tagger org.nickvision.tubeconverter org.nickvision.money org.nickvision.cavalier io.github.realmazharhussain.GdmSettings org.gnome.design.IconLibrary com.github.tchx84.Flatseal it.mijorus.smile org.gnome.seahorse.Application re.sonny.Workbench app.drey.Biblioteca io.gitlab.adhami3310.Impression org.gnome.Fractal com.mojang.Minecraft io.mrarm.mcpelauncher org.onlyoffice.desktopeditors io.github.shiftey.Desktop com.discordapp.Discord org.gnome.NetworkDisplays com.github.neithern.g4music
    # MEGA
    cd ~
    wget https://mega.nz/linux/repo/Fedora_40/x86_64/megasync-Fedora_40.x86_64.rpm -O megasync.rpm
    sudo dnf install megasync.rpm -y
    rm megasync.rpm
    # Qt6
    read -p "Install Qt6 [y/N]: " QT6
    if [ "$QT6" == "y" ]; then
        sudo dnf install "qt6-*" -y
    fi
    # keyd
    read -p "Install keyd & remap Copilot key [y/N]: " KEYD
    if [ "$KEYD" == "y" ]; then
        sudo dnf copr enable alternateved/keyd
        sudo dnf install keyd -y
        sudo mkdir -p /etc/keyd
        sudo touch /etc/keyd/default.conf
        echo "[ids]" | sudo tee -a /etc/keyd/default.conf
        echo "*" | sudo tee -a /etc/keyd/default.conf
        echo "[main]" | sudo tee -a /etc/keyd/default.conf
        echo "f23+leftshift+leftmeta = overload(control, esc)" | sudo tee -a /etc/keyd/default.conf
        sudo systemctl enable keyd
        sudo systemctl start keyd
    fi
}

function configure_user() {
    echo "===Configuring User==="
    sleep 1
    # Add user to groups
    echo "Configuring user groups..."
    sudo usermod -a -G tomcat $USER
    sudo usermod -a -G lp $USER
    sudo usermod -G libvirt -a $USER
    # Configure git
    echo "Configuring git..."
    git config --global protocol.file.allow always
    git config --global http.postBuffer 524288000
    # Configure bash
    echo "Configuring bash..."
    echo "fastfetch" >> ~/.bashrc
    echo 'alias system-update="sudo dnf upgrade; flatpak update"' >> ~/.bashrc
    # Configure GNOME settings
    echo "Configuring GNOME settings..."
    read -p "Set dark theme [y/N]: " DARK
    if [ "$DARK" == "y" ]; then
        gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3-dark
        gsettings set org.gnome.desktop.interface color-scheme prefer-dark
    else
        gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3
    fi
    read -p "Use 12-hour time format [y/N]: " TIME
    if [ "$TIME" == "y" ]; then
        gsettings set org.gnome.desktop.interface clock-format '12h'
    fi
    gsettings set org.gnome.desktop.interface clock-show-weekday true
    gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'
    gsettings set org.gnome.desktop.interface show-battery-percentage true
    gsettings set org.gnome.mutter center-new-windows true
    gsettings set org.gnome.mutter workspaces-only-on-primary false
    gsettings set org.gnome.desktop.peripherals.touchpad click-method 'areas'
    gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing false
    gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
    gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
    gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true
    gsettings set org.gnome.desktop.session idle-delay 900
    # Firefox theme
    firefox
    echo "Installing Firefox theme..."
    curl -s -o- https://raw.githubusercontent.com/rafaelmardojai/firefox-gnome-theme/master/scripts/install-by-curl.sh | bash
}

function configure_system() {
    echo "===Configuring System==="
    sleep 1
    # Configure hostname
    echo "Configuring hostname..."
    echo "Current hostname: $(hostname)"
    read -p "New hostname: " NEWHOST
    sudo hostnamectl set-hostname $NEWHOST
    # Enable and start services
    echo "Enabling and starting services..."
    sudo systemctl enable libvirtd
    sudo systemctl start libvirtd
    # Enable SSH Connection
    read -p "Enable SSH Connection [y/N]: " REMOTE
    if [ "$REMOTE" == "y" ]; then
        sudo systemctl enable sshd
        sudo systemctl start sshd
        sudo firewall-cmd --zone=public --add-service=ssh --permanent
    fi
    sudo firewall-cmd --reload
}

function install_gnome_extensions() {
    echo "===GNOME Extensions==="
    read -p "Install GNOME extensions [y/N]: " INSTALL
    if [ "$INSTALL" == "y" ]; then
        array=(https://extensions.gnome.org/extension/4269/alphabetical-app-grid/
            https://extensions.gnome.org/extension/615/appindicator-support/
            https://extensions.gnome.org/extension/4362/fullscreen-avoider/
            https://extensions.gnome.org/extension/5506/user-avatar-in-quick-settings/
            https://extensions.gnome.org/extension/1108/add-username-to-top-panel/
            https://extensions.gnome.org/extension/5500/auto-activities/
            https://extensions.gnome.org/extension/6096/smile-complementary-extension/
            https://extensions.gnome.org/extension/5410/grand-theft-focus/
            https://extensions.gnome.org/extension/7048/rounded-window-corners-reborn/)
        for i in "${array[@]}"; do
            EXTENSION_ID=$(curl -s $i | grep -oP 'data-uuid="\K[^"]+')
            VERSION_TAG=$(curl -Lfs "https://extensions.gnome.org/extension-query/?search=$EXTENSION_ID" | jq '.extensions[0] | .shell_version_map | map(.pk) | max')
            wget -O ${EXTENSION_ID}.zip "https://extensions.gnome.org/download-extension/${EXTENSION_ID}.shell-extension.zip?version_tag=$VERSION_TAG"
            gnome-extensions install --force ${EXTENSION_ID}.zip
            if ! gnome-extensions list | grep --quiet ${EXTENSION_ID}; then
                busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s ${EXTENSION_ID}
            fi
            gnome-extensions enable ${EXTENSION_ID}
            rm ${EXTENSION_ID}.zip
        done
        read -p "Disable extension version validation [y/N]: " VALIDATION
        if [ "$VALIDATION" == "y" ]; then
            gsettings set org.gnome.shell disable-extension-version-validation true
        fi
    fi
}

function install_cpp_libraries() {
    echo "===C++ Libraries==="
    read -p "Build and install C++ libraries [y/N]: " BUILD
    if [ "$BUILD" == "y" ]; then
        # maddy
        echo "Maddy..."
        cd ~
        git clone --depth 1 --branch "1.3.0" https://github.com/progsource/maddy
        sudo mkdir -p /usr/include/maddy
        sudo mv maddy/include/maddy/* /usr/include/maddy
        rm -rf ~/maddy
        # libxml++
        echo "Libxml++..."
        cd ~
        git clone --depth 1 --branch "5.4.0" https://github.com/libxmlplusplus/libxmlplusplus
        cd libxmlplusplus
        meson setup --prefix /usr --libdir lib64 --reconfigure -Dmaintainer-mode=false out-linux .
        cd out-linux
        ninja
        sudo ninja install
        rm -rf ~/libxmlplusplus
        # libnick
        echo "Libnick..."
        cd ~
        git clone --depth 1 --branch "2024.10.0" https://github.com/NickvisionApps/libnick/
        mkdir -p libnick/build
        cd libnick/build
        cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING="OFF" -DCMAKE_INSTALL_PREFIX=/usr
        cmake --build .
        sudo cmake --install .
        rm -rf ~/libnick
        cd ~
    fi
}

function setup_zsh() {
    echo "===ZSH==="
    read -p "Setup ZSH [y/N]: " INSTALL
    if [ "$INSTALL" == "y" ]; then
        sudo dnf install zsh -y
        if command -v curl >/dev/null 2>&1; then
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
        else
            sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
        fi
        # Configure
        sed -i '/z4h install ohmyzsh\/ohmyzsh || return/a fastfetch' ~/.zshrc
        echo 'alias system-update="sudo dnf upgrade; flatpak update"' >> ~/.zshrc
    fi
}

function display_links() {
    echo "===Data Drive Instructions==="
    echo "https://community.linuxmint.com/tutorial/view/1609"
}

cd ~
echo "===Fedora Post Install Script==="
echo "by Nicholas Logozzo <nlogozzo>"
echo
echo "This script is meant to be used on Fedora 40 systems."
echo
echo "Please stay attentive during the installation process,"
echo "as you may need to enter your password and answer"
echo "prompts multiple times."
echo
read -p "Continue [y/N]: " CONTINUE
if [ "$CONTINUE" == "y" ]; then
    enable_repos
    upgrade
    install_apps
    configure_user
    configure_system
    install_gnome_extensions
    install_cpp_libraries
    setup_zsh
    display_links
    echo "===Reboot==="
    read -p "Reboot [y/N]: " REBOOT
    if [ "$REBOOT" == "y" ]; then
        sudo reboot
    else
        echo "A reboot is required before using the"
        echo "newly installed applications and services."
    fi
    echo "===DONE==="
fi
