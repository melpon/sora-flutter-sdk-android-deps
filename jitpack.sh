#!/bin/bash

set -ex

PROJECT_DIR=$(cd `dirname $0` && pwd)
SOURCE_DIR=$PROJECT_DIR/_source
INSTALL_DIR=$PROJECT_DIR/_install/windows_x86_64
rm -rf $SOURCE_DIR
rm -rf $INSTALL_DIR
mkdir -p $SOURCE_DIR
mkdir -p $INSTALL_DIR

SORA_VERSION=2022.12.1
PLATFORM=windows_x86_64
EXT=zip

SORA_FILENAME=sora-cpp-sdk-${SORA_VERSION}_${PLATFORM}.${EXT}
SORA_URL=https://github.com/shiguredo/sora-cpp-sdk/releases/download/$SORA_VERSION/$SORA_FILENAME

pushd $SOURCE_DIR
  curl -LO $SORA_URL
popd

pushd $INSTALL_DIR
  if [ $EXT = "zip" ]; then
    unzip $SOURCE_DIR/$SORA_FILENAME
  else
    tar -xf $SOURCE_DIR/$SORA_FILENAME
  fi
popd

mvn install:install-file \
  -Dfile=$SOURCE_DIR/$SORA_FILENAME \
  -Dversion=${SORA_VERSION} \
  -Dpackaging=zip \
  -DgroupId=com.github.melpon \
  -DartifactId=android
