# QgroundControl for Koala Drone
Custom qground version for koala drone task-specific interface
this version is base on Qground Stable_V4.4 , QT 5.15.2 

## Build instruction

### clone repository 
create a folder and clone the right branch and submodules
```sh
mkdir qgc_develop
cd qgc_develop
git clone https://github.com/AleDek/qgroundcontrol_koala.git -b Stable_V4.4 --recursive
```

### build linux
to build for linux and generate app image using docker
```sh
cd qgroundcontrol_koala
mkdir build
docker build --file ./deploy/docker/Dockerfile-build-linux -t qgc-linux-docker .
docker run --rm -v ${PWD}:/project/source -v ${PWD}/build:/project/build qgc-linux-docker
./deploy/create_linux_appimage.sh ./ ./build/staging ./build/staging
cd build/staging
mv QGroundControl.AppImage QGroundControl_koala.AppImage
```
then find appimage in qgroundcontrol_koala/build/staging

### build android
build android apk using docker 
```sh
mkdir buildandroid
docker build --file ./deploy/docker/Dockerfile-build-android -t qgc-android-docker .
docker run --rm -v ${PWD}:/project/source -v ${PWD}/buildandroid:/project/buildandroid qgc-android-docker
```
then find the apk in qgroundcontrol_koala/buildandroid/build/outputs/apk/debug/

### issue on git tags
if while compiling for android pup up this error "Project ERROR: Dev version larger than 3 digits: 10960"
then is necessary to set a new git tag like "v4.4.<n>" BEFORE compile.
```sh
git tag -a v4.4.10 
```
to print out current tags "git tag" (q for exit) 

## cleanup befor pushing or commit
before pushing or ALSO COMMIT remebrer clean up removing build folders, to avoid huge dimension files like apk a appimage enter in the git history.
```sh
cd qgroundcontrol_koala
rm -r build
sudo rm -r buildandroid
```



# QGroundControl Ground Control Station

[![Releases](https://img.shields.io/github/release/mavlink/QGroundControl.svg)](https://github.com/mavlink/QGroundControl/releases)

*QGroundControl* (QGC) is an intuitive and powerful ground control station (GCS) for UAVs.

The primary goal of QGC is ease of use for both first time and professional users.
It provides full flight control and mission planning for any MAVLink enabled drone, and vehicle setup for both PX4 and ArduPilot powered UAVs. Instructions for *using QGroundControl* are provided in the [User Manual](https://docs.qgroundcontrol.com/en/) (you may not need them because the UI is very intuitive!)

All the code is open-source, so you can contribute and evolve it as you want.
The [Developer Guide](https://dev.qgroundcontrol.com/en/) explains how to [build](https://dev.qgroundcontrol.com/en/getting_started/) and extend QGC.


Key Links:
* [Website](http://qgroundcontrol.com) (qgroundcontrol.com)
* [User Manual](https://docs.qgroundcontrol.com/en/)
* [Developer Guide](https://dev.qgroundcontrol.com/en/)
* [Discussion/Support](https://docs.qgroundcontrol.com/en/Support/Support.html)
* [Contributing](https://dev.qgroundcontrol.com/en/contribute/)
* [License](https://github.com/mavlink/qgroundcontrol/blob/master/COPYING.md)
