#!/bin/bash
# this scriptis is used to prepare the sub_vasp28.sh for every folder

# Script path
script_directory=/data/home/yangjiangrongbuct/Data/Yangjiangrong-scripts/Other-scripts

for i in *; do cp "$script_directory/sub_vasp5.sh" $i/ ; done

directory=$(pwd)

cp "$script_directory/sub-vasp+.sh" "$directory/sub-vasp+.sh"  -r

chmod +777 sub-vasp+.sh
ls *
