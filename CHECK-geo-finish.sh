#!/bin/bash
#this scripts is used to check the vasp task converges normally and ends
for i in * ; do
echo $i
grep 'reached required accuracy - stopping structural energy minimisation' $i/OUTCAR
done
