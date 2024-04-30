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
    sudo rpm --import https://rpm.packages.shiftkey.dev/gpg.key
    sudo sh -c 'echo -e "[shiftkey-packages]\nname=GitHub Desktop\nbaseurl=https://rpm.packages.shiftkey.dev/rpm/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://rpm.packages.shiftkey.dev/gpg.key" > /etc/zypp/repos.d/shiftkey-packages.repo'
    sudo zypper -n addrepo https://download.opensuse.org/repositories/home:Dead_Mozay/openSUSE_Tumbleweed/home:Dead_Mozay.repo
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
    sudo zypper install --type pattern devel_basis devel_C_C++ kvm_server kvm_tools
    sudo zypper install MozillaFirefox-branding-upstream libreoffice-branding-upstream epiphany-branding-upstream gdm-branding-upstream gio-branding-upstream gnome-menus-branding-upstream gtk2-branding-upstream gtk3-branding-upstream gtk4-branding-upstream
    sudo zypper install qemu libvirt opi QGnomePlatform-qt5 QGnomePlatform-qt6 firefox gnome-calendar gnome-sound-recorder gnome-tweaks gnome-extensions gnome-console loupe epiphany simple-scan gparted libreoffice xournalpp evince code git-lfs github-desktop gcc gcc-c++ clang-tools rust cmake meson ninja dotnet-sdk-8.0 dotnet-runtime-8.0 java-17-openjdk java-17-openjdk-devel blueprint-compiler gtk4-devel gtk4-tools libadwaita-devel glib2-devel webp-pixbuf-loader steam neofetch curl libcurl-devel unzip git nano cabextract fontconfig python311-devel python311-pip python311-python-lsp-server inkscape krita openssl openssl-devel ffmpeg aria2 yt-dlp geary yelp yelp-tools yelp-xsl cava intltool gettext-devel sqlitebrowser gnuplot chromaprint-fpcalc libchromaprint1 nodejs20 npm20 dblatex xmlgraphics-fop mm-common ruby tomcat flatpak flatpak-builder dconf-editor fetchmsttfonts libxml2 libxml2-devel libsecret-devel libuuid-devel libblas3 lapack liblapack3 fftw3 libidn2 libpodofo-devel adw-gtk3 adw-gtk3-dark xpadneo-kmp-default gnome-backgrounds gnome-network-displays docker
    sudo zypper -n remove gnome-terminal nautilus-extension-terminal gnome-music eog evolution vinagre xterm file-roller git-gui lightsoff gnome-mines iagno quadrapassel swell-foop gnome-sudoku
    sudo zypper -n remove -u patterns-gnome-gnome_games
    opi codecs
    # Flatpak
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
    sudo flatpak update
    sudo flatpak install -y flathub org.gnome.Sdk//46 org.gnome.Platform//46 org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark org.nickvision.tagger org.nickvision.tubeconverter org.nickvision.money org.nickvision.cavalier io.github.realmazharhussain.GdmSettings org.gnome.design.IconLibrary us.zoom.Zoom io.github.Foldex.AdwSteamGtk com.mattjakeman.ExtensionManager com.github.tchx84.Flatseal org.gnome.Fractal com.mojang.Minecraft dev.geopjr.Tuba io.gitlab.adhami3310.Impression it.mijorus.smile com.github.neithern.g4music hu.kramo.Cartridges org.gnome.seahorse.Application io.missioncenter.MissionCenter io.github.alainm23.planify com.ktechpit.whatsie com.github.PintaProject.Pinta com.discordapp.Discord re.sonny.Workbench app.drey.Biblioteca io.mrarm.mcpelauncher org.onlyoffice.desktopeditors org.mixxx.Mixxx
    # Megasync
    wget https://mega.nz/linux/repo/openSUSE_Tumbleweed/x86_64/megasync-openSUSE_Tumbleweed.x86_64.rpm
    sudo zypper install "megasync-openSUSE_Tumbleweed.x86_64.rpm"
    rm -rf megasync-openSUSE_Tumbleweed.x86_64.rpm
    # Android Messages
    wget https://github.com/OrangeDrangon/android-messages-desktop/releases/download/v5.4.2/Android.Messages-v5.4.2-linux-x86_64.rpm
    sudo zypper install "Android.Messages-v5.4.2-linux-x86_64.rpm"
    rm -rf Android.Messages-v5.4.2-linux-x86_64.rpm
    # JetBrains Toolbox
    cd /opt/
    sudo wget https://download-cdn.jetbrains.com/toolbox/jetbrains-toolbox-2.2.3.20090.tar.gz
    sudo tar -xvzf jetbrains-toolbox-2.2.3.20090.tar.gz
    sudo mv jetbrains-toolbox-2.2.3.20090 jetbrains-toolbox
    sudo rm -rf jetbrains-toolbox-2.2.3.20090.tar.gz
    ./jetbrains-toolbox/jetbrains-toolbox
    cd ~
}

