#!/bin/bash

cd ~

# Update
sudo zypper update
sudo zypper install -t pattern wsl_systemd
sudo zypper install -t pattern wsl_gui
wsl.exe --terminate openSUSE-Tumbleweed

# Install
sudo zypper install git nano gcc gcc-c++ gdb cmake meson ninja blueprint-compiler libadwaita webp-pixbuf-loader fastfetch curl wget unzip openssl ffmpeg aria2 yt-dlp yelp-tools cava intltool gnuplot chromaprint flatpak xdg-user-dirs mm-common doxygen fop lipzip
sudo zypper install libadwaita-devel gettext-devel glib2-devel gtest libcurl-devel openssl-devel libsecret-devel libuuid-devel libidn-devel libxml2-devel boost* libboost* libimobiledevice-devel libglfw3 libzip-devel
sudo zypper install qt6*
xdg-user-dirs-update
wsl.exe --terminate openSUSE-Tumbleweed

# Flatpak
flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak --user remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
flatpak --user update
flatpak --user install -y flathub org.gnome.Sdk//48 org.gnome.Platform//48 org.nickvision.tagger org.nickvision.tubeconverter org.nickvision.money org.nickvision.cavalier org.gnome.design.IconLibrary com.github.tchx84.Flatseal app.drey.KeyRack org.gnome.dspy

# User
echo "fastfetch" >> ~/.bashrc
echo "export GDK_BACKEND=x11" >> ~/.bashrc
echo "export QT_QPA_PLATFORM=xcb" >> ~/.bashrc
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
ln -s /mnt/c/Users/nlogo ~/winhome

# maddy
git clone --depth 1 --branch "1.3.0" https://github.com/progsource/maddy
sudo mkdir -p /usr/include/maddy
sudo mv maddy/include/maddy/* /usr/include/maddy
rm -rf maddy

# libxml++
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
git clone --depth 1 --branch "2025.3.5" https://github.com/NickvisionApps/libnick/
mkdir -p libnick/build
cd libnick/build
cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING="OFF" -DCMAKE_INSTALL_PREFIX=/usr
cmake --build .
sudo cmake --install .
cd ..
cd ..
rm -rf libnick

# qlementine
git clone --depth 1 --branch "v1.1.2" https://github.com/oclero/qlementine
mkdir -p qlementine/build
cd qlementine/build
cmake .. -DCMAKE_BUILD_TYPE=Release -DQLEMENTINE_SANDBOX="OFF" -DQLEMENTINE_SHOWCASE="OFF" -DCMAKE_INSTALL_PREFIX=/usr
cmake --build .
sudo cmake --install .
cd ..
cd ..
rm -rf qlementine

# qlementine-icons
git clone --depth 1 --branch "v1.7.1" https://github.com/oclero/qlementine-icons
mkdir -p qlementine-icons/build
cd qlementine-icons/build
cmake .. -DCMAKE_BUILD_TYPE=Release -DQLEMENTINE_ICONS_SANDBOX="OFF" -DCMAKE_INSTALL_PREFIX=/usr
cmake --build .
sudo cmake --install .
c
rm -rf qlementine-icons

# skia
git clone 'https://chromium.googlesource.com/chromium/tools/depot_tools.git'
export PATH="${PWD}/depot_tools:${PATH}"
git clone --branch "chrome/m135" https://skia.googlesource.com/skia.git
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

# Reboot
wsl.exe --terminate openSUSE-Tumbleweed