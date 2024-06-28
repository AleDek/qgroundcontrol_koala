#!/bin/bash
#----------------------------------------------------------
# You will need:
# - Qt 5.5.x android_armv7 kit
# - Android SDK
# - Androig NDK
# - Current Java
# - ant
#----------------------------------------------------------
# Update with correct location for these
export ANDROID_HOME=/root/Android/Sdk
export ANDROID_SDK_ROOT=/root/Android/Sdk
export ANDROID_NDK_ROOT=/root/Android/Sdk/ndk/21.3.6528147
export ANDROID_NDK_HOST=linux-x86_64
export ANDROID_NDK_PLATFORM=/android-9
export ANDROID_NDK_TOOLCHAIN_PREFIX=aarch64-linux-android
export ANDROID_NDK_TOOLCHAIN_VERSION=4.9
export ANDROID_NDK_TOOLS_PREFIX=aarch64-linux-android
#----------------------------------------------------------
# To build it, run (replacing the path with where you have Qt installed)
#
# >source android_environment.sh
# cd ../
# mkdir android_build
# cd android_build
# >~/local/Qt/5.4/android_armv7/bin/qmake -r -spec android-g++ CONFIG+=debug ../qgroundcontrol/qgroundcontrol.pro
# >make -j24 install INSTALL_ROOT=./android-build/
# >~/local/Qt/5.4/android_armv7/bin/androiddeployqt --input ./android-libQGroundControl.so-deployment-settings.json --output ./android-build --deployment bundled --android-platform android-22 --jdk /System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home --verbose --ant /usr/local/bin/ant
# /opt/Qt/5.15.2/android/bin

## COMPILAZIONE LINUX
# in qgc rppt dir
# docker build --file ./deploy/docker/Dockerfile-build-linux -t qgc-linux-docker .
# docker run --rm -v ${PWD}:/project/source -v ${PWD}/build:/project/build qgc-linux-docker
# cd deploy
# ./create_linux_appimage.sh ../ ../build/staging 
# find .appimage in deploy folder

### COMPILAZIONE ANDROID
#--- ./docker_connection.sh
#--- 1 qgc-build-android
#not source this 
#in qgc root dir
#mkdir buildandroid
#cd buildandroid
#qmake -r ../ ANDROID_ABIS="armeabi-v7a arm64-v8a" CONFIG+="debug"
#make -j24 install INSTALL_ROOT=./
#androiddeployqt --input ./android-QGroundControl-deployment-settings.json --output ./ --deployment bundled