#!/bin/bash
#PBS -q normal
#PBS -l select=1:ncpus=4:mem=64G
#PBS -l walltime=24:00:00
#PBS -N VariantCall_ESati1
#PBS -P Personal

# Load modules required for this step
module load bcftools/1.15.1

# Define directories
FASTA_DIR="/path/to/fasta/file/ESativa"
BAM_DIR="path/to/ESativa/BAM_files"
OUTDIR="/path/to/ESativa/BCF_file_output"

# Change directory to the directory where shell script is located for collection of log files
cd $PBS_O_WORKDIR

# if no log folder, then make one
[ -d log ] || mkdir log

# Collating the filenames of all BAM files into a .txt file for bcftools multiple sample variant calling
# in the same directory as where the BAM files were.
find "$BAM_DIR" -type f -name "*.bam" | sort | uniq > \
    "$BAM_DIR/BAMfie_ESativa_list.txt"

# Specifying the scaffold number to the "SCAFFOLDNO" variable, according to the RNAME of the aligned reads in the BAM file.
# Change accordingly to the scaffold you wish to call variants for.
export SCAFFOLDNO=1

# Perform BCFtools commands using 4 threads, previously determined to have optimal trade-off between computational resource and time.
# Change the name of the actual FASTA file accordingly
bcftools mpileup --threads 4 -Ou -q 20 -Q 30 -f "$FASTA_DIR/ESativa.fa" \
        -r "scaffold_$SCAFFOLDNO" -b "$(echo $BAM_DIR/BAMfie_ESativa_list.txt)" | \
        bcftools call --threads 4 -mv -Ob \
        -o "$OUTDIR/ESativa_variants_scaffold$SCAFFOLDNO.bcf"

echo "########################"
echo "VARIANT CALLING COMPLETE"
echo "########################"