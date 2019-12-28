#!/bin/bash

version=$1
crosstool=$2
arch=$3
instdir=$arch/gcc-$version
suffix=$4

packages="binutils-$crosstool cpp-$version-$crosstool gcc-$version-$crosstool-base libstdc++-$version-dev-$arch$suffix libgcc1-$arch$suffix libgcc-$version-dev-$arch$suffix libc6-$arch$suffix libc6-dev-$arch$suffix linux-libc-dev-$arch$suffix gcc-$version-$crosstool g++-$version-$crosstool"

mkdir -p temp
pushd temp
for deb in $packages; do apt -qqq download $deb; done
file-roller -h *.deb
popd
mkdir -p $instdir
pushd $instdir
for deb in ../../temp/*/; do tar zxf $deb/data.tar.gz 2>/dev/null || tar Jxf $deb/data.tar.xz 2>/dev/null; done
pushd usr/bin
for file in *$version; do sudo ln -nfs $file $( echo $file | sed -e "s/-$version//g" ); done
popd
rsync -ar usr/ ./
rm -r usr/
ln -s ./ usr
popd
sudo rm -r temp
