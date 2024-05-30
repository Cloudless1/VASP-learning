#!/bin/bash

# 设置目标路径
directory=$(pwd)

# 切换到标路径
cd "$directory" || exit

# 处理每个文件夹
for folder in *; do
    if [[ -d "$folder" ]]; then
        # 提取新的文件夹名称
        new_folder_name=$(echo "$folder" | sed 's/ CASTEP Energy$//')
        
        # 添加 PhonDOS 后缀
        new_folder_name_PhonDOS="${new_folder_name}_PhonDOS"
        
        # 移动文件夹并重命名
        mv "$folder" "$new_folder_name"
        
        # 准备提交脚本
        cp /data/home/lizhenhua/data/yjr/all_scripts/submit_scripts/MS2020/sub-ms.sh "$new_folder_name/sub-ms.sh" -r
        
        # 在提交脚本中设置参数
        sed -i "11c #inputfile=" "$new_folder_name/sub-ms.sh"
        sed -i "12c RunCASTEP.sh -extraoptions KeepCheckFiles:Yes -np \$SLURM_NTASKS $new_folder_name $new_folder_name_PhonDOS &> output.log 2>&1" "$new_folder_name/sub-ms.sh"
    fi
done

cp /data/home/lizhenhua/data/yjr/all_scripts/other_scripts/sub-ms+.sh "$directory/sub-ms+.sh"  -r
ls *
