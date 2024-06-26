#!/bin/bash
# Please prepare the input files for the VASP calculation task, INCAR, KPOINTS, sub_vasp56.sh (which is Submit script), sub-vasp+.sh (which is Batch submit scripts)
# Set target path

directory=$(pwd)

# Switch to target path
cd "$directory" || exit

# handle each files
for file in "POSCAR"*.txt; do
    # Read file name
    filename=$(basename -- "$file")
    # Read the first line of content
    first_line=$(head -n 1 "$file")

    # Remove the last special symbol
    folder_name=$(echo "$first_line" | awk 'BEGIN{FS=OFS=" "} {sub(/.$/,"",$NF)}1' | tr ' ' '_' | sed 's/_$//')

    echo "file: $file"
    echo "folder_name: $folder_name"

    # Copy input files to the corresponding folder
    if [[ -n "$folder_name" ]]; then
        mkdir -p "$folder_name"
        mv "$file" "$folder_name/$filename"
        #prepare INCAR
        cp /data/home/lizhenhua/data/yjr/all_scripts/other_scripts/INCAR  "$folder_name/INCAR"  -r    # please input the path of INCAR 
        #prepare KPOINTS
        cp /data/home/lizhenhua/data/yjr/all_scripts/other_scripts/KPOINTS "$folder_name/KPOINTS"  -r    # please input the path of KPOINTS
        #prepare POSCAR
        mv "$folder_name/$filename" "$folder_name/POSCAR"
        #modify the parameters SYSTEM in INCAR
        sed -i "1c  SYSTEM=$folder_name" "$folder_name/INCAR"
        #prepare submit scripts
        cp /data/home/lizhenhua/data/yjr/all_scripts/submit_scripts/vasp/sub_vasp56.sh "$folder_name/sub_vasp56.sh"  -r     # please input the path of sub_vasp56.sh
        #prepare POTCAR
        cd  "$folder_name"
        echo -e "103" | vaspkit   > POTCAR.log
        cd ../
    fi
done

cp /data/home/lizhenhua/data/yjr/all_scripts/other_scripts/sub-vasp+.sh "$directory/sub-vasp+.sh"  -r  # please input the path of sub-vasp+.sh
ls *
