# Update
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y wget unzip git nano software-properties-common build-essential procps curl file

# Setup Terminal Look & Feel
sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
sudo apt update -y
sudo apt install -y fastfetch
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh
mkdir ~/.poshthemes
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
unzip ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.json
rm ~/.poshthemes/themes.zip

# Install Software
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
sudo add-apt-repository -y universe
sudo add-apt-repository -y ppa:flatpak/stable
sudo add-apt-repository -y ppa:michel-slm/distrobox
sudo apt update -y
sudo apt install -y distrobox xdg-user-dirs xdg-user-dirs-gtk flatpak libfuse2 flatpak-builder tzdata locales libgles2-mesa-dev libgl1-mesa-dev pkg-config gcc g++ cmake ruby ninja-build meson sassc

# Install adw-gtk3
cd ~
git clone --depth 1 --branch "v5.6" https://github.com/lassekongo83/adw-gtk3.git
cd adw-gtk3
meson build
cd build
sudo ninja install
cd ~
rm -rf adw-gtk3

# Restart WSL
cd /mnt/c/ && cmd.exe /c start "Rebooting WSL" cmd /c "timeout 5 && title "Ubuntu" && wsl -d Ubuntu" && wsl.exe --terminate Ubuntu

# Configure User
cd ~
xdg-user-dirs-update
xdg-user-dirs-gtk-update
sudo locale-gen en_US.UTF-8
sudo update-locale LANG=en_US.UTF-8
git config --global submodule.recurse true
git config --global protocol.file.allow always
git config --global http.postBuffer 524288000
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
ln -s /mnt/c/Users/nlogo ~/winhome

# Configure Flatpak
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
sudo flatpak install -y flathub org.gnome.Sdk//47 org.gnome.Platform//47 org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark org.nickvision.tagger org.nickvision.tubeconverter org.nickvision.money org.nickvision.cavalier re.sonny.Workbench org.gnome.design.IconLibrary com.github.tchx84.Flatseal

# Configure bash
echo "" >> ~/.bashrc
echo "export GSK_RENDERER=cairo" >> ~/.bashrc
echo "distrobox enter fedora" >> ~/.bashrc
echo "clear" >> ~/.bashrc
echo 'eval "$(oh-my-posh --init --shell bash --config ~/.poshthemes/jandedobbeleer.omp.json)"' >> ~/.bashrc
echo "fastfetch" >> ~/.bashrc

# Configure distrobox
distrobox create --name fedora --image fedora:latest
distrobox enter fedora

# Configure Fedora
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
sudo dnf upgrade -y
sudo dnf install -y @development-tools @multimedia fastfetch wget nano curl yt-dlp ffmpeg aria2 git code gcc g++ gdb cmake meson blueprint-compiler gettext yelp-tools glib-devel gtk4-devel gtk4-devel-tools libadwaita-devel openssl-devel libcurl-devel json-devel gtest-devel gmock-devel gettext-devel libsecret-devel boost-devel java-latest-openjdk-devel gettext-devel glib2-devel libuuid-devel libidn-devel libxml2-devel mm-devel libimobiledevice-devel mesa-libGL-devel mesa-libGLU-devel mesa-libGLw-devel mesa-libOSMesa-devel glfw-devel
sudo dnf install -y "qt6-*"
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh
sudo ln -s /run/host/run/systemd/system /run/systemd
sudo mkdir -p /run/dbus
sudo ln -s /run/host/run/dbus/system_bus_socket /run/dbus
exit

# Restart distrobox
distrobox stop fedora
distrobox enter fedora

# Install maddy
cd ~
git clone --depth 1 --branch "1.3.0" https://github.com/progsource/maddy
sudo mkdir -p /usr/include/maddy
sudo mv maddy/include/maddy/* /usr/include/maddy
rm -rf ~/maddy

# Install libxml++
cd ~
git clone --depth 1 --branch "5.4.0" https://github.com/libxmlplusplus/libxmlplusplus
cd libxmlplusplus
meson setup --prefix /usr --libdir lib64 --reconfigure -Dmaintainer-mode=false out-linux .
cd out-linux
ninja
sudo ninja install
cd ..
cd ..
rm -rf libxmlplusplus

# Install libnick
cd ~
git clone --depth 1 --branch "2025.1.0" https://github.com/NickvisionApps/libnick/
mkdir -p libnick/build
cd libnick/build
cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING="OFF" -DCMAKE_INSTALL_PREFIX=/usr
cmake --build .
sudo cmake --install .
cd ..
cd ..
rm -rf libnick

# Install skia
cd ~
git clone 'https://chromium.googlesource.com/chromium/tools/depot_tools.git'
export PATH="${PWD}/depot_tools:${PATH}"
git clone https://skia.googlesource.com/skia.git
cd skia
git reset --hard de898cc7cdaed4aed52c263066d73cf51e2610e4
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

# Install qlementine
cd ~
git clone --depth 1 --branch "v1.0.2" https://github.com/oclero/qlementine
mkdir -p qlementine/build
cd qlementine/build
cmake .. -DCMAKE_BUILD_TYPE=Release -DQLEMENTINE_SANDBOX="OFF" -DQLEMENTINE_SHOWCASE="OFF" -DCMAKE_INSTALL_PREFIX=/usr
cmake --build .
sudo cmake --install .
cd ..
cd ..
rm -rf qlementine

# Install qlementine-icons
cd ~
git clone --depth 1 --branch "install" https://github.com/nlogozzo/qlementine-icons
mkdir -p qlementine-icons/build
cd qlementine-icons/build
cmake .. -DCMAKE_BUILD_TYPE=Release -DQLEMENTINE_ICONS_SANDBOX="OFF" -DCMAKE_INSTALL_PREFIX=/usr
cmake --build .
sudo cmake --install .
cd ..
cd ..
rm -rf qlementine-icons

# Update linker
sudo ldconfig
