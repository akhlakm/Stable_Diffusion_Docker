#!/bin/bash
args=()

Name=violet2.1
Workdir=data/violet

Lora=models/Lora/$Name.safetensors
Model=models/Stable-diffusion/v1-5-pruned-emaonly.safetensors

args+=(--ckpt $Model)
args+=(--outdir $Workdir)
args+=(--network_weights $Lora)

args+=(--W 512 --H 768)
args+=(--scale 8)

args+=(--sampler k_euler_a)


args+=(--clip_skip 2)
args+=(--network_module networks.lora)
args+=(--max_embeddings_multiples 1)

args+=(--batch_size 4)
args+=(--images_per_prompt 8)

args+=(--xformers)

# args+=(--interactive)
args+=(--from_file ../scripts/prompt.txt)

python gen_img_diffusers.py "${args[@]}"
