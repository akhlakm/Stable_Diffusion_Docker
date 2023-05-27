#!/bin/bash

# Setup runtime environment
if [ ! -f venv/bin/activate ]; then
    python -m venv venv || exit 101
    source venv/bin/activate || exit 100
    # rerun this if broken dependecies after update
    pip install --use-pep517 -r requirements.txt xformers
else
    source venv/bin/activate || exit 100
fi

export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/cuda/lib64:/usr/lib/x86_64-linux-gnu/"

exec "$@"
python kohya_gui.py --listen 0.0.0.0 --server_port 7860
