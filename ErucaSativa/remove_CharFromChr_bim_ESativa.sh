#!/bin/bash
#PBS -q normal
#PBS -l select=1:ncpus=4:mem=128G
#PBS -l walltime=24:00:00
#PBS -N Remove_scaffold_from_chrName_bim
#PBS -P Personal

# "scaffold_" for E.Sativa

# Define directories
OUTDIR="/path/for/PLINK/ESativa/output_files"
# LD pruned BIMBAM files must have already been created
# If you wish to use your own files, please modify accordingly.
input_bim="$OUTDIR/Merged_ErucaSativa_SNPs_geno_maf005_LDprune_final.bim"

# Change to the directory containing shell scripts to collect log files
cd $PBS_O_WORKDIR

# Use awk to modify the first column (chromosome column) of the .bim file and overwrite the original file
awk '{
    if ($1 ~ /^scaffold_[0-9]+/) {
        sub(/^scaffold_/, "", $1);  # Remove "scaffold_"
        $1 = int($1);       # Convert to integer
    }
    print $0;
}' $input_bim > "$OUTDIR/temp.bim"

mv "$OUTDIR/temp.bim" $input_bim