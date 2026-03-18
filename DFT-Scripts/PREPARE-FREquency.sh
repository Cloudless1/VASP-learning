#!/bin/bash


#keep old INCAR
for i in *; do cp $i/POSCAR $i/POSCAR-old ; done
for i in *; do mv $i/CONTCAR $i/POSCAR ; done
echo 0

#prepare new INCAR for single point energy 
for i in * ; do  sed -i '10c    NPAR=6' $i/INCAR ; done
for i in * ; do  sed -i '19c    NELM=60    # ELM steps' $i/INCAR ; done
for i in * ; do  sed -i '20c    #NELMDL=5          # Min electronic SCF steps' $i/INCAR ; done
for i in * ; do  sed -i '25c    NSW=1              # number of steps for IOM' $i/INCAR ; done
for i in * ; do  sed -i '26c    IBRION=5    #ionic relax: -1-no update 0-MD 1-quasi-New 2-CG 5-Freq 44-IDM for TS' $i/INCAR ; done
for i in * ; do  sed -i '27c    POTIM=0.015  #0.5 or 0.2 for ionic relaxation 0.015 for IBRION-5,6' $i/INCAR ; done
for i in * ; do  sed -i '31c    LWAVE=F            # write WAVECAR' $i/INCAR ; done
for i in * ; do  sed -i '49c   #LSOL=.TRUE.' $i/INCAR ; done
for i in * ; do  sed -i '50c   #EB_K=78.4                     # Relative permittivity' $i/INCAR ; done
for i in * ; do  sed -i '51c   #LAMBDA_D_K=3.04          # Debye length in Angstroms' $i/INCAR ; done
for i in * ; do  sed -i '52c   #TAU=0                             # Surface tension paramete' $i/INCAR ; done

echo 1

#prepare 1*1*1 KPOINTS   (whole line substitution)  -i is directly modefy the source file
for i in * ; do sed -i '4c  1   1   1 '  $i/KPOINTS; done
echo 2

#fix lower catalyst atoms
for i in *;do 
cd $i
#(echo 402; echo 1;echo 1;echo C N; echo all) | vaspkit  > POSCAR.log
(echo 402; echo 1;echo 3;echo 0 0.35; echo 1;echo all) | vaspkit  > POSCAR.log
mv POSCAR_FIX.vasp POSCAR
cd ../;
done
echo 3

#prepare submit scripts
for i in *; do cp /home/yangjiangrong/YangJiangRong/Other-Scripts/sub_vasp5.sh   $i/   -r; done
#echo 4

directory=$(pwd)

cp /home/yangjiangrong/YangJiangRong/Other-Scripts/sub-vasp+.sh "$directory/sub-vasp+.sh"  -r
ls *
