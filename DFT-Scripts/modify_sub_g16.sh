#!/bin/bash

# 获取当前路径
current_path=$(pwd)

# 遍历每个文件夹
for folder in $current_path/*; do
  # 判断是否为文件夹
  if [[ -d $folder ]]; then
    # 进入文件夹
    cd "$folder"
    
    # 获取gjf文件名
    gjf_file=$(ls *.gjf)
    gjf_filename="${gjf_file%.*}"
    
    # 修改sub-g16.sh文件的第二行
    sed -i "2s/#SBATCH -J .*/#SBATCH -J $gjf_filename/" sub-g16.sh
    
    # 返回上级目录
    cd ..
  fi
done