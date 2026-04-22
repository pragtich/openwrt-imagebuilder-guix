#!/bin/bash

REL="25.12.2"
ARCH="x86"
VARIANT="64"
IMGBLDR_FN="openwrt-imagebuilder-${REL}-${ARCH}-${VARIANT}.Linux-${ARCH}_${VARIANT}.tar.zst"
IMGBLDR_URL="https://downloads.openwrt.org/releases/${REL}/targets/${ARCH}/${VARIANT}/${IMGBLDR_FN}"

wget -N $IMGBLDR_URL

guix shell --container --manifest=manifest.scm -- bash -s <<EOF
echo "Decompressing"
tar --zstd -xvf $IMGBLDR_FN
cd $(basename $IMGBLDR_FN .tar.zst)


EOF


#TODO: switch to package structure?