function configure_user() {
    echo "===Configuring User==="
    sleep 1
    # Add user to groups
    echo "Configuring user groups..."
    sudo usermod -a -G tomcat $USER
    sudo usermod -a -G lp $USER
    sudo usermod -a -G docker $USER
    sudo usermod -a -G wheel $USER
    # Configure git
    echo "Configuring git..."
    git config --global protocol.file.allow always
    git config --global http.postBuffer 524288000
    git lfs install
    # Configure bash
    echo "Configuring bash..."
    echo "neofetch" >> ~/.bashrc
    # Configure GNOME
    echo "Configuring GNOME..."
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
    # Install terminal font
    echo "Installing JetBrains Mono Nerd font..."
    mkdir -p ~/.local/share/fonts
    cd ~/.local/share/fonts
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip
    unzip JetBrainsMono.zip
    rm -rf JetBrainsMono.zip
    fc-cache -f -v
    cd ~
    gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font 10'
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
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo virsh net-autostart default
    # Configure grub
    echo "Configuring grub..."
    sudo sed -i 's/GRUB_TIMEOUT=8/GRUB_TIMEOUT=0/g' /etc/default/grub
    sudo grub2-mkconfig -o /boot/grub2/grub.cfg
    # Configure firewall
    echo "Configuring firewall..."
    sudo firewall-cmd --zone=public --add-port=7236/tcp --permanent
    sudo firewall-cmd --zone=public --add-port=7236/udp --permanent
    sudo firewall-cmd --zone=public --add-service=ipp --permanent
    sudo firewall-cmd --zone=public --add-service=ipp-client --permanent
    sudo firewall-cmd --zone=public --add-service=dns --permanent
    sudo firewall-cmd --zone=public --add-service=mdns --permanent
    # Enable Remote Desktop Connection
    read -p "Enable Remote Desktop Connection (rdp and ssh) [y/N]: " REMOTE
    if [ "$REMOTE" == "y" ]; then
        sudo systemctl enable sshd
        sudo systemctl start sshd
        grdctl rdp enable
        grdctl rdp disable-view-only
        sudo firewall-cmd --zone=public --add-service=ssh --permanent
        sudo firewall-cmd --zone=public --add-service=rdp --permanent
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
            https://extensions.gnome.org/extension/5105/reboottouefi/
            https://extensions.gnome.org/extension/5410/grand-theft-focus/)
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
        git clone --depth 1 --branch "v1.14.0" https://github.com/google/googletest
        mkdir -p googletest/build
        cd googletest/build
        cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
        cmake --build .
        sudo cmake --install .
        rm -rf ~/googletest
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
        git clone --depth 1 --branch "v8.82" https://github.com/d99kris/rapidcsv
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
        git clone --depth 1 --branch "2024.3.1" https://github.com/NickvisionApps/libnick/
        mkdir -p libnick/build
        cd libnick/build
        cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING="OFF" -DCMAKE_INSTALL_PREFIX=/usr
        cmake --build .
        sudo cmake --install .
        rm -rf ~/libnick
        cd ~
    fi
}

