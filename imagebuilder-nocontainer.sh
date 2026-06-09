#!/bin/bash

REL="25.12.4"
ARCH="x86"
VARIANT="64"
export IMGBLDR_FN="openwrt-imagebuilder-${REL}-${ARCH}-${VARIANT}.Linux-${ARCH}_${VARIANT}.tar.zst"
export IMGBLDR_URL="https://downloads.openwrt.org/releases/${REL}/targets/${ARCH}/${VARIANT}/${IMGBLDR_FN}"
export IMGBLDR_PROFILE="generic"		# make info: the only option for x86/64

echo "Selected additional packages:"
echo "${PACKAGES[*]}"

echo "Downloading release."
wget -N $IMGBLDR_URL
guix shell --pure --manifest=manifest.scm --network --preserve='^IMGBLDR' -- bash -s <<< $(cat packages ; cat <<'EOF' )
export MYFILES="../files"
echo "Decompressing"
tar --zstd  -xf $IMGBLDR_FN
cd $(basename $IMGBLDR_FN .tar.zst)

echo "Preventative clean"
make clean

echo "Starting build"
make image PROFILE="$IMGBLDR_PROFILE" FILES="$MYFILES" PACKAGES="${PACKAGES[*]}"
echo "Done."

EOF
