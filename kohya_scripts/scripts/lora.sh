#!/bin/bash
args=()

Name=violet2.1
Workdir=data/violet

Script=train_network.py
Model=models/Stable-diffusion/v1-5-pruned-emaonly.safetensors
Outdir=models/Lora

args+=(--pretrained_model_name_or_path $Model)
args+=(--train_data_dir $Workdir/img)

args+=(--dataset_repeats 2)
args+=(--train_batch_size 2)

args+=(--max_train_epochs 1)
# args+=(--max_train_steps 300)

args+=(--max_token_length 225)

# args+=(--tokenizer_cache_dir TOKENIZER_CACHE_DIR)

args+=(--keep_tokens 5)
args+=(--shuffle_caption)
args+=(--caption_extension .txt)
args+=(--caption_dropout_rate 0.04)

args+=(--cache_latents)
# args+=(--flip_aug --random_crop)
# args+=(--face_crop_aug_range FACE_CROP_AUG_RANGE)

args+=(--resolution "512,512")
args+=(--enable_bucket)
args+=(--bucket_reso_steps 64)

# args+=(--min_bucket_reso 320)
# args+=(--max_bucket_reso 512)
args+=(--bucket_no_upscale)


args+=(--output_dir $Outdir --output_name $Name)
args+=(--save_model_as safetensors)

args+=(--save_precision fp16)
args+=(--save_every_n_epochs 1)

# args+=(--save_every_n_steps SAVE_EVERY_N_STEPS)
# args+=(--save_n_epoch_ratio SAVE_N_EPOCH_RATIO)

args+=(--save_last_n_epochs 1)
args+=(--save_last_n_epochs_state 1)

# args+=(--save_last_n_steps SAVE_LAST_N_STEPS)
# args+=(--save_last_n_steps_state SAVE_LAST_N_STEPS_STATE)

args+=(--save_state)
# args+=(--resume RESUME)

args+=(--xformers)


args+=(--max_data_loader_n_workers 4)

args+=(--persistent_data_loader_workers)

args+=(--gradient_checkpointing)
# args+=(--gradient_accumulation_steps 2)

args+=(--mixed_precision bf16)

# args+=(--clip_skip CLIP_SKIP)

# args+=(--sample_every_n_epochs 1)
args+=(--sample_every_n_steps 100)
args+=(--sample_prompts ../scripts/sample_prompt.txt)
args+=(--sample_sampler euler)

# args+=(--config_file $Workdir/config.toml --output_config)

args+=(--learning_rate 1e-5)
args+=(--unet_lr 1e-5)
args+=(--text_encoder_lr 1e-5)

args+=(--lr_scheduler cosine)
args+=(--lr_warmup_steps 100)
args+=(--lr_scheduler_num_cycles 3)

args+=(--optimizer_type AdamW8bit)
# args+=(--max_grad_norm MAX_GRAD_NORM)

# args+=(--dataset_config $Workdir/dataset.json)
# args+=(--no_metadata)

# args+=(--network_weights NETWORK_WEIGHTS)
args+=(--network_module networks.lora)
# args+=(--dim_from_weights)

args+=(--network_dim 32)
args+=(--network_alpha 32)

# args+=(--network_train_unet_only)
# args+=(--network_train_text_encoder_only)

args+=(--training_comment $Name)
# args+=(--debug_dataset)

# run
echo
echo "Command Args:"
echo "accelerate launch --num_cpu_threads_per_process 4 $Script ${args[@]}"
accelerate launch --num_cpu_threads_per_process 4 $Script "${args[@]}" | tee ../scripts/last-run.log
