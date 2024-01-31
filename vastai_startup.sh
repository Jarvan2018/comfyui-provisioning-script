#!/bin/bash  

# ComfyUI路径
COMFYUI_DIR=/workspace/ComfyUI

if [ -d "$COMFYUI_DIR" ]; then  
    echo "Comfyui exists. Exiting."  
    exit 0  
else
    touch ~/.no_auto_tmux
    curl -sSL https://raw.githubusercontent.com/Jarvan2018/comfyui-provisioning-script/main/vastai_comfyui_initialization.sh | bash
fi






