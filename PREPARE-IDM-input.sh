#!/bin/bash

# This script is used to creat all files for IDM calculation to optimize structure  of the transition state.
# Before runing this script, you need to complete the frequency calculation of the initial guess structure of the transition state.

#Set target path
directory=$(pwd)
echo "Current directory is $directory"

#Switch to target path
cd "$directory" || exit

# Check frequency calculation results and whether the imaginary frequency is included.
echo "-------------------------------------------------------------------------"
echo "Step1 Check frequency calculation results and whether the imaginary frequency is included."
if ! grep -q "f/i" OUTCAR; then
    echo "The lines with f/i is not included in OUTCAR."
    exit 1
fi

grep f/i OUTCAR

# Creat POSCAR for IDM calculation.
echo "-------------------------------------------------------------------------"
echo "Step2 Creat POSCAR-IDM for IDM calculation."
cp POSCAR POSCAR-IDM

# Obtain the line of the final f/i.
start_line=$(grep -n "f/i" OUTCAR | tail -1 | cut -d: -f1)
start_line=$((start_line + 2))

# Obtain the number of total atoms.
total_atoms=$(grep -m1 "NIONS" OUTCAR | awk '{print $NF}' )

# Extract data of dx, dy, dz and save to temporary file.
tail -n +$start_line OUTCAR | head -n $total_atoms | cut -c 39-74  > temp_dxdydz.dat
echo "" >> POSCAR-IDM    # Increase blank line
cat temp_dxdydz.dat >> POSCAR-IDM
rm temp_dxdydz.dat

echo "POSCAR for IDM calculation is created successfully!!"

# Creat IDM folder and input files.
echo "-------------------------------------------------------------------------"
echo "Step3 IDM folder and input files."
parent_dir=$(dirname "$directory")
IDM_folder_dir="${parent_dir}/3-IDM"
mkdir -p "$IDM_folder_dir"
cp INCAR KPOINTS POTCAR $IDM_folder_dir/
cp POSCAR-IDM $IDM_folder_dir/POSCAR
cp /home/yangjiangrong/YangJiangRong/Other-Scripts/sub_vasp5.sh $IDM_folder_dir/sub_vasp5.sh

echo "IDM folder is created successfully! All input files are copied successfully!" 

# Modify INCAR and KPOINTS.
echo "-------------------------------------------------------------------------"
echo "Step4 Modify INCAR and KPOINTS."
cd  "$IDM_folder_dir" || exit
IDM_directory=$(pwd)
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "$IDM_directory"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++"
sed -i '10c    NPAR=6' INCAR
sed -i '25c    NSW=200 # number of steps for IOM' INCAR

sed -i '63c    #IBRION=5' INCAR
sed -i '64c    #POTIM=0.015' INCAR
sed -i '65c    #NFREE=2' INCAR
sed -i '66c    #NWRITE=3          # berofe IDM must be set and IBRION=5' INCAR

sed -i '68c    IBRION=44' INCAR
sed -i '69c    POTIM=0.05' INCAR

sed -i '4c  3   3   1 '  KPOINTS

ls *

echo "-------------------------------------------------------------------------"
echo "All the documents used to calculate the transition state through IDM have been prepared."
echo "Good luck with your transition state calculation!"