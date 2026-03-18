#!/bin/bash

# This script is used to creat all files for CINEB calculation to search first guess of TS.
# Before runing this script, you need prepare CONTCAR1, CONTCAR2, INCAR, KPOINTS, POTCAR.

#Set target path
directory=$(pwd)
echo "Current directory is $directory"

#Switch to target path
cd "$directory" || exit

# Check CONTCAR1, CONTCAR2, INCAR, KPOINTS, POTCAR files.
echo "-------------------------------------------------------------------------"
echo "Step1 Check required files"
files=("CONTCAR1" "CONTCAR2" "INCAR" "KPOINTS" "POTCAR")
missing_files=()

for file in "${files[@]}"; do
    if [ ! -f "$file" ]; then
        missing_files+=("$file")
    fi
done

if [ ${#missing_files[@]} -gt 0 ]; then
    echo "Error: the following required file are missing."
    for file in "${missing_files[@]}"; do
        echo " - $file"
    done
        echo "Please prepare these files before running the script."
    exit 1
fi

echo "All required files present. Continuing with CINEB setup..."

# Check distance.
echo "-------------------------------------------------------------------------"
echo "Step2 Check distance between IS and FS"
distance=$(dist.pl CONTCAR1 CONTCAR2)
echo "Distance between IS and FS: $distance"
if (( $(echo "$distance > 8.0" | bc -l) )); then
    echo "Error: distance $distance is excessive."
    exit 1
else
    echo "Distance $distance is acceptable."
fi

# Copy submit script and TS-idpp.py files and creat new folder.
echo "-------------------------------------------------------------------------"
echo "Step4 Copy submit script and TS-idpp.py files and creat new folder."
cp /home/yangjiangrong/YangJiangRong/Other-Scripts/sub_vasp5-TS-96.sh sub_vasp5.sh
cp /home/yangjiangrong/YangJiangRong/Other-Scripts/TS-idpp.py TS-idpp.py
mkdir IS FS
cp CONTCAR1 IS/CONTCAR
cp CONTCAR2 FS/CONTCAR

# Load Python environment
echo "-------------------------------------------------------------------------"
echo "Step4 Load Python environment."
module load conda
conda activate yangjiangrong
python TS-idpp.py IS/CONTCAR FS/CONTCAR 6
module unload conda

# Obtain the path of transition state.
echo "-------------------------------------------------------------------------"
echo "Step5 Obtain the path of transition state."
(echo 504| vaspkit) > vaspkit-504.log
ls *

# Modify INCAR and KPOINTS.
echo "-------------------------------------------------------------------------"
echo "Step6 Modify INCAR and KPOINTS."
sed -i '10c    NPAR=4' INCAR
sed -i '25c    NSW=30 # number of steps for IOM' INCAR
sed -i '26c    #IBRION=1 # ionic relax: -1-no update 0-MD 1-quasi-New 2-CG 5-Freq 44-IDM for TS' INCAR
sed -i '56c    LCLIMB=.TRUE.     # CINEB' INCAR
sed -i '57c    IMAGES=6          # the number of images' INCAR
sed -i '58c    SPRING=-5         # elastic constant' INCAR
sed -i '59c    IBRION=3          # vasp 1 or 3; VTST 3' INCAR
sed -i '60c    POTIM = 0         # 0 is using VTST ; 0.1-1.0 is using VASP' INCAR
sed -i '61c    IOPT=2            # 1 -LBFGS , 2 - CG first choice ; other 3 , 4, 7' INCAR


sed -i '4c  1   1   1 '  KPOINTS

echo "-------------------------------------------------------------------------"
echo "All the documents used to calculate the transition state through CINEB have been prepared."
echo "Good luck with your transition state calculation!"