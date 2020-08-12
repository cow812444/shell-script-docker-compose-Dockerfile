!/bin/bash

set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
source $DIR/common.sh

set +o noglob

REPO=harbor.lishang4.com:4510/emotibot
CONTAINER=te-webhook3
TAG=$(git rev-parse --short HEAD)
DOCKER_IMAGE=$REPO/$CONTAINER:$TAG
stage=0

workdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $workdir

h2 "[Step $stage]: checking if docker is installed ..."; let stage+=1
check_docker

h2 "[Step $stage]: checking docker-compose is installed ..."; let stage+=1
check_dockercompose

h2 "[Step $stage]: starting docker build  ..."; let stage+=1
./build.sh
echo ""

sleep 2

h2 "[Step $stage]: starting te-webhook3 & unittest   ..."
./local.sh dev.env ${TAG}

success $"----te-webhook3 started successfully.----"
