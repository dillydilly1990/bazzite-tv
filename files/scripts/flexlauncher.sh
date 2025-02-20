#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# Your code goes here.
echo 'install build dependencys'
rpm-ostree install SDL2-devel SDL2_image-devel SDL2_ttf-devel inih-devel
echo 'clone master repo and create build dir'
git clone https://github.com/complexlogic/flex-launcher.git
cd flex-launcher
mkdir build && cd build
echo 'generate make file'
cmake .. -DCMAKE_BUILD_TYPE=Release
echo 'build and test'
make
./flex-launcher
echo 'install'
sudo make install