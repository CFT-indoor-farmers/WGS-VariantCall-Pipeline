#!/bin/bash
#PBS -q qlong
#PBS -l select=1:ncpus=1:mem=192G
#PBS -l walltime=120:00:00
#PBS -N FilterBoleraceaBCF
#PBS -P Personal

# Define directories
VCFGZ_DIR="/path/to/Boleracea/merged/vcf.gz_files"
PLINK_BIN="/path/to/PLINK/executable/file"
OUTDIR="/path/for/PLINK/Boleracea/output_files"

# Change to the VCF directory
cd $PBS_O_WORKDIR

# if no log folder, then make one
[ -d log ] || mkdir log

# Change name if necessary
MERGED_VCF="$VCFGZ_DIR/Merged_BrassicaOleracea_BeforeFilter.vcf.gz"

# Convert the merged VCF to PLINK format
$PLINK_BIN --vcf "$MERGED_VCF" --keep-allele-order --allow-extra-chr --allow-no-sex --double-id --make-bed \
    --out "$OUTDIR/Merged_BrassicaOleracea_formatting"

############
# Apply SNPs only filter
$PLINK_BIN --bfile "$OUTDIR/Merged_BrassicaOleracea_formatting" --keep-allele-order --allow-extra-chr --allow-no-sex --snps-only --make-bed \
    --out "$OUTDIR/Merged_BrassicaOleracea_SNPs"

############
# Apply missing genotype filter
$PLINK_BIN --bfile "$OUTDIR/Merged_BrassicaOleracea_SNPs" --keep-allele-order --allow-extra-chr --allow-no-sex --geno 0.1 --make-bed \
    --out "$OUTDIR/Merged_BrassicaOleracea_SNPs_geno"

############
# Apply MAF 0.05 filter
$PLINK_BIN --bfile "$OUTDIR/Merged_BrassicaOleracea_SNPs_geno" --keep-allele-order --allow-extra-chr --allow-no-sex --maf 0.05 --make-bed \
    --out "$OUTDIR/Merged_BrassicaOleracea_SNPs_geno_maf005"

# Deal with duplicate variant ID names
$PLINK_BIN --bfile "$OUTDIR/Merged_BrassicaOleracea_SNPs_geno_maf005" --keep-allele-order --allow-extra-chr --allow-no-sex --set-missing-var-ids @:# --make-bed \
    --out "$OUTDIR/Merged_BrassicaOleracea_SNPs_geno_maf005_final"

# Create a PED file from the BED file
$PLINK_BIN --bfile "$OUTDIR/Merged_BrassicaOleracea_SNPs_geno_maf005_final" --keep-allele-order --allow-no-sex --allow-extra-chr --recode --tab \
    --out "$OUTDIR/Merged_BrassicaOleracea_SNPs_geno_maf005_final"

# Create a final VCF file from the BED file
$PLINK_BIN --bfile "$OUTDIR/Merged_BrassicaOleracea_SNPs_geno_maf005_final" --keep-allele-order --allow-no-sex --allow-extra-chr --recode vcf \
    --out "$OUTDIR/Merged_BrassicaOleracea_SNPs_geno_maf005_final"