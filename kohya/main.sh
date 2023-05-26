#!/usr/bin/env bash

CNAME=kohya

# a global cache across multiple docker containers
HOSTC=/home/hdd/_cache

# persistent volume between runs that contains python
# virtual environment and download models
HOSTD=/home/hdd/stable-diffusion/kohya
mkdir -p $HOSTD/venv
mkdir -p $HOSTD/data

# this should be the models directory of the webui
# so we can reuse the downloaded models
HOSTE=/home/hdd/stable-diffusion/automatic
mkdir -p $HOSTE/models

# clone the git repository or pull the latest version
pull() {
    if [[ -d kohya_ss ]]; then 
        cd kohya_ss/
        git pull
        cd ..
    else
        git clone --depth=1 git@github.com:bmaltais/kohya_ss.git
    fi
}

# rebuild the docker image
build() {
    export BUILDKIT_PROGRESS=plain && docker build -t $CNAME -f Dockerfile .
}

run() {
    docker run -it --gpus all \
        -v $HOSTC:/home/user/.cache/ \
        -v $HOSTD/venv/:/home/user/app/venv/ \
        -v $HOSTD/data/:/home/user/app/data/ \
        -v $HOSTE/models/:/home/user/app/models/ \
        -p 8889:7860 \
        $CNAME "$@"
}

# attach to the running container
attach() {
    # parse the id first
    cid=$(docker ps -aqf "name=$CNAME")
    docker exec -it $cid /bin/bash
}

"$@"
