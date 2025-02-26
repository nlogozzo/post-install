#!/bin/bash

# Upgrade
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf upgrade --refresh -y

# Install Desktop
install-desktop.sh

# Install apps
sudo dnf install @development-tools @multimedia firefox gnome-extensions-app adw-gtk3-theme jq gcc gcc-c++ gdb cmake meson ninja-build blueprint-compiler libadwaita webp-pixbuf-loader fastfetch curl wget unzip openssl ffmpeg aria2 yt-dlp yt-dlp+default libunity yelp-tools cava intltool gnuplot chromaprint-tools nodejs npm fop mm-common flatpak-builder dconf-editor dnsmasq nbd doxygen gnome-firmware libheif-tools dmg2img python3-pip python3-requirements-parser libimobiledevice-utils ifuse cppcheck perl-Image-ExifTool clang-tools-extra -y --allowerasing
sudo dnf install java-latest-openjdk-devel libadwaita-devel gtk4-devel-tools gtk4-devel gettext-devel glib2-devel gtest-devel json-devel libcurl-devel openssl-devel libsecret-devel libuuid-devel libidn-devel libxml2-devel mm-devel boost-devel libimobiledevice-devel glfw-devel -y --allowerasing
sudo dnf remove -y gnome-system-monitor evince

# Flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
sudo flatpak update
sudo flatpak install -y flathub org.gnome.Sdk//47 org.gnome.Platform//47 org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark org.nickvision.tagger org.nickvision.tubeconverter org.nickvision.money org.nickvision.cavalier org.gnome.design.IconLibrary com.github.tchx84.Flatseal it.mijorus.smile app.drey.KeyRack app.drey.Biblioteca io.github.flattool.Ignition page.tesk.Refine net.nokyan.Resources org.gnome.Papers org.gnome.dspy

# Qt
sudo dnf install "qt6-*" qt-creator -y
git clone https://github.com/Raincode/QtCreator-Color-Schemes
cd QtCreator-Color-Schemes
bash install_linux.bash
cd ..
rm -rf QtCreator-Color-Schemes

# Bash
echo "fastfetch" >> ~/.bashrc
echo 'alias system-update="sudo dnf upgrade --refresh; sudo flatpak update"' >> ~/.bashrc

# GNOME Settings
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
gsettings set org.gnome.desktop.interface enable-animations false
gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.mutter workspaces-only-on-primary false
gsettings set org.gnome.desktop.peripherals.touchpad click-method 'areas'
gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing false
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true

# GNOME Extensions
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

# C++ Libraries
# maddy
echo "Maddy..."
git clone --depth 1 --branch "1.3.0" https://github.com/progsource/maddy
sudo mkdir -p /usr/include/maddy
sudo mv maddy/include/maddy/* /usr/include/maddy
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
git clone --depth 1 --branch "2025.2.0" https://github.com/NickvisionApps/libnick/
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
# qlementine
echo "qlementine..."
git clone --depth 1 --branch "v1.0.2" https://github.com/oclero/qlementine
mkdir -p qlementine/build
cd qlementine/build
cmake .. -DCMAKE_BUILD_TYPE=Release -DQLEMENTINE_SANDBOX="OFF" -DQLEMENTINE_SHOWCASE="OFF" -DCMAKE_INSTALL_PREFIX=/usr
cmake --build .
sudo cmake --install .
cd ..
cd ..
rm -rf qlementine
# qlementine-icons
echo "qlementine-icons..."
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