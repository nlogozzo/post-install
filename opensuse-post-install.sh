#!/bin/bash

function enable_repos() {
    echo "===Enabling Repositories==="
    sleep 1
    sudo zypper -n install libicu wget
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/zypp/repos.d/vscode.repo'
    wget https://packages.microsoft.com/config/opensuse/15/prod.repo
    sudo mv prod.repo /etc/zypp/repos.d/microsoft-prod.repo
    sudo chown root:root /etc/zypp/repos.d/microsoft-prod.repo
    sudo zypper addrepo https://download.opensuse.org/repositories/home:Dead_Mozay/openSUSE_Tumbleweed/home:Dead_Mozay.repo
}

function upgrade() {
    echo "===Upgrading System==="
    sleep 1
    sudo zypper refresh
    sudo zypper dup
}

function install_apps() {
    echo "===Installing Apps==="
    sleep 1
    sudo zypper install --recommends --type pattern devel_basis devel_C_C++ kvm_server kvm_tools devel_qt6
    sudo zypper install MozillaFirefox-branding-upstream libreoffice-branding-upstream epiphany-branding-upstream gdm-branding-upstream gio-branding-upstream gnome-menus-branding-upstream gtk2-branding-upstream gtk3-branding-upstream gtk4-branding-upstream
    sudo zypper install qemu libvirt opi QGnomePlatform-qt5 QGnomePlatform-qt6 firefox gnome-calendar gnome-sound-recorder gnome-tweaks gnome-extensions gnome-console loupe epiphany simple-scan gparted libreoffice xournalpp evince code git-lfs gcc gcc-c++ clang-tools rust cmake meson ninja java-17-openjdk blueprint-compiler gtk4-tools webp-pixbuf-loader steam fastfetch curl unzip git nano cabextract fontconfig gimp inkscape krita openssl ffmpeg aria2 yt-dlp yelp yelp-tools yelp-xsl cava intltool sqlitebrowser gnuplot chromaprint-fpcalc libchromaprint1 mm-common flatpak flatpak-builder dconf-editor fetchmsttfonts libxml2 adw-gtk3 adw-gtk3-dark gnome-backgrounds gnome-remote-desktop python311-requirements-parser doxygen gnome-firmware
    sudo zypper install java-17-openjdk-devel gtk4-devel libadwaita-devel glib2-devel libcurl-devel python311-devel openssl-devel gettext-devel libxml2-devel libsecret-devel libuuid-devel rapidcsv-devel
    sudo zypper install "libboost*"
    sudo zypper -n remove gnome-terminal nautilus-extension-terminal gnome-music eog evolution vinagre xterm file-roller git-gui lightsoff gnome-mines iagno quadrapassel swell-foop gnome-sudoku
    sudo zypper -n remove -u patterns-gnome-gnome_games
    opi codecs
    # Flatpak
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
    sudo flatpak update
    sudo flatpak install -y flathub org.gnome.Sdk//47 org.gnome.Platform//47 org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark org.nickvision.tagger org.nickvision.tubeconverter org.nickvision.money org.nickvision.cavalier io.github.realmazharhussain.GdmSettings org.gnome.design.IconLibrary com.github.tchx84.Flatseal it.mijorus.smile org.gnome.seahorse.Application re.sonny.Workbench app.drey.Biblioteca io.gitlab.adhami3310.Impression org.gnome.Fractal com.mojang.Minecraft io.mrarm.mcpelauncher org.onlyoffice.desktopeditors io.github.shiftey.Desktop com.discordapp.Discord org.gnome.NetworkDisplays com.github.neithern.g4music
    # Megasync
    wget https://mega.nz/linux/repo/openSUSE_Tumbleweed/x86_64/megasync-openSUSE_Tumbleweed.x86_64.rpm
    sudo zypper install "megasync-openSUSE_Tumbleweed.x86_64.rpm"
    rm -rf megasync-openSUSE_Tumbleweed.x86_64.rpm
    # keyd
    read -p "Install keyd & remap Copilot key [y/N]: " KEYD
    if [ "$KEYD" == "y" ]; then
        sudo zypper install keyd
        sudo mkdir -p /etc/keyd
        sudo touch /etc/keyd/default.conf
        echo "[ids]" | sudo tee -a /etc/keyd/default.conf
        echo "*" | sudo tee -a /etc/keyd/default.conf
        echo "[main]" | sudo tee -a /etc/keyd/default.conf
        echo "f23+leftshift+leftmeta = overload(control, esc)" | sudo tee -a /etc/keyd/default.conf
        sudo systemctl enable keyd
        sudo systemctl start keyd
    fi
    # Cleanup
    sudo zypper clean
}

function configure_user() {
    echo "===Configuring User==="
    sleep 1
    # Remove bin folder
    rm -rf ~/bin
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
    echo 'alias system-update="sudo zypper refresh; sudo zypper dup; sudo flatpak update"' >> ~/.bashrc
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
    sudo virsh net-autostart default
    # Configure grub
    echo "Configuring grub..."
    sudo sed -i 's/GRUB_TIMEOUT=8/GRUB_TIMEOUT=0/g' /etc/default/grub
    sudo grub2-mkconfig -o /boot/grub2/grub.cfg
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
    	# gtest
        echo "Gtest..."
        cd ~
        git clone --depth 1 --branch "v1.15.2" https://github.com/google/googletest
        mkdir -p googletest/build
        cd googletest/build
        cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
        cmake --build .
        sudo cmake --install .
        rm -rf ~/googletest
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
        git clone --depth 1 --branch "2024.9.2" https://github.com/NickvisionApps/libnick/
        mkdir -p libnick/build
        cd libnick/build
        cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING="OFF" -DCMAKE_INSTALL_PREFIX=/usr
        cmake --build .
        sudo cmake --install .
        rm -rf ~/libnick
        cd ~
    fi
}

function install_printers() {
    echo "===Printers==="
    read -p "Install Canon printer drivers [y/N]: " CANON
    if [ "$CANON" == "y" ]; then
        sudo zypper -n install jbigkit
        cd ~
        wget https://gdlp01.c-wss.com/gds/6/0100009236/18/linux-UFRII-drv-v590-us-03.tar.gz
        tar -xvzf linux-UFRII-drv-v590-us-03.tar.gz
        sudo zypper install "/home/$USER/linux-UFRII-drv-v590-us/x64/RPM/cnrdrvcups-ufr2-us-5.90-1.03.x86_64.rpm"
        rm -rf linux-UFRII-drv-v590-us-03.tar.gz
        rm -rf linux-UFRII-drv-v590-us
    fi
    read -p "Install HP printer drivers [y/N]: " HP
    if [ "$HP" == "y" ]; then
        sudo zypper -n install hplip
    fi
}

function setup_zsh() {
    echo "===ZSH==="
    read -p "Setup ZSH [y/N]: " INSTALL
    if [ "$INSTALL" == "y" ]; then
        sudo zypper install zsh -y
        if command -v curl >/dev/null 2>&1; then
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
        else
            sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
        fi
        # Configure
        sed -i '/z4h install ohmyzsh\/ohmyzsh || return/a fastfetch' ~/.zshrc
        echo 'alias system-update="sudo zypper refresh; sudo zypper dup; sudo flatpak update"' >> ~/.zshrc
    fi
}

function display_links() {
    echo "===Data Drive Instructions==="
    echo "https://community.linuxmint.com/tutorial/view/1609"
}

cd ~
echo "===OpenSUSE Post Install Script==="
echo "by Nicholas Logozzo <nlogozzo>"
echo
echo "This script is meant to be used on OpenSUSE systems."
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
    install_printers
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
