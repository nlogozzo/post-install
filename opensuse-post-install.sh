
#!/bin/bash

function enable_repos() {
    echo "===Enabling Repositories==="
    sleep 1
    sudo zypper -n install libicu
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/zypp/repos.d/vscode.repo'
    wget https://packages.microsoft.com/config/opensuse/15/prod.repo
    sudo mv prod.repo /etc/zypp/repos.d/microsoft-prod.repo
    sudo chown root:root /etc/zypp/repos.d/microsoft-prod.repo
    sudo rpm --import https://rpm.packages.shiftkey.dev/gpg.key
    sudo sh -c 'echo -e "[shiftkey-packages]\nname=GitHub Desktop\nbaseurl=https://rpm.packages.shiftkey.dev/rpm/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://rpm.packages.shiftkey.dev/gpg.key" > /etc/zypp/repos.d/shiftkey-packages.repo'
    sudo zypper -n addrepo https://download.opensuse.org/repositories/home:Dead_Mozay/openSUSE_Tumbleweed/home:Dead_Mozay.repo
    sudo zypper -n addrepo https://download.opensuse.org/repositories/home:MaxxedSUSE/openSUSE_Tumbleweed/home:MaxxedSUSE.repo
    sudo zypper -n addrepo https://download.opensuse.org/repositories/home:illuusio/openSUSE_Tumbleweed/home:illuusio.repo
}

function upgrade() {
    echo "===Upgrading System==="
    sleep 1
    sudo zypper refresh
    sudo zypper -n dup
}

function install_apps_from_repos() {
    echo "===Installing Apps From Repositories==="
    sleep 1
    sudo zypper install --type pattern devel_basis devel_C_C++ kvm_server kvm_tools
    sudo zypper install qemu libvirt opi MozillaFirefox-branding-upstream firefox gnome-tweaks gnome-extensions gnome-console loupe snapshot epiphany simple-scan gparted libreoffice onlyoffice-desktopeditors xournalpp evince code github-desktop gcc gcc-c++ cmake meson ninja dotnet-sdk-8.0 dotnet-runtime-8.0 java-17-openjdk java-17-openjdk-devel blueprint-compiler gtk4-devel gtk4-tools libadwaita-devel glib2-devel gtest webp-pixbuf-loader steam neofetch curl libcurl-devel wget git nano cabextract fontconfig python311-pip inkscape krita openssl openssl-devel ffmpeg aria2 yt-dlp geary yelp yelp-tools yelp-xsl cava intltool gettext-devel sqlitebrowser gnuplot chromaprint-fpcalc libchromaprint1 nodejs20 npm20 dblatex xmlgraphics-fop mm-common ruby hplip tomcat flatpak-builder dconf-editor fetchmsttfonts libxml2-devel libsecret-devel libuuid-devel libboost*devel libblas3 lapack liblapack3 fftw3 libidn2 libxml2 podofo libpodofo2 texlive-latex texstudio adw-gtk3 adw-gtk3-dark
    sudo zypper -n remove gnome-terminal eog cheese evolution
    pip install yt-dlp psutil requirements-parser
    # Megasync
    wget https://mega.nz/linux/repo/openSUSE_Tumbleweed/x86_64/megasync-openSUSE_Tumbleweed.x86_64.rpm 
    sudo zypper install "megasync-openSUSE_Tumbleweed.x86_64.rpm"
    rm -rf megasync-openSUSE_Tumbleweed.x86_64.rpm
    # Android Messages
    wget https://github.com/OrangeDrangon/android-messages-desktop/releases/download/v5.4.2/Android.Messages-v5.4.2-linux-x86_64.rpm
    sudo zypper install "Android.Messages-v5.4.2-linux-x86_64.rpm"
    rm -rf Android.Messages-v5.4.2-linux-x86_64.rpm
    # JetBrains Toolbox
    read -p "Install JetBrains Toolbox [y/N]: " JETBRAINS
    if [ "$JETBRAINS" == "y" ]; then
        cd /opt/
        sudo wget https://download-cdn.jetbrains.com/toolbox/jetbrains-toolbox-2.2.3.20090.tar.gz
        sudo tar -xvzf jetbrains-toolbox-2.2.3.20090.tar.gz
        sudo mv jetbrains-toolbox-2.2.3.20090 jetbrains-toolbox
        sudo rm -rf jetbrains-toolbox-2.2.3.20090.tar.gz
        ./jetbrains-toolbox/jetbrains-toolbox
    fi
    cd ~
}

