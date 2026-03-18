#!/bin/bash

#SBATCH -n 102 
#SBATCH -N 1
#SBATCH -J yjr-v5

# 打印任务信息
echo "Starting job $SLURM_JOB_ID at " `date`
echo "SLURM_SUBMIT_DIR is $SLURM_SUBMIT_DIR"
echo "Running on nodes: $SLURM_NODELIST"

# 执行任务
## 载入vasp
module load VASP/5.4.4-gzbuild
mpirun vasp_std > vasp.out 2>vasp.err

echo "-------------------Calculation completed!------------"
tail -5 vasp.out

NELECT_Net_charge=$(grep NELECT OUTCAR| head -1 | awk '{print $3}')
echo "-------------Net Charge is $NELECT_Net_charge-------"

sed -i "4c ICHARG=11           # charge 1-file 2-atom 10-const" INCAR

for i in $(seq 0.1 0.1 2.0); do
    file=INCAR
    line=$(sed -n '47p' "$file")
    NELECT_Accutral_charge=$(echo "$NELECT_Net_charge - $i" | bc)
    mkdir "m$i"
    cp CHGCAR INCAR KPOINTS POSCAR POTCAR "m$i"/
    sed -i "47c     NELECT=$NELECT_Accutral_charge   # Number of valence electrons " "m$i/INCAR"
done

for i in $(seq 0.1 0.1 1.0); do
    file=INCAR
    line=$(sed -n '47p' "$file")
    NELECT_Accutral_charge=$(echo "$NELECT_Net_charge + $i" | bc)
    mkdir "p$i"
    cp CHGCAR INCAR KPOINTS POSCAR POTCAR "p$i"/
    sed -i "47c     NELECT=$NELECT_Accutral_charge   # Number of valence electrons " "p$i/INCAR"
done

mkdir "0.0" && cp CHGCAR INCAR KPOINTS POSCAR POTCAR "0.0"/
sed -i "47c     NELECT=$NELECT_Net_charge   # Number of valence electrons " "0.0/INCAR"
ls -l
echo  "from m2.0 to p1.0, all directories are created successfully"

current_directory=$(pwd)
for folder in m* p* 0.0; do
    if [[  -d $folder ]]; then
        echo "Running VASP in $folder"
        cd "$folder"
        mpirun vasp_std > vasp.out 2>vasp.err
        cd "$current_directory"
    fi
done

# 任务结束
echo "Job $SLURM_JOB_ID done at " `date`

