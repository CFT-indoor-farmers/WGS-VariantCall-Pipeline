Run the scripts in this sequence for variant calling:
- variant_call_cropname_chromosome/scaffoldNumber.sh
- merge_bcf_cropname.sh
- filter_merged_vcf_cropname.sh
- (optional, for B.Oleracea only) remove_problematic_samples.sh

Run the scripts in this sequence for Admixture analysis after obtaining the PLINK BIMBAM and VCF files from previous variant calling step.
- remove_CharFromChr_bim_Boleracea.sh (for B.Oleracea) remove_CharFromChr_bim_ESativa.sh (for E.Sativa)
- DetermineK_Boleracea.sh (for B.Oleracea) DetermineK_ErucaSativa.sh (for E.Sativa)