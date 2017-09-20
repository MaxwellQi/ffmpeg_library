set -x
./x264build.sh
cp -rf x264/x264-uarch/include/* ../../include/x264/
cp -rf x264/x264-uarch/lib/* ../../lib/

./build-ffmpeg.sh
cp -rf FFmpeg-iOS/include/* ../../include/
cp -rf FFmpeg-iOS/lib/* ../../lib/ 
