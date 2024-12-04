#!/bin/bash

echo "===OSX KVM==="
read -p "Setup OSX KVM [y/N]: " INSTALL
if [ "$INSTALL" == "y" ]; then
	cd ~
	git clone --depth 1 --recursive https://github.com/kholia/OSX-KVM.git
	cd OSX-KVM
	sudo modprobe kvm; echo 1 | sudo tee /sys/module/kvm/parameters/ignore_msrs
	sudo cp kvm_amd.conf /etc/modprobe.d/kvm.conf
	./fetch-macOS-v2.py
	dmg2img -i BaseSystem.dmg BaseSystem.img
	qemu-img create -f qcow2 mac_hdd_ng.img 256G
	sed "s/CHANGEME/$USER/g" macOS-libvirt-Catalina.xml > macOS.xml
	virt-xml-validate macOS.xml
	virsh --connect qemu:///system define macOS.xml
	./OpenCore-Boot.sh
fi
