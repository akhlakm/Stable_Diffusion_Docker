#!/bin/bash

# Setup runtime environment

if [ ! -f venv/bin/activate ]; then
    echo "Setting up VENV ..."
    python3 -m venv venv || exit 101
fi

source venv/bin/activate || exit 102
cd /home/user/app

exec "$@"
bash webui.sh --listen --enable-insecure-extension-access --xformers --no-half
# python webui.py --listen --enable-insecure-extension-access --xformers --no-half
