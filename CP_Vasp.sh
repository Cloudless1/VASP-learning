#!/bin/bash
# this scripts is used to copy the files to download to widows

# Get the name of the current directory
current_dirname=$(basename "$PWD")

# Create a folder with the same name as the current directory
mkdir -p "$current_dirname"

# Iterate through all folders in the current directory
for dir in */; do
    # Skip the newly created folder
    if [ "$dir" == "$current_dirname/" ]; then
        continue
    fi

    # Create the corresponding subfolder within the newly created folder
    mkdir -p "$current_dirname/$dir"

    # Copy output files to the respective subfolder
    cp -f "$dir"/deltaG "$dir"/CONTCAR "$dir"/INCAR "$dir"/KPOINTS "$dir"/POSCAR "$dir"/POTCAR "$dir"/OSZICAR "$dir"/OUTCAR "$current_dirname/$dir/"
    cp -f "$dir"/vasp.out   "$current_dirname/$dir/"
    #cp -f "$dir"/ACF.dat "$dir"/AVF.dat "$dir"/BCF.dat  "$current_dirname/$dir/"
    #cp -f "$dir"/PDOS_*.dat  "$current_dirname/$dir/"

done

echo "Operation completed."