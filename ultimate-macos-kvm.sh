#!/bin/bash

echo "===ultimate-macOS-KVM==="
echo "Please ensure you have kvm and all required dependencies installed before continuing.\n"
read -p "Setup OSX KVM [y/N]: " INSTALL
if [ "$INSTALL" == "y" ]; then
	cd ~
	git clone --branch "v0.13.0" --depth 1 https://github.com/Coopydood/ultimate-macOS-KVM
	cd ultimate-macOS-KVM
	./main.py
fi
