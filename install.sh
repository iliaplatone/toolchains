#!/bin/bash

dir=$(pwd)
version=$1
crosstool=$2
arch=$3
instdir=$dir/$arch/gcc-$version
suffix=$4

packages="binutils-$crosstool cpp-$version-$crosstool gcc-$version-$crosstool-base libstdc++-$version-dev-$arch$suffix libgcc1-$arch$suffix libgcc-$version-dev-$arch$suffix libc6-$arch$suffix libc6-dev-$arch$suffix linux-libc-dev-$arch$suffix gcc-$version-$crosstool g++-$version-$crosstool libisl[0-9]* libmpc[0-9]* libmpfr[0-9]*"

mkdir -p $instdir
mkdir -p temp
pushd temp
for deb in $packages; do apt download $deb; done
for deb in *.deb; do dpkg-deb -x $deb $instdir; done
pushd $instdir
rsync -ar usr/ ./
rm -r usr/
ln -s ./ usr
popd
popd
rm -r temp
