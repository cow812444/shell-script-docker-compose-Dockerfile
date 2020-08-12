#!/bin/bash
REPO=harbor.lishang4.com:4510/emotibot
CONTAINER=te-webhook3
TAG=$(git rev-parse --short HEAD)
DOCKER_IMAGE=$REPO/$CONTAINER:$TAG

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILDROOT=$DIR/../te-webhook3_deploy

# remove old tar.xz file
cmd="rm -rf $BUILDROOT/te-webhook3_*.tar.xz"
echo $cmd
eval $cmd

sleep 1

# docker save as tar.xz
cmd="docker save $DOCKER_IMAGE | xz -T0 -c > $BUILDROOT/te-webhook3_$TAG.tar.xz"
echo $cmd
eval $cmd