function install_apps_from_flatpak() {
    echo "===Installing Apps From Flatpak==="
    sleep 1
    sudo zypper -n install flatpak
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
    sudo flatpak install -y flathub org.gnome.Sdk//46 org.gnome.Platform//46 org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark org.nickvision.tagger org.nickvision.tubeconverter org.nickvision.money org.nickvision.cavalier io.github.realmazharhussain.GdmSettings org.gnome.design.IconLibrary us.zoom.Zoom io.github.Foldex.AdwSteamGtk com.mattjakeman.ExtensionManager com.github.tchx84.Flatseal org.gnome.Fractal com.mojang.Minecraft dev.geopjr.Tuba io.gitlab.adhami3310.Impression it.mijorus.smile hu.kramo.Cartridges org.gnome.seahorse.Application io.missioncenter.MissionCenter io.github.alainm23.planify com.ktechpit.whatsie com.github.PintaProject.Pinta com.discordapp.Discord re.sonny.Workbench app.drey.Biblioteca io.mrarm.mcpelauncher org.onlyoffice.desktopeditors org.mixxx.Mixxx
}

function configure_user() {
    echo "===Configuring User==="
    sleep 1
    # Add user to groups
    echo "Configuring user groups..."
    sudo usermod -a -G tomcat $USER
    sudo usermod -a -G lp $USER
    # Configure git
    echo "Configuring git..."
    git config --global protocol.file.allow always
    # Configure bash
    echo "Configuring bash..."
    echo "neofetch" >> ~/.bashrc
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
    gsettings set org.gtk.settings.file-chooser sort-directories-first true
    gsettings set org.gtk.Settings.file-chooser show-hidden true
    # Firefox theme
    firefox
    echo "Installing Firefox theme..."
    curl -s -o- https://raw.githubusercontent.com/rafaelmardojai/firefox-gnome-theme/master/scripts/install-by-curl.sh | bash
}

function configure_system() {
    echo "===Configuring System==="
    sleep 1
    # Enable and start services
    echo "Enabling and starting services..."
    sudo systemctl enable libvirtd
    sudo systemctl start libvirtd
    # Configure grub
    echo "Configuring grub..."
    sudo sed -i 's/GRUB_TIMEOUT=8/GRUB_TIMEOUT=0/g' /etc/default/grub
    sudo grub2-mkconfig -o /boot/grub2/grub.cfg
}

