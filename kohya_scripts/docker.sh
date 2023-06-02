#!/usr/bin/env bash

CNAME=kohya_ss

# a global cache across multiple docker containers
HOSTC=/home/work/_cache

# persistent volume between runs that contains python
# virtual environment and download models
HOSTD=/home/data/stable-diffusion/kohya_scripts
mkdir -p $HOSTD/venv
mkdir -p $HOSTD/data

# this should be the models directory of the webui
# so we can reuse the downloaded models
HOSTE=/home/data/stable-diffusion/automatic
mkdir -p $HOSTE/models

# the working scripts directory
HOSTS=./scripts
WORKD=./app

# clone the git repository or pull the latest version
pull() {
    if [[ -d kohya_ss ]]; then 
        cd kohya_ss/
        git pull
        cd ..
    else
        git clone --depth=1 https://github.com/kohya-ss/sd-scripts.git
    fi
}

# rebuild the docker image
build() {
    export BUILDKIT_PROGRESS=plain && docker build -t $CNAME -f Dockerfile .
}

run() {
    docker run -it --gpus all \
        -v $WORKD/:/home/user/app/ \
        -v $HOSTC:/home/user/.cache/ \
        -v $HOSTS:/home/user/scripts/ \
        -v $HOSTD/venv/:/home/user/venv/ \
        -v $HOSTD/data/:/home/user/data/ \
        -v $HOSTE/models/:/home/user/models/ \
        -p 8889:7860 \
        -p 8890:6006 \
        $CNAME "$@"
}

# attach to the running container
attach() {
    # parse the id first
    cid=$(docker ps -aqf "name=$CNAME")
    docker exec -it $cid /bin/bash
}

"$@"