function install_surface_kernel() {
    echo "===MS Surface Kernel==="
    read -p "Install Surface kernel [y/N]: " INSTALL
    if [ "$INSTALL" == "y" ]; then
        cd ~
        # Prepare
        echo "Preparing..."
        sudo zypper -n addrepo https://download.opensuse.org/repositories/home:TaivasJumala:Surface/openSUSE_Tumbleweed/home:TaivasJumala:Surface.repo
        sudo zypper refresh
        sudo zypper install yast2-bootloader gsl spdlog-devel libinih-devel eigen3-devel SDL2-devel libgle-devel python311-pytest libgudev-1_0-0 libgudev-1_0-devel libevdev-devel libevdev2 python311-libevdev
        # Install kernel
        echo "Installing kernel..."
        sudo zypper -n remove kernel-default
        sudo zypper install -r 'Linux Surface (openSUSE_Tumbleweed)' kernel-default
        # Install iptsd
        echo "Installing iptsd..."
        git clone --depth 1 --branch "v2" https://github.com/linux-surface/iptsd
        cd iptsd
        meson setup build
        ninja -C build
        sudo ninja -C build install
        sudo sed -i 's/# DisableOnPalm = false/DisableOnPalm = true/g' /etc/iptsd.conf
        sudo sed -i 's/# DisableOnStylus = false/DisableOnStylus = true/g' /etc/iptsd.conf
        rm -rf ~/iptsd
        cd ~
        # Install libwacom
        echo "Installing libwacom..."
        git clone --depth 1 --branch "libwacom-2.10.0" https://github.com/linuxwacom/libwacom
        cd libwacom
        wget https://raw.githubusercontent.com/linux-surface/libwacom-surface/master/patches/v2/0001-Add-support-for-BUS_VIRTUAL.patch
        wget https://raw.githubusercontent.com/linux-surface/libwacom-surface/master/patches/v2/0002-Add-support-for-Intel-Management-Engine-bus.patch
        wget https://raw.githubusercontent.com/linux-surface/libwacom-surface/master/patches/v2/0003-data-Add-Microsoft-Surface-Pro-3.patch
        wget https://raw.githubusercontent.com/linux-surface/libwacom-surface/master/patches/v2/0004-data-Add-Microsoft-Surface-Pro-4.patch
        wget https://raw.githubusercontent.com/linux-surface/libwacom-surface/master/patches/v2/0005-data-Add-Microsoft-Surface-Pro-5.patch
        wget https://raw.githubusercontent.com/linux-surface/libwacom-surface/master/patches/v2/0006-data-Add-Microsoft-Surface-Pro-6.patch
        wget https://raw.githubusercontent.com/linux-surface/libwacom-surface/master/patches/v2/0007-data-Add-Microsoft-Surface-Pro-7.patch
        wget https://raw.githubusercontent.com/linux-surface/libwacom-surface/master/patches/v2/0008-data-Add-Microsoft-Surface-Pro-7.patch
        wget https://raw.githubusercontent.com/linux-surface/libwacom-surface/master/patches/v2/0009-data-Add-Microsoft-Surface-Pro-8.patch
        wget https://raw.githubusercontent.com/linux-surface/libwacom-surface/master/patches/v2/0010-data-Add-Microsoft-Surface-Pro-9.patch
        wget https://raw.githubusercontent.com/linux-surface/libwacom-surface/master/patches/v2/0011-data-Add-Microsoft-Surface-Book.patch
        wget https://raw.githubusercontent.com/linux-surface/libwacom-surface/master/patches/v2/0012-data-Add-Microsoft-Surface-Book-2-13.5.patch
        wget https://raw.githubusercontent.com/linux-surface/libwacom-surface/master/patches/v2/0013-data-Add-Microsoft-Surface-Book-2-15.patch
        wget https://raw.githubusercontent.com/linux-surface/libwacom-surface/master/patches/v2/0014-data-Add-Microsoft-Surface-Book-3-13.5.patch
        wget https://raw.githubusercontent.com/linux-surface/libwacom-surface/master/patches/v2/0015-data-Add-Microsoft-Surface-Book-3-15.patch
        wget https://raw.githubusercontent.com/linux-surface/libwacom-surface/master/patches/v2/0016-data-Add-Microsoft-Surface-Laptop-Studio.patch
        for i in $(ls *.patch); do
            patch -Np1 -i "$i" || true
        done
        meson setup build
        meson compile -C build
        sudo meson install -C build
        rm -rf ~/libwacom
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

function setup_lazyvim() {
    echo "===LazyVim==="
    read -p "Setup LazyVim [y/N]: " INSTALL
    if [ "$INSTALL" == "y" ]; then
        sudo zypper -n install neovim fd lazygit ripgrep
        sudo npm install --global neovim
        # Backup
        mv ~/.config/nvim{,.bak}
        mv ~/.local/share/nvim{,.bak}
        mv ~/.local/state/nvim{,.bak}
        mv ~/.cache/nvim{,.bak}
        # LazyVim
        git clone https://github.com/LazyVim/starter ~/.config/nvim
        rm -rf ~/.config/nvim/.git
    fi
}

function setup_distrobox() {
    echo "===Distrobox==="
    read -p "Setup Distrobox [y/N]: " INSTALL
    if [ "$INSTALL" == "y" ]; then
        sudo zypper install distrobox
        echo "Please reboot the system before creating a new box."
        echo "UBUNTU: distrobox create --root --name ubuntu --image ubuntu:latest"
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
        # Configure
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
    install_apps
    configure_user
    configure_system
    install_gnome_extensions
    install_cpp_libraries
    install_surface_kernel
    install_printers
    setup_lazyvim
    setup_distrobox
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
