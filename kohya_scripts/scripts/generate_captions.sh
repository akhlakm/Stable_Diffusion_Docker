#!/bin/bash

Workdir=data/finger

python finetune/make_captions.py $Workdir/img/ --recursive --max_length 225 --debug --caption_extension .txt

# python finetune/merge_captions_to_metadata.py --full_path $Workdir/img/ --recursive $Workdir/dataset.json --debug

# python finetune/clean_captions_and_tags.py $Workdir/dataset.json $Workdir/dataset.json --debug

