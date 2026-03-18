#!/bin/bash
#this scripts is uesd to calculated Bader charge

for i in *;do 
cd $i
chgsum.pl AECCAR0 AECCAR2  > bader1.log
bader CHGCAR -ref CHGCAR_sum  > bader2.log
cd ../;
done
