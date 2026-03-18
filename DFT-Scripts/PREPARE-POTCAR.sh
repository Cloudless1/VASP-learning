#!/bin/bash
for folder in *; do 
    if [[ -d $folder ]]; then
        cd "$folder"
        (echo 103) | vaspkit > POTCAR.log
        cd ..
    fi
done