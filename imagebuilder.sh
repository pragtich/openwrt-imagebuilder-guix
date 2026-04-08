#!/bin/bash

REL="25.12.2"
ARCH="x86"
VARIANT="64"
IMGBLDR_FN="openwrt-imagebuilder-${REL}-${ARCH}-${VARIANT}.Linux-${ARCH}_${VARIANT}.tar.zst"
IMGBLDR_URL="https://downloads.openwrt.org/releases/${REL}/targets/${ARCH}/${VARIANT}/${IMGBLDR_FN}"

wget $IMGBLDR_URL

guix shell --container --manifest=manifest.scm


#TODO: switch to package structure?
