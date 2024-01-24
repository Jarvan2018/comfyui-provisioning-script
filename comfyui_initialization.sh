#!/bin/bash

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

pip install --upgrade pip

# 安装 gdown
pip install gdown


## 路径
WORKSPACE=/workspace
COMFYUI_DIR=${WORKSPACE}/ComfyUI
COMFYUI_ENV_NAME=my_comfyui_env
COMFYUI_ENV_DIR=${WORKSPACE}/${COMFYUI_ENV_NAME}
DRIVE_DIR_NAME=MyGoogleDrive
DRIVE_DIR=${WORKSPACE}/${DRIVE_DIR_NAME}


# 获取脚本的路径
CURRENT_DIR=$(dirname "$0")

# 安装ComfyUI
cd ${WORKSPACE}
git clone https://github.com/comfyanonymous/ComfyUI


# 配置
mkdir ${DRIVE_DIR_NAME}
cd "$CURRENT_DIR"
# cp extra_model_paths.yaml ${COMFYUI_DIR}
wget -P ${COMFYUI_DIR} https://raw.githubusercontent.com/Jarvan2018/comfyui-provisioning-script/main/extra_model_paths.yaml

# 创建虚拟环境安装依赖
cd ${WORKSPACE}
python -m venv ${COMFYUI_ENV_NAME} --prompt ComfyUI
source ${COMFYUI_ENV_DIR}/bin/activate
cd ComfyUI
pip install xformers!=0.0.18 -r requirements.txt --extra-index-url https://download.pytorch.org/whl/cu121 --extra-index-url https://download.pytorch.org/whl/cu118 --extra-index-url https://download.pytorch.org/whl/cu117


# 可能需要安装 很多都依赖 
sudo apt-get update
sudo apt-get install -y libgl1-mesa-glx
pip install numba
pip install opencv-python




NODES=(
    "https://github.com/ltdrdata/ComfyUI-Manager"
    "https://github.com/11cafe/comfyui-workspace-manager"
    "https://github.com/cubiq/ComfyUI_IPAdapter_plus"
    "https://github.com/Kosinkadink/ComfyUI-AnimateDiff-Evolved"
    "https://github.com/FizzleDorf/ComfyUI_FizzNodes"
    "https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet"
    "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite"
    "https://github.com/Fannovel16/comfyui_controlnet_aux"
    "https://github.com/ltdrdata/ComfyUI-Impact-Pack"
    "https://github.com/twri/sdxl_prompt_styler"
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


#使用gdown下载大文件
gdown https://drive.google.com/drive/folders/1NQ_xIPqinODkddr6Qq2hClYgcTbK7sIk -O ${DRIVE_DIR} --folder



create_symlinks() {
    source_dir="$1"
    target_dir="$2"

    for file in "$source_dir"/*; do
        file_name=$(basename "$file")
        source_path="$source_dir/$file_name"
        target_path="$target_dir/$file_name"
        echo "Will create symlink: $target_path -> $source_path"
        ln -s "$source_path" "$target_path"
        echo "Created symlink: $target_path -> $source_path"
    done
}

# 创建大文件的符号链接
source_dir="/workspace/MyGoogleDrive/animatediff"
target_dir="/workspace/ComfyUI/custom_nodes/ComfyUI-AnimateDiff-Evolved/models"

create_symlinks "$source_dir" "$target_dir"

source_dir = '/workspace/MyGoogleDrive/models/ipadapter'
target_dir = '/workspace/ComfyUI/custom_nodes/ComfyUI_IPAdapter_plus/models'

create_symlinks "$source_dir" "$target_dir"