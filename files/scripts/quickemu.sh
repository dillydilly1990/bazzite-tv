#!/bin/bash

set -ouex pipefail

# it may be needed to add additional installation sources to obtain some packages
# for example zsync is no longer in the fedora repo, but can be obtained from copr
dnf copr enable elxreno/zsync -y 
rpm-ostree install bash coreutils curl edk2-tools genisoimage grep jq mesa-demos pciutils procps python3 qemu sed socat spice-gtk-tools swtpm unzip usbutils util-linux xdg-user-dirs xrandr zsync
git clone https://github.com/quickemu-project/quickemu
cd quickemu
make install
rpm-ostree install https://github.com/quickemu-project/quickgui/releases/download/1.2.10/quickgui-1.2.10+1-linux.rpm