#!/bin/bash

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

source_dir="/workspace/MyGoogleDrive/models/ipadapter"
target_dir="/workspace/ComfyUI/custom_nodes/ComfyUI_IPAdapter_plus/models"

create_symlinks "$source_dir" "$target_dir"



