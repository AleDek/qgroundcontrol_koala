#!/usr/bin/env bash

# Set default variables
QT_VERSION="${QT_VERSION:-5.15.2}"
QT_PATH="${QT_PATH:-/opt/Qt}"
QT_HOST="${QT_HOST:-linux}"
QT_TARGET="${QT_TARGET:-android}"
QT_ARCH="${QT_ARCH:-android_armv7}"
QT_MODULES="${QT_MODULES:-qtcharts}"

# aqt install-qt linux android 5.15.2 android_armv7 -O /opt/Qt -m qtcharts

# Exit immediately if a command exits with a non-zero status
set -e

apt-get update
apt-get install python3 python3-pip -y
pip3 install aqtinstall
# aqt install-qt ${QT_HOST} ${QT_TARGET} ${QT_VERSION} ${QT_ARCH} -O ${QT_PATH} -m ${QT_MODULES}
# aqt install-qt linux android 5.15.2 android_armv7 -O /opt/Qt -m qtcharts
aqt install-qt linux android 5.15.2 android -O /opt/Qt -m qtcharts
echo "Remember to export the following to your PATH: ${QT_PATH}/${QT_VERSION}/*/bin"
echo "export PATH=$(readlink -e ${QT_PATH}/${QT_VERSION}/*/bin/):PATH"