#!/bin/bash
#PBS -q normal
#PBS -l select=1:ncpus=1:mem=32G
#PBS -l walltime=24:00:00
#PBS -N touch_files
#PBS -P Personal

# Change accordingly to the scratch directory you wish to touch the files in
SCRATCH_DIR="/home/users/nus/e0725622/scratch"

# Change directory 
cd $SCRATCH_DIR

# List down all files into a .txt file
find . -type f > files_to_touch.txt

# Touch files
while IFS= read -r file; do
  touch "$file"
done < files_to_touch.txt

rm "$SCRATCH_DIR/files_to_touch.txt"