#!/bin/bash
#this scripts is used to generate the input files containing INCAR KPOINTS POSCAR POTCAR sub-vasp.sh to performate the single point energy with the constant-potential calculation 

# Step1 transfer CONTCAR to POSCAR
mv CONTCAR POSCAR
echo  "convert CONTCAR to POSCAR"

# Step2 prepare sub_vasp56.sh
cp /home/yangjiangrong/YangJiangRong/Other-Scripts/sub_vasp5.sh sub_vasp5.sh
echo  "sub_vash5.sh is copied successfully"

# Step3 Create folder and Prepare calculation files
for i in $(seq 0.1 0.1 1.5); do
    file=INCAR
    line=$(sed -n '47p' "$file")
    NELECT_Net_charge=$(echo "$line" | cut -d '=' -f 2 | awk '{print $1}')
    NELECT_Accutral_charge=$(echo "$NELECT_Net_charge - $i" | bc)
    mkdir "m$i"
    cp CHGCAR INCAR KPOINTS POSCAR POTCAR sub_vasp5.sh "m$i"/
    sed -i "47c     NELECT=$NELECT_Accutral_charge   # Number of valence electrons " "m$i/INCAR"
    NELECT_Accutral_charge=$(echo "$NELECT_Net_charge + $i" | bc)
    mkdir "p$i"
    cp CHGCAR INCAR KPOINTS POSCAR POTCAR sub_vasp5.sh "p$i"/
    sed -i "47c     NELECT=$NELECT_Accutral_charge   # Number of valence electrons " "p$i/INCAR"
done
mkdir "0.0" && cp CHGCAR INCAR KPOINTS POSCAR POTCAR sub_vasp5.sh "0.0"/
ls -l
echo  "from m1.5 to p1.5, all directories are created successfully"

cp /home/yangjiangrong/YangJiangRong/Other-Scripts/sub-vasp+.sh sub-vasp+.sh
