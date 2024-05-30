#!/bin/bash

# ����Ŀ��·��
directory=$(pwd)

# �л�����·��
cd "$directory" || exit

# ����ÿ���ļ���
for folder in *; do
    if [[ -d "$folder" ]]; then
        # ��ȡ�µ��ļ�������
        new_folder_name=$(echo "$folder" | sed 's/ CASTEP Energy$//')
        
        # ��� PhonDOS ��׺
        new_folder_name_PhonDOS="${new_folder_name}_PhonDOS"
        
        # �ƶ��ļ��в�������
        mv "$folder" "$new_folder_name"
        
        # ׼���ύ�ű�
        cp /data/home/lizhenhua/data/yjr/all_scripts/submit_scripts/MS2020/sub-ms.sh "$new_folder_name/sub-ms.sh" -r
        
        # ���ύ�ű������ò���
        sed -i "11c #inputfile=" "$new_folder_name/sub-ms.sh"
        sed -i "12c RunCASTEP.sh -extraoptions KeepCheckFiles:Yes -np \$SLURM_NTASKS $new_folder_name $new_folder_name_PhonDOS &> output.log 2>&1" "$new_folder_name/sub-ms.sh"
    fi
done

cp /data/home/lizhenhua/data/yjr/all_scripts/other_scripts/sub-ms+.sh "$directory/sub-ms+.sh"  -r
ls *
