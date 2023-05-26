#!/usr/bin/env bash

CNAME=sdiff

HOSTC=/home/hdd/_cache
HOSTD=/home/hdd/stable-diffusion/automatic

mkdir -p $HOSTD/venv
mkdir -p $HOSTD/models
mkdir -p $HOSTD/extensions
mkdir -p $HOSTD/repositories


build() {
    export BUILDKIT_PROGRESS=plain && docker build -t $CNAME -f Dockerfile .
}

run() {
    docker run -it --gpus all \
        -v $HOSTC:/home/user/.cache/ \
        -v $HOSTD/venv/:/home/user/app/venv/ \
        -v $HOSTD/models/:/home/user/app/models/ \
        -v $HOSTD/extensions/:/home/user/app/extensions/ \
        -v $HOSTD/repositories/:/home/user/app/repositories/ \
        -p 8888:7860 \
        $CNAME "$@"
}

"$@"
