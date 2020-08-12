#!/bin/bash

set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
source $DIR/common.sh

set +o noglob

stage=0

workdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $workdir

h2 "[Step $stage]: checking if docker is installed ..."; let stage+=1
check_docker

h2 "[Step $stage]: checking docker-compose is installed ..."; let stage+=1
check_dockercompose

h2 "[Step $stage]: loading te-webhook3's image ..."; let stage+=1
if [ -f te-webhook3_*.tar.xz ]
then
    note "Great! found te-webhook3's image file ..."
    docker load -i ./te-webhook3_*.tar.xz
else
    error "te-webhook3's .tar.gz file missing or use a incorrect naming format."
    exit 1
fi
echo ""

h2 "[Step $stage]: preparing environment ...";  let stage+=1
note 'TAG='$(ls | grep te-webhook3_ | grep .tar.xz | cut -c 13-19)
echo 'TAG='$(ls | grep te-webhook3_ | grep .tar.xz | cut -c 13-19) > .env
echo ""

h2 "[Step $stage]: checking if container is running ...";  let stage+=1
if [ -n "$(docker-compose --compatibility ps -q)"  ]
then
    note "te-webhook3 is running, stopping existing te-webhook3 instance ..." 
    docker-compose --compatibility down -v
fi
note "te-webhook3 is not running ..."
echo ""

h2 "[Step $stage]: starting te-webhook3 ...";  let stage+=1
docker-compose --compatibility up -d
if [ -n "$(docker ps | grep te-webhook3 | grep up)"]
then
    note "te-webhook3 has been installed."
else
    error "te-webhook3 up fail."
    exit 1
fi
echo ""

h2 "[Step $stage]: testing te-webhook3 ..."
sleep 5
docker exec -it te-webhook3 sh -c 'cd unitTest && sh ./test.sh'
success $"----te-webhook3 started successfully.----"
