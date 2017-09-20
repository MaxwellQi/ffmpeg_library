#!/bin/sh


# This script is originally based off of the one by Gabriel Handford
# Original scripts can be found here: https://github.com/gabriel/ffmpeg-iphone-build
# Modified by Roderick Buenviaje
# Builds versions of the VideoLAN x264 for armv6 and armv7
# Combines the two libraries into a single one

trap exit ERR

export DIR=./x264
export DEST6=armv6/
export DEST7=armv7/
export DEST7S=armv7s/
export DEST64=armv64/
#specify the version of iOS you want to build against
export VERSION="6.1"
export IOS_SDK=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk

mkdir -p ./x264

git clone git://git.videolan.org/x264.git x264

cd $DIR

echo "Building armv7..."

CC=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang ./configure --host=arm-apple-darwin --sysroot=$IOS_SDK --prefix=armv7/ --extra-cflags='-arch armv7' --extra-ldflags='-L$IOS_SDK/usr/lib/system -arch armv7' --enable-pic --enable-static --disable-asm

make && make install

echo "Installed: $DEST7"

echo "Building armv7s..."

CC=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang ./configure --host=arm-apple-darwin --sysroot=$IOS_SDK --prefix=armv7s/ --extra-cflags='-arch armv7s' --extra-ldflags='-L$IOS_SDK/usr/lib/system -arch armv7s' --enable-pic --enable-static --disable-asm

make && make install

echo "Installed: $DEST7S"


echo "Building arm64..."

CC=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang ./configure --host=arm-apple-darwin --sysroot=$IOS_SDK --prefix=arm64/ --extra-cflags='-arch arm64' --extra-ldflags='-L$IOS_SDK/usr/lib/system -arch arm64' --enable-pic --enable-static --disable-asm

make && make install

echo "Installed: $DEST64"

echo "Combining Libraries"

mkdir x264-uarch
mkdir x264-uarch/lib
mkdir x264-uarch/include

cp ./armv7/include/* ./x264-uarch/include/

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/lipo -create -arch arm64 arm64/lib/libx264.a -arch armv7 armv7/lib/libx264.a -arch armv7s armv7s/lib/libx264.a -output ./x264-uarch/lib/libx264.a

