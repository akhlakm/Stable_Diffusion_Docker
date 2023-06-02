#!/bin/bash
args=()

Name=finger0.1          # Name of the lora file
Workdir=data/finger     # working directory

Script=train_network.py
Model=../models/Stable-diffusion/v1-5-pruned-emaonly.safetensors
Outdir=../models/Lora      # lora save directory, should be in web ui

args+=(--pretrained_model_name_or_path $Model)
args+=(--train_data_dir $Workdir/img)
args+=(--output_dir $Outdir --output_name $Name)

# args+=(--resume $Outdir/$Name-state)      # uncomment to resume from the last run

args+=(--dataset_repeats 2)
args+=(--train_batch_size 2)

args+=(--max_train_epochs 1)
# args+=(--max_train_steps 300)

args+=(--max_token_length 150)
args+=(--tokenizer_cache_dir /tmp/tokens)

# args+=(--keep_tokens 5)
args+=(--shuffle_caption)
args+=(--caption_extension .txt)
args+=(--caption_dropout_rate 0.0)

args+=(--cache_latents)
# args+=(--random_crop)
args+=(--flip_aug)
args+=(--face_crop_aug_range "0.2,0.8")

args+=(--resolution "512,512")
args+=(--enable_bucket)
args+=(--bucket_reso_steps 64)

# args+=(--min_bucket_reso 320)
# args+=(--max_bucket_reso 512)
args+=(--bucket_no_upscale)

# args+=(--no_metadata)
args+=(--save_precision fp16)
args+=(--training_comment $Name)
args+=(--save_model_as safetensors)

args+=(--save_every_n_epochs 1)

# args+=(--save_every_n_steps SAVE_EVERY_N_STEPS)
# args+=(--save_n_epoch_ratio SAVE_N_EPOCH_RATIO)

args+=(--save_last_n_epochs 1)
args+=(--save_last_n_epochs_state 1)

# args+=(--save_last_n_steps SAVE_LAST_N_STEPS)
# args+=(--save_last_n_steps_state SAVE_LAST_N_STEPS_STATE)

# args+=(--network_weights NETWORK_WEIGHTS)
# args+=(--dim_from_weights)
args+=(--save_state)


args+=(--max_data_loader_n_workers 4)
args+=(--persistent_data_loader_workers)

# args+=(--sample_every_n_epochs 1)
args+=(--sample_every_n_steps 50)
args+=(--sample_prompts ../scripts/sample_prompt.txt)
args+=(--sample_sampler euler)

args+=(--unet_lr 1e-4)
args+=(--learning_rate 1e-4)
args+=(--text_encoder_lr 1e-4)

args+=(--lr_scheduler cosine)
args+=(--lr_warmup_steps 10)
args+=(--lr_scheduler_num_cycles 50)

args+=(--optimizer_type AdamW)
# args+=(--optimizer_type AdamW8bit)
# args+=(--max_grad_norm MAX_GRAD_NORM)

args+=(--mixed_precision bf16)
args+=(--clip_skip 2)
args+=(--xformers)

args+=(--gradient_checkpointing)
args+=(--gradient_accumulation_steps 5)

args+=(--network_module networks.lora)      # type of lora, the python package
args+=(--network_dim 256)
args+=(--network_alpha 256)

# args+=(--debug_dataset)                     # uncomment to see captions setup

# run
echo
echo "Command Args:"
echo "accelerate launch --num_cpu_threads_per_process 4 $Script ${args[@]}"
accelerate launch --num_cpu_threads_per_process 4 $Script "${args[@]}" | tee ../scripts/last-run.log
