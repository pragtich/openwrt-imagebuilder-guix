#!/bin/bash

REL="25.12.2"
ARCH="x86"
VARIANT="64"
IMGBLDR_FN="openwrt-imagebuilder-${REL}-${ARCH}-${VARIANT}.Linux-${ARCH}_${VARIANT}.tar.zst"
IMGBLDR_URL="https://downloads.openwrt.org/releases/${REL}/targets/${ARCH}/${VARIANT}/${IMGBLDR_FN}"

PROFILE="generic"		# make info: the only option for x86/64
FILES="files"		
# ROOTFS_PARTSIZE runs into limitations due to Docker limits. Probably avoidable, but let's try resizing first
#ROOTFS_PARTSIZE=143 	# Partition size in MB; 14.7G presently 14*1024=14336MB

declare -a PACKAGES		# space separated list; -package to exclude; auto dependencies
# System requirements for APU2 system
# https://teklager.se/en/knowledge-base/openwrt-installation-instructions/
PACKAGES+=(kmod-pcengines-apuv2 beep kmod-leds-gpio kmod-crypto-hw-ccp kmod-usb-core kmod-usb-ohci kmod-usb2 kmod-usb3 kmod-sound-core kmod-pcspkr amd64-microcode flashrom irqbalance fstrim usbutils curl )
# Also add drivers for the WiFi Cards:
# https://teklager.se/en/knowledge-base/openwrt-installation-instructions/
PACKAGES+=(hostapd-openssl kmod-ath9k ath9k-htc-firmware ath10k-firmware-qca988x kmod-ath10k)
# Luci
PACKAGES+=(luci luci-ssl)
# And add VPN software
#PACKAGES+=(luci-proto-wireguard luci-app-wireguard openvpn-openssl ip-full luci-app-openvpn)
#PACKAGES+=(openvpn-openssl ip-full luci-app-openvpn)
PACKAGES+=(tailscale )
# Add Avahi
PACKAGES+=(avahi-dbus-daemon avahi-utils libavahi-client libavahi-dbus-support)
# Add DDNS
PACKAGES+=(luci-app-ddns)
# Requirements to expand rootfs on startup https://openwrt.org/docs/guide-user/advanced/expand_root
PACKAGES+=(parted losetup resize2fs)
# Ease of use
PACKAGES+=(htop screen tmux terminfo)

wget -N $IMGBLDR_URL

guix shell --container --manifest=manifest.scm --symlink="/usr/bin/env=bin/env" -- bash -i -s <<EOF
echo "Decompressing"
tar --zstd -xvf $IMGBLDR_FN
cd $(basename $IMGBLDR_FN .tar.zst)

echo "Preventative clean"
make clean
EOF


#TODO: switch to package structure?
