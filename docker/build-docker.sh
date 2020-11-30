#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR/..

DOCKER_IMAGE=${DOCKER_IMAGE:-wildfirepay/wildfired-develop}
DOCKER_TAG=${DOCKER_TAG:-latest}

BUILD_DIR=${BUILD_DIR:-.}

rm docker/bin/*
mkdir docker/bin
cp $BUILD_DIR/src/wildfired docker/bin/
cp $BUILD_DIR/src/wildfire-cli docker/bin/
cp $BUILD_DIR/src/wildfire-tx docker/bin/
strip docker/bin/wildfired
strip docker/bin/wildfire-cli
strip docker/bin/wildfire-tx

docker build --pull -t $DOCKER_IMAGE:$DOCKER_TAG -f docker/Dockerfile docker
