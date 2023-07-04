# /bin/bash


##################################################
# 01_resources.sh
# 
# Download the publicly available resource data
# and process
##################################################




# get the GRCh38 to GRCh37 chain file
wget https://hgdownload.soe.ucsc.edu/goldenPath/hg38/liftOver/hg38ToHg19.over.chain.gz -P resource 




# get the GIAB HG002 SV VCF file
wget https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/analysis/NIST_SVs_Integration_v0.6/HG002_SVs_Tier1_v0.6.vcf.gz -P resource 
wget https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/analysis/NIST_SVs_Integration_v0.6/HG002_SVs_Tier1_v0.6.vcf.gz.tbi -P resource 



# extract benchmark deletions
bcftools query -i 'FILTER="PASS" && SVTYPE="DEL" && (REPTYPE="SIMPLEDEL" || REPTYPE="CONTRAC")' -f 'chr%CHROM\t%POS\t%SVLEN\n' resource/HG002_SVs_Tier1_v0.6.vcf.gz \
	| awk -v OFS="\t" '{ print $1, $2, $2 - $3, "HG002_Tier1_DEL_" NR} ' \
	| bedtools sort -i - \
	> resource/HG002_SVs_Tier1_v0.6.DEL.bed



