#!/bin/bash
for folder in *; do
	if [[  -d $folder ]]; then
	   cd "$folder"
	   sbatch sub_vasp5.sh
	   cd ..
	fi
done