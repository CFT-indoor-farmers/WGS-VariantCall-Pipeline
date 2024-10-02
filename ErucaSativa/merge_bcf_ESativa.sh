#!/bin/bash
#PBS -q normal
#PBS -l select=1:ncpus=4:mem=64G
#PBS -l walltime=24:00:00
#PBS -N MergeBCFsESativa
#PBS -P Personal

# Before running this script, ensure that the ONLY bcf files in the $BCF_DIR 
# are the ones generated from the previous joint sample variant calling step. 
# Hence, bcf files generated from different species must be placed in different directories, 
# if not merging using bcftools concat will be inaccurate.

# Load modules required for this step
module load bcftools/1.15.1

# Define directories
BCF_DIR="/path/to/ESativa/BCF_files"
OUTDIR="/path/to/ESativa/VCF.GZ_file_output"

# Change directory to the directory where shell script is located for collection of log files
cd $PBS_O_WORKDIR

# if no log folder, then make one
[ -d log ] || mkdir log

# Save the BCF files into a single text file
find "$BCF_DIR" -type f -name "*.bcf" | sort | uniq > \
    "$BCF_DIR/ESativa_bcfs_merge.txt"

# Indexing all of the BCF files
while IFS= read -r bcf_file; do
    # Run bcftools index on each BCF file
    bcftools index -f "$bcf_file"
done < "$BCF_DIR/ESativa_bcfs_merge.txt"

echo "#####################"
echo "BCF INDEXING COMPLETE"
echo "#####################"

# Merging the indexed BCF files using 4 threads
cat "$BCF_DIR/ESativa_bcfs_merge.txt" | xargs bcftools concat -a --threads 4 \
    -o "$OUTDIR/Merged_ErucaSativa_BeforeFilter.vcf.gz" -O z

echo "####################"
echo "BCF MERGING COMPLETE"
echo "####################"

bcftools index "$OUTDIR/Merged_ErucaSativa_BeforeFilter.vcf.gz"