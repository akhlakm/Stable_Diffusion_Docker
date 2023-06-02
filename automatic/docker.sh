#!/usr/bin/env bash

CNAME=sdiff

HOSTC=/home/work/_cache
HOSTD=/home/data/stable_diffusion/automatic

WORKD=./app

mkdir -p $HOSTD/venv
mkdir -p $HOSTD/models
mkdir -p $HOSTD/outputs
mkdir -p $HOSTD/extensions
mkdir -p $HOSTD/repositories

build() {
    export BUILDKIT_PROGRESS=plain && docker build -t $CNAME -f Dockerfile .
}

run() {
    docker run -it --gpus all \
        -v $WORKD/:/home/user/app/ \
        -v $HOSTC:/home/user/.cache/ \
        -v $HOSTD/venv/:/home/user/venv/ \
        -v $HOSTD/models/:/home/user/app/models/ \
        -v $HOSTD/outputs/:/home/user/app/outputs/ \
        -v $HOSTD/extensions/:/home/user/app/extensions/ \
        -v $HOSTD/repositories/:/home/user/app/repositories/ \
        -p 8888:7860 \
        $CNAME "$@"
}

# clone the git repository or pull the latest version
pull() {
    if [[ -d app ]]; then 
        cd app/
        git pull
        cd ..
    else
        git clone --depth=1 https://github.com/AUTOMATIC1111/stable-diffusion-webui.git app
    fi
}

"$@"