function install_gnome_extensions() {
    echo "===GNOME Extensions==="
    read -p "Install GNOME extensions [y/N]: " INSTALL
    if [ "$INSTALL" == "y" ]; then
        array=( https://extensions.gnome.org/extension/4269/alphabetical-app-grid/
        https://extensions.gnome.org/extension/615/appindicator-support/
        https://extensions.gnome.org/extension/4362/fullscreen-avoider/
        https://extensions.gnome.org/extension/5506/user-avatar-in-quick-settings/
        https://extensions.gnome.org/extension/1108/add-username-to-top-panel/
        https://extensions.gnome.org/extension/5500/auto-activities/
        https://extensions.gnome.org/extension/6096/smile-complementary-extension/
        https://extensions.gnome.org/extension/5105/reboottouefi/
        https://extensions.gnome.org/extension/5410/grand-theft-focus/ )
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
        # jsoncpp
        echo "Jsoncpp..."
        cd ~
        git clone --depth 1 --branch "1.9.5" https://github.com/open-source-parsers/jsoncpp
        mkdir -p jsoncpp/build
        cd jsoncpp/build
        cmake .. -DCMAKE_BUILD_TYPE=Release -DJSONCPP_WITH_TESTS="OFF" -DJSONCPP_WITH_CMAKE_PACKAGE="ON" -DCMAKE_INSTALL_PREFIX=/usr
        cmake --build .
        sudo cmake --install .
        rm -rf ~/jsoncpp
        # maddy
        echo "Maddy..."
        cd ~
        git clone --depth 1 --branch "1.3.0" https://github.com/progsource/maddy
        sudo mkdir -p /usr/include/maddy
        sudo mv maddy/include/maddy/* /usr/include/maddy
        rm -rf ~/maddy
        # matplotplusplus
        echo "Matplot++..."
        cd ~
        git clone --depth 1 --branch "v1.2.0" https://github.com/alandefreitas/matplotplusplus
        mkdir -p matplotplusplus/build
        cd matplotplusplus/build
        cmake .. -DCMAKE_BUILD_TYPE=Release -DMATPLOTPP_BUILD_EXAMPLES="OFF" -DMATPLOTPP_BUILD_TESTS="OFF" -DCMAKE_INTERPROCEDURAL_OPTIMIZATION="ON" -DCMAKE_INSTALL_PREFIX=/usr
        cmake --build .
        sudo cmake --install .
        rm -rf ~/matplotplusplus
        # rapidcsv
        echo "Rapidcsv..."
        cd ~
        git clone --depth 1 --branch "v8.80" https://github.com/d99kris/rapidcsv
        mkdir -p rapidcsv/build
        cd rapidcsv/build
        cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
        sudo cmake --install .
        rm -rf ~/rapidcsv
        # libxml++
        echo "Libxml++..."
        cd ~
        git clone --depth 1 --branch "5.2.0" https://github.com/libxmlplusplus/libxmlplusplus
        cd libxmlplusplus
        meson setup --prefix /usr --libdir lib64 --reconfigure -Dmaintainer-mode=false out-linux .
        cd out-linux
        ninja
        sudo ninja install
        rm -rf ~/libxmlplusplus
        # libnick
        echo "Libnick..."
        cd ~
        git clone --depth 1 --branch "2024.3.0" https://github.com/NickvisionApps/libnick/
        mkdir -p libnick/build
        cd libnick/build
        cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING="OFF" -DCMAKE_INSTALL_PREFIX=/usr
        cmake --build .
        sudo cmake --install .
        rm -rf ~/libnick
    fi
}

function install_surface_kernel() {
    echo "===MS Surface Kernel==="
    read -p "Install Surface kernel [y/N]: " INSTALL
    if [ "$INSTALL" == "y" ]; then
        cd ~
        sudo zypper -n addrepo https://download.opensuse.org/repositories/home:TaivasJumala:Surface/openSUSE_Tumbleweed/home:TaivasJumala:Surface.repo
        sudo zypper refresh
        sudo zypper install yast2-bootloader gsl spdlog-devel libinih-devel eigen3-devel SDL2-devel libgle-devel
        sudo zypper -n remove kernel-default
        sudo zypper install -r 'Linux Surface (openSUSE_Tumbleweed)' kernel-default
        git clone https://github.com/linux-surface/iptsd
        cd iptsd
        meson setup build
        ninja -C build
        sudo ninja -C build install
        cd ~
        rm -rf iptsd
    fi
}

function setup_zsh() {
    echo "===ZSH==="
    read -p "Setup ZSH [y/N]: " INSTALL
    if [ "$INSTALL" == "y" ]; then
        sudo -n zypper install zsh
        if command -v curl >/dev/null 2>&1; then
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
        else
            sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
        fi
        # Neofetch
        sed -i '/z4h install ohmyzsh\/ohmyzsh || return/a neofetch' ~/.zshrc
    fi
}

function display_links() {
    echo "===Data Drive Instructions==="
    echo "https://community.linuxmint.com/tutorial/view/1609"
}

cd ~
echo "===OpenSuse Post Install Script==="
echo "by Nicholas Logozzo <nlogozzo>"
echo 
echo "This script is meant to be used on OpenSuse Tumbleweed systems."
echo 
echo "Please stay attentive during the installation process,"
echo "as you may need to enter your password and answer"
echo "prompts multiple times."
echo 
read -p "Continue [y/N]: " CONTINUE
if [ "$CONTINUE" == "y" ]; then
    enable_repos
    upgrade
    install_apps_from_repos
    install_apps_from_flatpak
    configure_user
    configure_system
    install_gnome_extensions
    install_cpp_libraries
    install_surface_kernel
    setup_zsh
    display_links
    echo "===Reboot==="
    read -p "Reboot [y/N]: " REBOOT
    if [ "$REBOOT" == "y" ]; then
        sudo reboot
    else
        echo "Please reboot to apply all changes."
    fi
    echo "===DONE==="
fi
