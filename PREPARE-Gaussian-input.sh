#!/bin/bash

current_directory=$(pwd)
echo "current directory is $current_directory"

parent_directory=$(dirname "$current_directory")
New_folder_directory="$parent_directory/1-2-SP"
mkdir -p "$New_folder_directory"
echo "New folder created successfully!"

# 遍历A文件夹下的文件 并创建新的文件夹和复制gjf文件
for file in "$current_directory"/*; do
    # 获取文件名
    filename=$(basename "$file")
    # 获取对应的文件夹名
    foldername="${filename%.*}"
    # 创建对应的文件夹
    mkdir "$New_folder_directory/$foldername"
    # 复制文件到对应的文件夹
    cp "$file" "$New_folder_directory/$foldername"
done

# 遍历B文件夹下的文件夹并修改gjf文件chk输出路径以及关键词
for folder in "$New_folder_directory"/*; do
    # 遍历文件夹内的gjf文件
    for gjf_file in "$folder"/*.gjf; do
        # 获取文件名
        filename=$(basename "$gjf_file")
        # 修改第一行
        sed -i "1s~.*~%chk=$(realpath "$gjf_file" | sed 's|_|/|g' | sed 's|\.gjf$|.chk|')~" "$gjf_file"
        # 修改第二行
        sed -i "2s|.*|#P  B2PLYPD3/def2TZVP    |" "$gjf_file"
    done
done

# 准备提交脚本
for folder in "$New_folder_directory"/*; do
cp  /data/home/lizhenhua/data/yjr/all_scripts/other_scripts/sub-YJR-g.sh $folder -r
done

# 修改提交脚本提交参数
for folder in "$New_folder_directory"/*; do
  # 判断是否为文件夹
  if [[ -d $folder ]]; then
    # 进入文件夹
    cd "$folder"
    
    # 获取gjf文件名
    gjf_file=$(ls *.gjf)
    gjf_filename="${gjf_file%.*}"
    
    # 修改sub-g16.sh文件的第二行
    sed -i "2s/#SBATCH -J .*/#SBATCH -J $gjf_filename/" sub-YJR-g.sh
    
    # 返回上级目录
    cd ..
  fi
done

# 检查chk输出设置以及关键词，提交脚本设置
for folder in "$New_folder_directory"/*; do
head -n 2 $folder/*.gjf
grep 'SBATCH -J'  $folder/sub-YJR-g.sh | head -n -1
done

cp /data/home/lizhenhua/data/yjr/all_scripts/other_scripts/sub-g16+.sh "$New_folder_directory/sub-g16+.sh"  -r
ls *