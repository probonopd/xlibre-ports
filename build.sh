#!/bin/sh

set -e

build_package()
{
  PORT=$1
  ( cd "${PORT}" && make build-depends-list | cut -c 12- | xargs pkg install -y ) 
  make -C "${PORT}" package
}

mount -t unionfs $(readlink -f .) /usr/ports
HERE="${PWD}"
cd /usr/ports

build_package x11-servers/xlibre-server

# Install the xlibre-server package, otherwise driver builds fail
PKG_FILE=$(find . -name 'xlibre-server*.pkg' | head -n 1)
if [ -n "$PKG_FILE" ]; then
  pkg install -y "$PKG_FILE"
fi

build_package x11-drivers/xlibre-xf86-input-elographics
build_package x11-drivers/xlibre-xf86-input-evdev
build_package x11-drivers/xlibre-xf86-input-joystick
build_package x11-drivers/xlibre-xf86-input-keyboard
build_package x11-drivers/xlibre-xf86-input-libinput
build_package x11-drivers/xlibre-xf86-input-mouse
build_package x11-drivers/xlibre-xf86-input-synaptics
build_package x11-drivers/xlibre-xf86-input-vmmouse
build_package x11-drivers/xlibre-xf86-input-void
build_package x11-drivers/xlibre-xf86-input-wacom
build_package x11-drivers/xlibre-xf86-video-amdgpu
build_package x11-drivers/xlibre-xf86-video-ast
build_package x11-drivers/xlibre-xf86-video-ati
build_package x11-drivers/xlibre-xf86-video-dummy
build_package x11-drivers/xlibre-xf86-video-intel
build_package x11-drivers/xlibre-xf86-video-mga
build_package x11-drivers/xlibre-xf86-video-nv
build_package x11-drivers/xlibre-xf86-video-qxl
build_package x11-drivers/xlibre-xf86-video-vesa
build_package x11-drivers/xlibre-xf86-video-vmware
build_package x11-drivers/xlibre-drivers

cd "${HERE}"
umount /usr/ports

# FreeBSD repository
ABI=$(pkg config abi) # E.g., FreeBSD:13:amd64
mkdir -p "${ABI}"
find . -name '*.pkg' -exec mv {} "${ABI}/" \;
pkg repo "${ABI}/"
# index.html for the FreeBSD repository
cd "${ABI}/"
echo "<html><ul>" > index.html
find . -depth 1 -exec echo '<li><a href="{}" download>{}</a></li>' \; | sed -e 's|\./||g' >> index.html
echo "</ul></html>" >> index.html
cd -
