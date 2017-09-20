#!/bin/sh
trap exit ERR

./x264build.sh

curl http://ffmpeg.org/releases/ffmpeg-2.6.1.tar.bz2 > ffmpeg-2.6.1.tar.bz2
tar -zxvf ffmpeg-2.6.1.tar.bz2

BUILDPATH=`pwd`

cd ffmpeg-2.6.1

X264PATH="${BUILDPATH}/x264/x264-uarch"

echo $X264PATH

echo "Building armv7..."


./configure --enable-cross-compile --arch=arm --target-os=darwin --cc=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang --as='../gas-preprocessor.pl /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang' --sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS8.1.sdk --cpu=cortex-a8 --extra-cflags="-I${X264PATH}/include -arch armv7" --extra-ldflags="-L${X264PATH}/lib -arch armv7 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS8.1.sdk" --disable-shared --enable-static --enable-nonfree --disable-yasm --disable-ffserver --disable-ffplay  --disable-avfilter  --disable-ffmpeg  --disable-ffprobe --disable-asm --enable-gpl --enable-libx264 --prefix=armv7
make
make install


echo "Building armv7s..."
make clean
./configure --enable-cross-compile --arch=arm --target-os=darwin --cc=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang --as='../gas-preprocessor.pl /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang' --sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS8.1.sdk --cpu=cortex-a8 --extra-cflags="-I${X264PATH}/include -arch armv7s" --extra-ldflags="-L${X264PATH}/lib -arch armv7s -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS8.1.sdk" --disable-shared --enable-static --enable-nonfree --disable-yasm --disable-ffserver --disable-ffplay  --disable-avfilter  --disable-ffmpeg  --disable-ffprobe --disable-asm --enable-gpl --enable-libx264 --prefix=armv7s

make
make install

echo "Building arm64..."
make clean
./configure --enable-cross-compile --arch=arm --target-os=darwin --cc=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang --as='gas-preprocessor.pl /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang' --sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS8.1.sdk --target-os=darwin --extra-cflags="-I${X264PATH}/include -arch arm64" --extra-ldflags="-L${X264PATH}/lib -arch arm64 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS8.1.sdk" --disable-shared --enable-static --enable-nonfree --disable-yasm --disable-ffserver --disable-ffplay  --disable-avfilter  --disable-ffmpeg  --disable-ffprobe --disable-asm --enable-gpl --enable-libx264 --prefix=arm64
make
make install


echo "Combining Libraries"

mkdir ios-uarch
mkdir ios-uarch/lib
mkdir ios-uarch/include

cp -r ./armv7/include/* ./ios-uarch/include/

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/lipo -create -arch arm64 arm64/lib/libavcodec.a -arch armv7 armv7/lib/libavcodec.a -arch armv7s armv7s/lib/libavcodec.a -output ./ios-uarch/lib/libavcodec.a
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/lipo -create -arch arm64 arm64/lib/libavdevice.a -arch armv7 armv7/lib/libavdevice.a -arch armv7s armv7s/lib/libavdevice.a -output ./ios-uarch/lib/libavdevice.a
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/lipo -create -arch arm64 arm64/lib/libavformat.a -arch armv7 armv7/lib/libavformat.a -arch armv7s armv7s/lib/libavformat.a -output ./ios-uarch/lib/libavformat.a
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/lipo -create -arch arm64 arm64/lib/libavutil.a -arch armv7 armv7/lib/libavutil.a -arch armv7s armv7s/lib/libavutil.a -output ./ios-uarch/lib/libavutil.a
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/lipo -create -arch arm64 arm64/lib/libpostproc.a -arch armv7 armv7/lib/libpostproc.a -arch armv7s armv7s/lib/libpostproc.a -output ./ios-uarch/lib/libpostproc.a
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/lipo -create -arch arm64 arm64/lib/libswresample.a -arch armv7 armv7/lib/libswresample.a -arch armv7s armv7s/lib/libswresample.a -output ./ios-uarch/lib/libswresample.a
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/lipo -create -arch arm64 arm64/lib/libswscale.a -arch armv7 armv7/lib/libswscale.a -arch armv7s armv7s/lib/libswscale.a -output ./ios-uarch/lib/libswscale.a


mkdir ../ffmpeglib
mkdir ../ffmpeglib/lib
mkdir ../ffmpeglib/include
cd ..
cp -r ./ios-uarch/include/* ../ffmpeglib/include/
cd ..
cp x264/x264-uarch/lib/*  ./ffmpeglib/lib/
mkdir ffmpeglib/include/x264
cp x264/x264-uarch/include/* ./ffmpeglib/include/x264/
rm -rf x264
rm -rf ffmpeg-2.6.1
rm -rf ffmpeg-2.6.1.tar.bz2