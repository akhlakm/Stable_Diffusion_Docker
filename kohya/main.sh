#!/usr/bin/env bash

CNAME=kohya

HOSTC=/home/hdd/_cache
HOSTD=/home/hdd/stable-diffusion/kohya
HOSTE=/home/hdd/stable-diffusion/automatic

mkdir -p $HOSTD/venv
mkdir -p $HOSTD/data

# this should be the models directory of the webui
# so we can reuse the downloaded models
mkdir -p $HOSTE/models

pull() {
    if [[ -d kohya_ss ]]; then 
        cd kohya_ss/
        git pull
        cd ..
    else
        git clone --depth=1 git@github.com:bmaltais/kohya_ss.git
    fi
}

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

attach() {
    docker exec -it $CNAME /bin/bash
}

"$@"
