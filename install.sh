#!/bin/bash

version=$1

packages="binutils binutils-common libbinutils binutils-x86-64-linux-gnu cpp-$version gcc-$version-base libc6 libcc1-0 libgcc-$version-dev libgcc1 libgmp10 libisl15 libmpfr4 libstdc++6 libmpc3 zlib1g gcc-$version g++-$version libc6"

mkdir -p temp
pushd temp
apt -qqq download $packages
file-roller -h *.deb
popd
mkdir -p gcc-$version
pushd gcc-$version
for deb in ../temp/*/; do tar zxf $deb/data.tar.gz 2>/dev/null || tar Jxf $deb/data.tar.xz 2>/dev/null; done
pushd usr/bin
for file in *-$version; do sudo ln -nfs $file $( echo $file | sed -e "s/-$version//g" ); done
popd
popd
sudo rm -r temp
