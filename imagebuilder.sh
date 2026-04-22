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

wget -N $IMGBLDR_URL

guix shell --container --manifest=manifest.scm --symlink="/usr/bin/env=bin/env" -- bash -i -s <<EOF
echo "Reading packages"
declare -a PACKAGES		# space separated list; -package to exclude; auto dependencies
source packages

echo "Decompressing"
tar --zstd -xvf $IMGBLDR_FN
cd $(basename $IMGBLDR_FN .tar.zst)

echo "Preventative clean"
make clean


echo "Starting build"

echo make image PROFILE="$PROFILE" PACKAGES="${PACKAGES[*]}" FILES="$MYFILES" 

#make image PROFILE="$PROFILE" FILES="$MYFILES" PACKAGES="${PACKAGES[*]}"
make image PROFILE="$PROFILE" FILES="pragtich/files" PACKAGES="${PACKAGES[*]}" 

echo "Done."

EOF


#TODO: switch to package structure?
