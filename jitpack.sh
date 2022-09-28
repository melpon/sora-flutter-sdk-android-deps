#!/bin/bash

set -ex

cd `dirname $0`
PROJECT_DIR=`pwd`
SOURCE_DIR=$PROJECT_DIR/_source
INSTALL_DIR=$PROJECT_DIR/_install/android
rm -rf $SOURCE_DIR
rm -rf $INSTALL_DIR
mkdir -p $SOURCE_DIR
mkdir -p $INSTALL_DIR

SORA_VERSION=2022.12.1
BOOST_VERSION=1.80.0
WEBRTC_VERSION=m105.5195.0.0
PLATFORM=android
EXT=tar.gz

SORA_FILENAME=sora-cpp-sdk-${SORA_VERSION}_${PLATFORM}.${EXT}
SORA_URL=https://github.com/shiguredo/sora-cpp-sdk/releases/download/$SORA_VERSION/$SORA_FILENAME

BOOST_FILENAME=boost-${BOOST_VERSION}_sora-cpp-sdk-${SORA_VERSION}_${PLATFORM}.${EXT}
BOOST_URL=https://github.com/shiguredo/sora-cpp-sdk/releases/download/$SORA_VERSION/$BOOST_FILENAME

WEBRTC_FILENAME=webrtc.android.tar.gz
WEBRTC_URL=https://github.com/shiguredo-webrtc-build/webrtc-build/releases/download/$WEBRTC_VERSION/$WEBRTC_FILENAME


pushd $SOURCE_DIR
  curl -LO $SORA_URL
  curl -LO $BOOST_URL
  curl -LO $WEBRTC_URL
popd

pushd $INSTALL_DIR
  if [ $EXT = "zip" ]; then
    unzip $SOURCE_DIR/$SORA_FILENAME
    unzip $SOURCE_DIR/$BOOST_FILENAME
    unzip $SOURCE_DIR/$WEBRTC_FILENAME
  else
    tar -xf $SOURCE_DIR/$SORA_FILENAME
    tar -xf $SOURCE_DIR/$BOOST_FILENAME
    tar -xf $SOURCE_DIR/$WEBRTC_FILENAME
  fi
popd

rm -rf prefab/modules/sora/include
cp -r $INSTALL_DIR/sora/include prefab/modules/sora/include
cp $INSTALL_DIR/sora/lib/libsora.a prefab/modules/sora/libs/android.arm64-v8a/

zip -r sora_flutter_sdk_android_deps.aar prefab/ AndroidManifest.xml

mvn install:install-file \
  -Dfile=sora_flutter_sdk_android_deps.aar \
  -Dversion=${SORA_VERSION} \
  -Dpackaging=aar \
  -DgroupId=com.github.melpon \
  -DartifactId=android
