#!/bin/bash
#this scripts is used to check the frequency calculation and print frequency
for i in * ; do
echo $i
grep f/i $i/OUTCAR
grep 'Finite differences POTIM=  1.500000000000000E-002'   $i/OUTCAR;
done
