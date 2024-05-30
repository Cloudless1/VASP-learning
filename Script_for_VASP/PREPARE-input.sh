#!/bin/bash

# ����Ŀ��·��

directory=$(pwd)

# �л�����·��
cd "$directory" || exit

# ������ļ�
for file in "POSCAR"*.txt; do
    # ��ȡ�ļ���
    filename=$(basename -- "$file")
    # ��ȡ��һ������
    first_line=$(head -n 1 "$file")

    # ȥ����һ���������
    folder_name=$(echo "$first_line" | awk 'BEGIN{FS=OFS=" "} {sub(/.$/,"",$NF)}1' | tr ' ' '_' | sed 's/_$//')

    echo "file: $file"
    echo "folder_name: $folder_name"

    # �ƶ��ļ���Ӧ���ļ���
    if [[ -n "$folder_name" ]]; then
        mkdir -p "$folder_name"
        mv "$file" "$folder_name/$filename"
        #prepare INCAR
        cp /data/home/lizhenhua/data/yjr/all_scripts/other_scripts/INCAR  "$folder_name/INCAR"  -r
        #prepare KPOINTS
        cp /data/home/lizhenhua/data/yjr/all_scripts/other_scripts/KPOINTS "$folder_name/KPOINTS"  -r
        #prepare POSCAR
        mv "$folder_name/$filename" "$folder_name/POSCAR"
        #modify the parameters SYSTEM in INCAR
        sed -i "1c  SYSTEM=$folder_name" "$folder_name/INCAR"
        #prepare submit scripts
        cp /data/home/lizhenhua/data/yjr/all_scripts/submit_scripts/vasp/sub_vasp56.sh "$folder_name/sub_vasp56.sh"  -r
        #prepare POTCAR
        cd  "$folder_name"
        echo -e "103" | vaspkit   > POTCAR.log
        cd ../
    fi
done

cp /data/home/lizhenhua/data/yjr/all_scripts/other_scripts/sub-vasp+.sh "$directory/sub-vasp+.sh"  -r
ls *