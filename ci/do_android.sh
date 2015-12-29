#!/bin/bash

echo "================================="
pwd
echo "================================="
echo $ANDROID_HOME
echo "================================="
echo $START_PATH
echo "================================="
echo ${CIRCLE_PROJECT_REPONAME}
echo "================================="


export START_PATH=~/
export SOURCE_PATH="$START_PATH""/"${CIRCLE_PROJECT_REPONAME}"/"

export ANDROID_NDK="/usr/local/android-ndk/"
export _NDK_="$ANDROID_NDK"
 
export ANDROID_SDK="/usr/local/android-sdk-linux/"
export _SDK_="$ANDROID_SDK"

export BUILD_PATH="$START_PATH""/android-build"

rm navit/maptool/poly2tri-c/001/seidel-1.0/triangulate && \
rm pngout-static && \
echo '#! /bin/bash' > pngout-static && \
echo 'echo $*' >> pngout-static && \
chmod u+rx pngout-static

if [ `uname -m` == 'x86_64' ] ; then SUFFIX2='_64' ; else SUFFIX2='' ; fi && \
export PATH=$PATH:$_SDK_/tools:$_SDK_/platform-tools:$_NDK_/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86$SUFFIX2/bin

mkdir -p $BUILD_PATH
cd $BUILD_PATH

DEBUG_="-fpic -ffunction-sections -fstack-protector -fomit-frame-pointer -fno-strict-aliasing -D__ARM_ARCH_5__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5TE__  -Wno-psabi -march=armv5te -msoft-float -mthumb -finline-limit=64 -DHAVE_API_ANDROID -DANDROID  -Wa,--noexecstack -O3 -I$_NDK_/platforms/android-14/arch-arm/usr/include -nostdlib -Wl,-rpath-link=$_NDK_/platforms/android-14/arch-arm/usr/lib -L$_NDK_/platforms/android-14/arch-arm/usr/lib" && \
        ../navit/configure RANLIB=arm-linux-androideabi-ranlib AR=arm-linux-androideabi-ar CC="arm-linux-androideabi-gcc -O2 $DEBUG_ -L. -L$_NDK_/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86$SUFFIX2/lib/gcc/arm-linux-androideabi/4.8/ -lgcc -ljnigraphics " CXX="arm-linux-androideabi-g++ -O2 -fno-rtti -fno-exceptions -L$_NDK_/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86$SUFFIX2/lib/gcc/arm-linux-androideabi/4.8/ -lgcc -ljnigraphics " --host=arm-eabi-linux_android --enable-avoid-float --enable-avoid-unaligned --disable-glib --disable-gmodule --disable-vehicle-gpsd --enable-vehicle-demo --disable-binding-dbus --disable-speech-cmdline --disable-gui-gtk --disable-font-freetype --disable-fontconfig --disable-graphics-gtk-drawing-area --disable-maptool --enable-cache-size=20971520 --enable-svg2png-scaling=8,16,32,48,64,96,192,384 --enable-svg2png-scaling-nav=48,64,59,96,192,384 --enable-svg2png-scaling-flag=32 --with-xslts=android,plugin_menu --with-saxon=saxonb-xslt --enable-transformation-roll --with-android-project="android-21" && \
        export AND_API_LEVEL_C=14 && \
        export NDK=$_NDK_ && \
        export DO_RELEASE_BUILD=1 && \
        export DO_PNG_BUILD=1 && \
        export NDK_CCACHE="" && \
        make && \
        pwd && \
        cd navit && \
        make apkg-release || pwd && \
        cd android-support-v7-appcompat && \
        cat local.properties |sed -e 's#/home/navit/_navit_develop/_need/SDK/_unpack/android-sdk-linux_x86#$_SDK_#' > l.txt && \
        mv l.txt local.properties && \
        cat local.properties
        
        
        pwd
        cd ../android
        pwd
        cat AndroidManifest.xml | sed -e 's#android:debuggable="true"#android:debuggable="false"#' > l.txt
        mv l.txt AndroidManifest.xml
        cat AndroidManifest.xml | sed -e 's#android:versionName=".*"#android:versionName="2.0.40"#' > l.txt
        mv l.txt AndroidManifest.xml
        ant release