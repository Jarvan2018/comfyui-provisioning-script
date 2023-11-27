#!/bin/false

# This file will be sourced in init.sh

# https://raw.githubusercontent.com/ai-dock/comfyui/main/config/provisioning/get-models-sd-official.sh
printf "\n##############################################\n#                                            #\n#          Provisioning container            #\n#                                            #\n#         This will take some time           #\n#                                            #\n# Your container will be ready on completion #\n#                                            #\n##############################################\n\n"
function download() {
    wget -q --show-progress -e dotbytes="${3:-4M}" -O "$2" "$1"
}
# Download Stable Diffusion official models

models_dir=/opt/ComfyUI/models
checkpoints_dir=${models_dir}/checkpoints
vae_dir=${models_dir}/vae
loras_dir=${models_dir}/loras
upscale_dir=${models_dir}/upscale_models



# svd_xt.safetensors
model_file=${checkpoints_dir}/svd_xt.safetensors
model_url=https://huggingface.co/stabilityai/stable-video-diffusion-img2vid-xt/resolve/main/svd_xt.safetensors

if [[ ! -e ${model_file} ]]; then
    printf "Downloading svd_xt ...\n"
    download ${model_url} ${model_file}
fi


# svd.safetensors
model_file=${checkpoints_dir}/svd.safetensors
model_url=https://huggingface.co/stabilityai/stable-video-diffusion-img2vid/resolve/main/svd.safetensors

if [[ ! -e ${model_file} ]]; then
    printf "Downloading svd ...\n"
    download ${model_url} ${model_file}
fi

