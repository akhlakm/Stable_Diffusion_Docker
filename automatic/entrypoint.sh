#!/bin/bash

# Setup runtime environment
if [ -f venv/bin/activate ]; then
    source venv/bin/activate || exit 101
else
    python3 -m venv venv || exit 102
    source venv/bin/activate || exit 103
fi

exec "$@"
# bash webui.sh --listen --enable-insecure-extension-access --xformers --no-half
python webui.py --listen --enable-insecure-extension-access --xformers --no-half
