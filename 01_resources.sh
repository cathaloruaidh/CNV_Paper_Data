# /bin/bash


##################################################
# 01_resources.sh
# 
# Download the publicly available resource data
# and process
##################################################


# output directory
mkdir output


# get the GRCh37 to GRCh38 chain file
wget https://hgdownload.soe.ucsc.edu/goldenPath/hg19/liftOver/hg19ToHg38.over.chain.gz -P resource



# get the GIAB HG002 SV VCF file
wget https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/analysis/NIST_SVs_Integration_v0.6/HG002_SVs_Tier1_v0.6.vcf.gz -P resource 
wget https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/analysis/NIST_SVs_Integration_v0.6/HG002_SVs_Tier1_v0.6.vcf.gz.tbi -P resource 



# extract benchmark deletions
bcftools query -i 'FILTER="PASS" && SVTYPE="DEL" && (REPTYPE="SIMPLEDEL" || REPTYPE="CONTRAC")' -f 'chr%CHROM\t%POS\t%SVLEN\n' resource/HG002_SVs_Tier1_v0.6.vcf.gz \
	| awk -v OFS="\t" '{ print $1, $2, $2 - $3, "HG002_Tier1_DEL_" NR} ' \
	| bedtools sort -i - \
	> resource/HG002_SVs_Tier1_v0.6.DEL.bed



# extract benchmark duplications
bcftools query -i 'FILTER="PASS" && SVTYPE="INS" && REPTYPE="DUP" && TRall="FALSE"' -f 'chr%CHROM\t%POS\t%SVLEN\n' resource/HG002_SVs_Tier1_v0.6.vcf.gz \
	| awk -v OFS="\t" '{ print $1, $2, $2 - $3, "HG002_Tier1_DUP_" NR} ' \
	| bedtools sort -i - \
	> resource/HG002_SVs_Tier1_v0.6.DUP.bed



# lift the GS calls to GRCh38
liftOver resource/HG002_SVs_Tier1_v0.6.DEL.bed resource/hg19ToHg38.over.chain.gz resource/HG002_SVs_Tier1_v0.6.DEL.lift_GRCh38.bed resource/HG002_SVs_Tier1_v0.6.DEL.reject_GRCh38.bed


liftOver resource/HG002_SVs_Tier1_v0.6.DUP.bed resource/hg19ToHg38.over.chain.gz resource/HG002_SVs_Tier1_v0.6.DUP.lift_GRCh38.bed resource/HG002_SVs_Tier1_v0.6.DUP.reject_GRCh38.bed



# split GS files by size for benchmarking
awk '$3-$2 > 1000' resource/2023.5.11_NA12878_GS_STRICT_super_clean_DELs.uniq_no_Mills_chrX.lift_GRCh38.bed > resource/2023.5.11_NA12878_GS_STRICT_super_clean_DELs.uniq_no_Mills_chrX.lift_GRCh38.gt1kbp.bed

awk '$3-$2 <= 1000' resource/2023.5.11_NA12878_GS_STRICT_super_clean_DELs.uniq_no_Mills_chrX.lift_GRCh38.bed > resource/2023.5.11_NA12878_GS_STRICT_super_clean_DELs.uniq_no_Mills_chrX.lift_GRCh38.le1kbp.bed


awk '$3-$2 > 1000' resource/HG002_SVs_Tier1_v0.6.DEL.lift_GRCh38.bed > resource/HG002_SVs_Tier1_v0.6.DEL.lift_GRCh38.gt1kbp.bed

awk '$3-$2 <= 1000' resource/HG002_SVs_Tier1_v0.6.DEL.lift_GRCh38.bed > resource/HG002_SVs_Tier1_v0.6.DEL.lift_GRCh38.le1kbp.bed


awk '$3-$2 > 1000' resource/HG002_SVs_Tier1_v0.6.DUP.lift_GRCh38.bed > resource/HG002_SVs_Tier1_v0.6.DUP.lift_GRCh38.gt1kbp.bed

awk '$3-$2 <= 1000' resource/HG002_SVs_Tier1_v0.6.DUP.lift_GRCh38.bed > resource/HG002_SVs_Tier1_v0.6.DUP.lift_GRCh38.le1kbp.bed




echo -e "\n\nDone! \n\n"
