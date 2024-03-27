
#!/bin/bash

function enable_repos() {
    echo "===Enabling Repositories==="
    sleep 1
    sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
    sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    sudo rpm --import https://rpm.packages.shiftkey.dev/gpg.key
    sudo sh -c 'echo -e "[shiftkey-packages]\nname=GitHub Desktop\nbaseurl=https://rpm.packages.shiftkey.dev/rpm/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://rpm.packages.shiftkey.dev/gpg.key" > /etc/yum.repos.d/shiftkey-packages.repo'
}

function upgrade() {
    echo "===Upgrading System==="
    sleep 1
    sudo dnf upgrade -y
}

function install_apps_from_repos() {
    echo "===Installing Apps From Repositories==="
    sleep 1
    sudo dnf groupinstall "Development Tools" -y
    sudo dnf group install --with-optional virtualization -y
    sudo dnf install https://download.onlyoffice.com/repo/centos/main/noarch/onlyoffice-repo.noarch.rpm -y
    sudo dnf install gnome-tweaks gnome-extensions-app gnome-console simple-scan gparted adw-gtk3-theme libreoffice onlyoffice-desktopeditors xournalpp evince code github-desktop gcc gcc-c++ cmake meson ninja-build dotnet-sdk-8.0 dotnet-runtime-8.0 java-17-openjdk-devel blueprint-compiler libadwaita webp-pixbuf-loader mixxx steam neofetch curl wget cabextract xorg-x11-font-utils fontconfig python3 python3-pip inkscape krita openssl joystick-support ffmpeg aria2 yt-dlp geary libunity yelp-tools cava intltool sqlitebrowser gnuplot chromaprint-tools nodejs npm dblatex fop mm-common ruby hplip tomcat hunspell-it langpacks-it texlive-scheme-full texstudio flatpak-builder dnf-plugins-core python3-dnf-plugin-post-transaction-actions -y --allowerasing
    sudo dnf install https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm -y
    sudo dnf install java-latest-openjdk-devel libadwaita-devel gtk4-devel-tools gtk4-devel gettext-devel glib2-devel gtest-devel jsoncpp-devel libcurl-devel openssl-devel libsecret-devel libuuid-devel boost-devel blas-devel lapack-devel fftw-devel libidn-devel libxml2-devel mm-devel -y --allowerasing
    pip install yt-dlp psutil requirements-parser
    cd ~
    wget https://mega.nz/linux/repo/Fedora_39/x86_64/megasync-Fedora_39.x86_64.rpm && sudo dnf install "megasync-Fedora_39.x86_64.rpm"
    rm -rf megasync-Fedora_39.x86_64.rpm
    sudo dnf remove gnome-terminal -y
}

function install_apps_from_flatpak() {
    echo "===Installing Apps From Flatpak==="
    sleep 1
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
    flatpak install flathub org.gnome.Sdk//45 org.gnome.Platform//45 org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark org.nickvision.tagger org.nickvision.tubeconverter org.nickvision.money org.nickvision.cavalier io.github.realmazharhussain.GdmSettings org.gnome.design.IconLibrary us.zoom.Zoom io.github.Foldex.AdwSteamGtk com.mattjakeman.ExtensionManager com.github.tchx84.Flatseal org.gnome.Fractal com.mojang.Minecraft dev.geopjr.Tuba io.gitlab.adhami3310.Impression it.mijorus.smile hu.kramo.Cartridges org.gnome.seahorse.Application io.missioncenter.MissionCenter io.github.alainm23.planify com.ktechpit.whatsie com.github.PintaProject.Pinta com.discordapp.Discord re.sonny.Workbench app.drey.Biblioteca
}

function configure_user() {
    echo "===Configuring User==="
    sleep 1
    # Add user to groups
    echo "Setting groups..."
    sudo usermod -a -G tomcat $USER
    sudo usermod -a -G lp $USER
    # Configure git
    echo "Configuring git..."
    git config --global protocol.file.allow always
    # Firefox theme
    echo "Installing Firefox theme..."
    curl -s -o- https://raw.githubusercontent.com/rafaelmardojai/firefox-gnome-theme/master/scripts/install-by-curl.sh | bash
}

function configure_system() {
    echo "===Configuring System==="
    sleep 1
    # Enable and start services
    echo "Enabling and starting services..."
    sudo systemctl start libvirtd
    sudo systemctl enable libvirtd
    # Remove firefox fedora defaults
    echo "Removing Firefox Fedora defaults..."
    sudo rm -f /usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js
    sudo mkdir -p /etc/dnf/plugins/post-transaction-actions.d/
    sudo touch /etc/dnf/plugins/post-transaction-actions.d/firefox-fedora-defaults-remove.action
    echo "firefox:any:sudo rm -f /usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js" | sudo tee -a /etc/dnf/plugins/post-transaction-actions.d/firefox-fedora-defaults-remove.action
}

function cpp_libraries() {
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
        # podofo
        echo "Podofo..."
        cd ~
        git clone --depth 1 --branch "0.10.3" https://github.com/podofo/podofo
        mkdir -p podofo/build
        cd podofo/build
        cmake .. -DCMAKE_BUILD_TYPE=Release -DPODOFO_BUILD_TEST="OFF" -DPODOFO_BUILD_EXAMPLES="OFF" -DCMAKE_INSTALL_PREFIX=/usr
        cmake --build .
        sudo cmake --install .
        rm -rf ~/podofo
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
        sudo dnf config-manager --add-repo=https://pkg.surfacelinux.com/fedora/linux-surface.repo
        sudo dnf install kernel-surface iptsd libwacom-surface kernel-surface-devel kernel-surface-default-watchdog -y --allowerasing
        read -p "Install secure boot keys [y/N]: " KEYS
        if [ "$KEYS" == "y" ]; then
            sudo dnf install surface-secureboot -y
        fi
        sudo systemctl enable --now linux-surface-default-watchdog.path
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
    fi
}

function display_links() {
    echo "===GNOME Extensions==="
    echo "https://extensions.gnome.org/extension/4269/alphabetical-app-grid/"
    echo "https://extensions.gnome.org/extension/5237/rounded-window-corners/"
    echo "https://extensions.gnome.org/extension/615/appindicator-support/"
    echo "https://extensions.gnome.org/extension/4362/fullscreen-avoider/"
    echo "https://extensions.gnome.org/extension/5506/user-avatar-in-quick-settings/"
    echo "https://extensions.gnome.org/extension/1108/add-username-to-top-panel/"
    echo "https://extensions.gnome.org/extension/5500/auto-activities/"
    echo "https://extensions.gnome.org/extension/3193/blur-my-shell/"
    echo "https://extensions.gnome.org/extension/6096/smile-complementary-extension/"
    echo "https://extensions.gnome.org/extension/5105/reboottouefi/"
    echo "https://extensions.gnome.org/extension/5410/grand-theft-focus/"
    echo "===Data Drive Instructions==="
    echo "https://community.linuxmint.com/tutorial/view/1609"
}

cd ~
echo "===Fedora Post Install Script==="
echo "by Nicholas Logozzo <nlogozzo>"
echo 
echo "This script is meant to be used on Fedora Workstation systems."
echo 
echo "Please stay attentive during the installation process,"
echo "as you may need to enter your password multiple times."
echo 
read -p "Continue [y/N]: " CONTINUE
if [ "$CONTINUE" == "y" ]; then
    enable_repos
    upgrade
    install_apps_from_repos
    install_apps_from_flatpak
    configure_user
    configure_system
    cpp_libraries
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
