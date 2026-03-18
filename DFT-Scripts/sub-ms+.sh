#!/bin/bash
for folder in *; do
    #判断是否是文件夹
	if [[  -d $folder ]]; then
	   #进入文件夹
	   cd "$folder"
	   
	   sbatch sub-YJR.sh
	   
	   #返回上级目录
	   cd ..
	fi
done