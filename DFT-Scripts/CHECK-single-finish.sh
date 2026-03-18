#!/bin/bash
#this scripts is used to check the single point energy whether or not complete


for folder in *; do
    if [[  -d "$folder" ]]; then
        cd "$folder"
        incar_filename="INCAR"
        algo_line=$(grep -i -m 1 'ALGO' "$incar_filename")
        if [[ -z "$algo_line" ]]; then
            echo "ALGO not find in $folder"
        else
            algo_value=$(echo "$algo_line" | cut -d'=' -f2 | xargs | tr -d "\r")
            oszicar_filename="OSZICAR"
            if [[ "$algo_value" == "Fast" ]]; then
                echo "$folder"
                grep 'RMM'  "$oszicar_filename" | tail -1
            elif [[ "$algo_value" == "Normal" ]]; then
                echo "$folder"
                grep 'DAV'  "$oszicar_filename" | tail -1
            else
                echo "ALGO is not Fast or Normal in $folder"
            fi
        fi
        cd ../
    fi
done
