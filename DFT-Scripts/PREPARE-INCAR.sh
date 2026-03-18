#!/bin/bash


#remove .out
for i in *;do rm $i/*.out; done
echo "remove .out file"

#prepare new INCAR for IBRION calculation
for i in * ; do  sed -i '10c    NPAR=6' $i/INCAR ; done
#for i in * ; do  sed -i '13c    #IALGO=48' $i/INCAR ; done
#for i in * ; do  sed -i '16c    ENCUT=450   # cutoff energy' $i/INCAR ; done
for i in * ; do  sed -i '18c    EDIFF=1e-7  # stopping criterion for ELM  ' $i/INCAR ; done
for i in * ; do  sed -i '19c    NELM=200    # ELM steps' $i/INCAR ; done
for i in * ; do  sed -i '20c    NELMDL=-10          # Min electronic SCF steps    ' $i/INCAR ; done
#for i in * ; do  sed -i '24c   EDIFFG=-0.02     #convergence criterion for ions; positive = max energy change  ' $i/INCAR ; done
for i in * ; do  sed -i '25c    NSW=0       # number of steps for IOM '     $i/INCAR ; done
for i in * ; do  sed -i '26c    IBRION=-1    #ionic relax: -1-no update 0-MD 1-quasi-New 2-CG 5-Freq 44-IDM for TS' $i/INCAR ; done
#for i in * ; do  sed -i '27c    POTIM=0.015    #0.5 or 0.2 for ionic relaxation 0.015 for IBRION-5,6' $i/INCAR ; done
#for i in * ; do  sed -i '31c    LWAVE=F     #write WAVECAR' $i/INCAR ; done
for i in * ; do  sed -i '32c    LCHARG=T    #write CHGCAR' $i/INCAR; done

for i in * ; do  sed -i '37c    #IVDW=12            # DFT-D3 BJ' $i/INCAR; done

for i in * ; do  sed -i '49c    LSOL=.TRUE.'    $i/INCAR; done
for i in * ; do  sed -i '50c    EB_K=78.4       # Relative permittivity ' $i/INCAR; done
for i in * ; do  sed -i '51c    LAMBDA_D_K=3.04          # Debye length in Angstroms'      $i/INCAR; done
for i in * ; do  sed -i '52c    TAU=0                             # Surface tension paramete' $i/INCAR; done

echo "prepare new INCAR"

#prepare POSCAR
for i in *; do cp $i/POSCAR $i/POSCAR-old ; done
for i in *; do mv $i/CONTCAR $i/POSCAR ; done
echo "copy old POSCAR and convert CONTCAR to POSCAR"

#prepare 1*1*1 KPOINTS   (whole line substitution)  -i is directly modefy the source file
#for i in * ; do sed -i '4c  3   3   1 '  $i/KPOINTS; done
#echo 2
