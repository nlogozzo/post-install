#!/bin/bash

function enable_repos() {
    echo "===Enabling Repositories==="
    sleep 1
    sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
    sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
    sudo wget https://fedorapeople.org/groups/virt/virtio-win/virtio-win.repo -O /etc/yum.repos.d/virtio-win.repo
    sudo dnf group upgrade core -y
}

function upgrade() {
    echo "===Upgrading System==="
    sleep 1
    sudo dnf upgrade --refresh -y
}

function install_apps() {
    echo "===Installing Applications==="
    sleep 1
    # Repos
    echo "Installing from repositories..."
    sudo dnf install @development-tools @multimedia @virtualization gnome-extensions-app simple-scan gparted adw-gtk3-theme libreoffice steam mixxx xournalpp gcc gcc-c++ gdb cmake meson ninja-build blueprint-compiler libadwaita webp-pixbuf-loader fastfetch curl wget unzip cabextract xorg-x11-font-utils fontconfig openssl ffmpeg aria2 yt-dlp yt-dlp+default libunity yelp-tools cava intltool sqlitebrowser gnuplot chromaprint-tools nodejs npm fop mm-common hunspell-it langpacks-it flatpak-builder dconf-editor libvirt qemu dnsmasq nbd doxygen gnome-firmware libheif-tools virtio-win dmg2img python3-pip python3-requirements-parser libimobiledevice-utils ifuse cppcheck vlc dialog freerdp iproute libnotify nmap-ncat gimp krita inkscape perl-Image-ExifTool clang-tools-extra -y --allowerasing
    sudo dnf install java-latest-openjdk-devel libadwaita-devel gtk4-devel-tools gtk4-devel gettext-devel glib2-devel gtest-devel json-devel libcurl-devel openssl-devel libsecret-devel libuuid-devel libidn-devel libxml2-devel mm-devel boost-devel libimobiledevice-devel mesa-libGL-devel mesa-libGLU-devel mesa-libGLw-devel mesa-libOSMesa-devel glfw-devel libunistring-devel cpr-devel -y --allowerasing
    sudo rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
    sudo dnf remove -y gnome-system-monitor evince
    # Flatpak
    echo "Installing from Flatpak..."
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
    flatpak update
    flatpak install -y flathub org.gnome.Sdk//48 org.gnome.Platform//48 org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark org.nickvision.tagger org.nickvision.tubeconverter org.nickvision.money org.nickvision.cavalier io.github.realmazharhussain.GdmSettings org.gnome.design.IconLibrary com.github.tchx84.Flatseal it.mijorus.smile app.drey.KeyRack re.sonny.Workbench app.drey.Biblioteca io.gitlab.adhami3310.Impression org.gnome.Fractal com.mojang.Minecraft io.mrarm.mcpelauncher org.onlyoffice.desktopeditors io.github.shiftey.Desktop com.discordapp.Discord org.gnome.NetworkDisplays com.github.neithern.g4music com.spotify.Client us.zoom.Zoom io.github.flattool.Ignition page.tesk.Refine net.nokyan.Resources page.kramo.Cartridges org.gnome.Papers dev.qwery.AddWater org.gnome.dspy
    # MEGA
    wget https://mega.nz/linux/repo/Fedora_42/x86_64/megasync-Fedora_42.x86_64.rpm -O megasync.rpm
    sudo dnf install megasync.rpm -y
    rm megasync.rpm
}

function configure_user() {
    echo "===Configuring User==="
    sleep 1
    # Add user to groups
    echo "Configuring user groups..."
    sudo usermod -a -G lp $USER
    sudo usermod -a -G libvirt $USER
    sudo usermod -a -G kvm $USER
    sudo usermod -a -G input $USER
    # Configure git
    echo "Configuring git..."
    git config --global protocol.file.allow always
    # Configure bash
    echo "Configuring bash..."
    echo "fastfetch" >> ~/.bashrc
    echo 'alias system-update="sudo dnf upgrade --refresh; flatpak update"' >> ~/.bashrc
    # Install nerd font
    curl -o ~/JetbrainsNerd.zip -L "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip"
    unzip ~/JetbrainsNerd.zip -d ~/.local/share/fonts/
    fc-cache -vf ~/.local/share/fonts/
    rm ~/JetbrainsNerd.zip
    gsettings set org.gnome.desktop.interface monospace-font-name "JetBrainsMono Nerd Font 10"
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
    flatpak run dev.qwery.AddWater
}

