#!/bin/bash

export pipi="pip install --no-clean"

appinstall() {
    $pipi torch==2.0.1 torchvision==0.15.2 --extra-index-url https://download.pytorch.org/whl/cu118
    $pipi xformers
    $pipi -r requirements.txt
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
# python kohya_gui.py --listen 0.0.0.0 --server_port 7860
