#!/bin/bash
#this scripts is used to calculate the thermal corrections for adsorbate and molecule
for folder in *; do
    #判断是否是文件夹
	if [[  -d $folder ]]; then
	   #进入文件夹
	   cd "$folder"
	   
	  (echo 501;echo 298.15) | vaspkit   > deltaG
          #(echo 502;echo 298.15;echo 1;echo 1;) | vaspkit   > deltaG
	   grep  'Thermal correction to G(T)' deltaG
	   #返回上级目录
	   cd ..
	fi
done