function configure_system() {
    echo "===Configuring System==="
    sleep 1
    # UTC Time
    echo "Configuring UTC time..."
    sudo timedatectl set-local-rtc '0'
    # Configure hostname
    echo "Configuring hostname..."
    echo "Current hostname: $(hostname)"
    read -p "New hostname: " NEWHOST
    sudo hostnamectl set-hostname $NEWHOST
    # Configure services
    echo "Configuring services..."
    sudo systemctl enable libvirtd
    sudo systemctl start libvirtd
    sudo systemctl disable NetworkManager-wait-online.service
    # Enable SSH Connection
    read -p "Enable SSH Connection [y/N]: " SSH
    if [ "$SSH" == "y" ]; then
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
        git clone --depth 1 --branch "1.6.0" https://github.com/progsource/maddy
        mkdir -p maddy/build
        cd maddy/build
        cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
        cmake --build .
        sudo cmake --install .
        cd ..
        cd ..
        rm -rf maddy
        # libxml++
        echo "Libxml++..."
        git clone --depth 1 --branch "5.4.0" https://github.com/libxmlplusplus/libxmlplusplus
        cd libxmlplusplus
        meson setup --prefix /usr --libdir lib64 --reconfigure -Dmaintainer-mode=false out-linux .
        cd out-linux
        ninja
        sudo ninja install
        cd ..
        cd ..
        rm -rf libxmlplusplus
        # libnick
        echo "Libnick..."
        git clone --depth 1 --branch "2025.7.6" https://github.com/NickvisionApps/libnick/
        mkdir -p libnick/build
        cd libnick/build
        cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING="OFF" -DCMAKE_INSTALL_PREFIX=/usr
        cmake --build .
        sudo cmake --install .
        cd ..
        cd ..
        rm -rf libnick
        # skia
        echo "Skia..."
        git clone 'https://chromium.googlesource.com/chromium/tools/depot_tools.git'
        export PATH="${PWD}/depot_tools:${PATH}"
        git clone --branch "chrome/m140" https://skia.googlesource.com/skia.git
        cd skia
        python3 tools/git-sync-deps
        bin/gn gen out/Release --args="is_debug=false is_official_build=true is_component_build=true skia_use_system_expat=false skia_use_system_icu=false skia_use_system_libjpeg_turbo=false skia_use_system_libpng=false skia_use_system_libwebp=false skia_use_system_zlib=false skia_use_freetype=true skia_use_harfbuzz=true skia_pdf_subset_harfbuzz=true skia_use_system_freetype2=false skia_use_system_harfbuzz=false"
	ninja -C out/Release
        sudo cp out/Release/*.a /usr/lib
        sudo cp out/Release/*.so /usr/lib
        sudo mkdir -p /usr/include/skia/include
        sudo cp -r include/* /usr/include/skia/include
        sudo mkdir -p /usr/include/skia/modules/
        sudo cp -r modules/* /usr/include/skia/modules
        cd ..
        rm -rf depot_tools
        rm -rf skia
        # Update linker
        sudo ldconfig
    fi
}

function display_links() {
    echo "===Data Drive Instructions==="
    echo "https://community.linuxmint.com/tutorial/view/1609"
    echo "===Windows 11 KVM Instructions==="
    echo "https://sysguides.com/install-a-windows-11-virtual-machine-on-kvm"
}

echo "===Fedora Post Install Script==="
echo "by Nicholas Logozzo <nlogozzo>"
echo
echo "This script is meant to be used on Fedora 41 systems."
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
