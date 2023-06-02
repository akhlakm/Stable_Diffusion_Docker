#!/bin/bash

appinstall() {
    pip install -vv torch==2.0.1 torchvision==0.15.2 --extra-index-url https://download.pytorch.org/whl/cu118
    pip install -vv xformers
    pip install -vv -r requirements.txt
    accelerate config
}

# Setup runtime environment
if [ ! -f venv/bin/activate ]; then
    python -m venv venv || exit 101
    source venv/bin/activate || exit 100
else
    source venv/bin/activate || exit 100
fi

export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/cuda/lib64:/usr/lib/x86_64-linux-gnu/"

exec "$@"
/bin/bash -i
