#!/bin/bash

REL="25.12.4"
ARCH="x86"
VARIANT="64"
export IMGBLDR_FN="openwrt-imagebuilder-${REL}-${ARCH}-${VARIANT}.Linux-${ARCH}_${VARIANT}.tar.zst"
export IMGBLDR_URL="https://downloads.openwrt.org/releases/${REL}/targets/${ARCH}/${VARIANT}/${IMGBLDR_FN}"
export IMGBLDR_PROFILE="generic"		# make info: the only option for x86/64

mkdir -p ${PWD}/tmp
wget -N $IMGBLDR_URL
echo "Filename: $IMGBLDR_FN"
guix shell --pure --manifest=manifest.scm --network --share=${PWD}/tmp --share=/tmp --preserve='^IMGBLDR' -- bash -s <<< $(cat packages ; cat <<'EOF' )
echo "Package list:"
echo "${PACKAGES[*]}"

export MAKE_TMPDIR=${PWD}/tmp
export TMPDIR=${PWD}/tmp
export MYFILES="../files"
echo "Filename: $IMGBLDR_FN"
echo "Decompressing"
tar --zstd  -xvf $IMGBLDR_FN
cd $(basename $IMGBLDR_FN .tar.zst)

echo "Preventative clean"
make clean
mkdir -p tmp

echo "Starting build"
make image PROFILE="$IMGBLDR_PROFILE" FILES="$MYFILES" PACKAGES="${PACKAGES[*]}"
echo "Done."

EOF
