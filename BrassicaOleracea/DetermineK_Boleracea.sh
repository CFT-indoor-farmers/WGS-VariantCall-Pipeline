#!/bin/bash
#PBS -q qlong
#PBS -l select=1:ncpus=4:mem=128G
#PBS -l walltime=120:00:00
#PBS -N DetermineK_Boleracea
#PBS -P Personal

# Multithreaded mode
# To split ADMIXTURE’s work among N threads, you may append the flag -jN (e.g. -j4) to your ADMIXTURE command. 
# The core algorithms will run up to N times as fast, presuming you have at least N processors.

# Section 2.1: choosing the correct value for K using cross validation, then use this K value for actual analysis

# Define directories
ADMIXTURE_BIN="/path/to/Admixture/executable/file" 
GENOTYPE_DIR="/path/for/PLINK/Boleracea/output_files"
OUTDIR="/path/to/Admixture/output"

# Admixture will output files in the current working directory.
# PLEASE USE DIFFERENT OUTPUT DIRECTORIES FOR DIFFERENT VEGETABLES/CROPS, AS ADMIXTURE WILL OVERWRITE OLD FILES
# DUE TO DEFAULT NAMING SYSTEM.
cd $OUTDIR

# Cross-validation to determine the "optimal K value"
# Additionally, perform P and Q matrix calculation for K=2 to K=9 example.
for K in {2..9}; do
    $ADMIXTURE_BIN --cv "$GENOTYPE_DIR/Merged_BrassicaOleracea_SNPs_geno_maf005_removed_LDprune_final.bed" $K -j4 | tee log${K}.out 
done