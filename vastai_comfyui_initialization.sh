#!/bin/bash

# 测试 不会用tmux先关闭
# touch ~/.no_auto_tmux

## colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # default color

echo -e "${GREEN}欢迎使用Vast.AI ComfyUI 预处理脚本${NC}"
echo -e "${GREEN}Welcome to use Vast.AI ComfyUI preprocessing script${NC}"

echo -e "${GREEN}===========================\n${NC}"
echo "将自动安装一些custom_nodes和他们的依赖"
echo "Will automatically install some custom_nodes and their dependencies"
echo -e "${GREEN}===========================\n${NC}"





## 路径
WORKSPACE=/workspace
COMFYUI_DIR=${WORKSPACE}/ComfyUI
COMFYUI_ENV_NAME=my_comfyui_env
COMFYUI_ENV_DIR=${WORKSPACE}/${COMFYUI_ENV_NAME}
DRIVE_DIR_NAME=MyGoogleDrive
DRIVE_DIR=${WORKSPACE}/${DRIVE_DIR_NAME}

# Download jupyter file for Run ComfyUI
wget -P ${WORKSPACE} https://raw.githubusercontent.com/Jarvan2018/comfyui-provisioning-script/main/fast_comfyUI.ipynb

# 为Google Drive 创建文件夹
cd ${WORKSPACE}
mkdir ${DRIVE_DIR_NAME}

# 安装ComfyUI
cd ${WORKSPACE}
git clone https://github.com/comfyanonymous/ComfyUI
wget -P ${COMFYUI_DIR} https://raw.githubusercontent.com/Jarvan2018/comfyui-provisioning-script/main/extra_model_paths.yaml

## ComfyUI-Manager
cd ComfyUI/custom_nodes
git clone https://github.com/ltdrdata/ComfyUI-Manager

# 创建虚拟环境安装依赖
cd ${WORKSPACE}
python -m venv ${COMFYUI_ENV_NAME} --prompt ComfyUI
source ${COMFYUI_ENV_DIR}/bin/activate
cd ComfyUI

python -m pip install -r requirements.txt
python -m pip install -r custom_nodes/ComfyUI-Manager/requirements.txt
python -m pip install torchvision



NODES=(
    "https://github.com/11cafe/comfyui-workspace-manager"
    "https://github.com/cubiq/ComfyUI_IPAdapter_plus"
    "https://github.com/Kosinkadink/ComfyUI-AnimateDiff-Evolved"
    "https://github.com/FizzleDorf/ComfyUI_FizzNodes"
    "https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet"
    "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite"
    "https://github.com/Fannovel16/comfyui_controlnet_aux"
    "https://github.com/ltdrdata/ComfyUI-Impact-Pack"
    "https://github.com/ZHO-ZHO-ZHO/sdxl_prompt_styler-Zh-Chinese"
    "https://github.com/pythongosssss/ComfyUI-WD14-Tagger"
    "https://github.com/spacepxl/ComfyUI-RAVE"
    "https://github.com/BlenderNeko/ComfyUI_Noise"
    "https://github.com/Stability-AI/stability-ComfyUI-nodes"
    "https://github.com/WASasquatch/was-node-suite-comfyui"
    "https://github.com/rgthree/rgthree-comfy"
    "https://github.com/chrisgoringe/cg-use-everywhere"
    "https://github.com/kijai/ComfyUI-KJNodes"
    "https://github.com/cubiq/ComfyUI_essentials"
    "https://github.com/BlenderNeko/ComfyUI_ADV_CLIP_emb"
    "https://github.com/Fannovel16/ComfyUI-Frame-Interpolation"
    "https://github.com/tinyterra/ComfyUI_tinyterraNodes"
    "https://github.com/Derfuu/Derfuu_ComfyUI_ModdedNodes"
    "https://github.com/melMass/comfy_mtb"
    "https://github.com/theUpsider/ComfyUI-Logic"
    "https://github.com/Ttl/ComfyUi_NNLatentUpscale"
    "https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes"
    "https://github.com/Fannovel16/ComfyUI-Video-Matting"
)


function provisioning_get_nodes() {
    for repo in "${NODES[@]}"; do
        dir="${repo##*/}"
        path="${COMFYUI_DIR}/custom_nodes/${dir}"
        requirements="${path}/requirements.txt"
        if [[ -d $path ]]; then
            printf "Updating node: %s...\n" "${repo}"
            ( cd "$path" && git pull )
            if [[ -e $requirements ]]; then
                pip install -r "$requirements"
            fi
        else
            printf "Downloading node: %s...\n" "${repo}"
            git clone "${repo}" "${path}" --recursive
            if [[ -e $requirements ]]; then
                pip install -r "${requirements}"
            fi
        fi
    done
}

provisioning_get_nodes

echo -e "\n${GREEN}Install Done!${NC}"

#特殊情况切换到ComfyUI-AnimateDiff-Evolved  develop 分支
cd ${COMFYUI_DIR}/custom_nodes/ComfyUI-AnimateDiff-Evolved
git checkout develop

echo -e "\n${GREEN}success Swith ComfyUI-AnimateDiff-Evolved to develop branch !${NC}"

echo -e "\n${GREEN}Here we go, traveler!!${NC}"