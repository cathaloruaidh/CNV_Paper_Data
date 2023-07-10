# /bin/bash


##################################################
# 04_benchmark_Figure4.sh
# 
# Extract all deletions from the trio data (split
# by the level of evidence supporting each call)
# and benchmark against the curated gold standard
# deletions. Calculate the precision for each set
##################################################



# header
echo -e "Sample\tEvidence\tPrecision" > output/Singletons_Precision.txt







## NA12878
# extract all deletions and convert to BED 
bcftools view -s NA12878 data/CEPH1463.TRIO.vcf | \
	bcftools query -i 'SVTYPE="DEL"' -f "%CHROM\t%POS\t%END\t%ID\t[%ST]\n" | \
	awk -v OFS="\t" '{ print $1,$2-1,$3-1,$4,$5 }' | \
	bedtools sort -i - > output/CEPH1463.TRIO.NA12878.DEL.bed



# split by level of evidence
awk '$5 == "C"' output/CEPH1463.TRIO.NA12878.DEL.bed > output/CEPH1463.TRIO.NA12878.DEL.Consensus.bed
awk '$5 == "R"' output/CEPH1463.TRIO.NA12878.DEL.bed > output/CEPH1463.TRIO.NA12878.DEL.Reclaimed.bed
awk '$5 == "R" || $5 == "S"' output/CEPH1463.TRIO.NA12878.DEL.bed > output/CEPH1463.TRIO.NA12878.DEL.Singleton.bed
awk '$5 == "S"' output/CEPH1463.TRIO.NA12878.DEL.bed > output/CEPH1463.TRIO.NA12878.DEL.Lost.bed




# convert to hg19
for FILE in output/CEPH1463.TRIO.NA12878.DEL.*.bed
do 
	echo ${FILE}
	liftOver ${FILE} resource/hg38ToHg19.over.chain.gz ${FILE%bed}lift_hg19.bed ${FILE%bed}reject_hg19.bed
	echo
done 



# benchmark high-confidence (i.e. no singleton) calls
for FILE in output/CEPH1463.TRIO.NA12878.DEL.*.lift_hg19.bed
do
	GS="resource/2023.5.11_NA12878_GS_STRICT_super_clean_DELs.uniq_no_Mills_chrX.bed"

	EV=$( echo ${FILE} | cut -f5 -d'.' )

	COUNT=$( bedtools intersect -a ${FILE} -b ${GS} -f 0.5 -r -wa | bedtools sort -i - | uniq | wc -l )
	PREC=$( echo "scale=6;${COUNT}/$( wc -l < ${FILE} )" | bc )

	echo -e "NA12878\t${EV}\t${PREC}"
done >> output/Singletons_Precision.txt







## HG002
# extract all deletions and convert to BED 
bcftools view -s HG002 data/ASJ.TRIO.vcf | \
	bcftools query -i 'SVTYPE="DEL"' -f "%CHROM\t%POS\t%END\t%ID\t[%ST]\n" | \
	awk -v OFS="\t" '{ print $1,$2-1,$3-1,$4,$5 }' | \
	bedtools sort -i - > output/ASJ.TRIO.HG002.DEL.bed



# split by level of evidence
awk '$5 == "C"' output/ASJ.TRIO.HG002.DEL.bed > output/ASJ.TRIO.HG002.DEL.Consensus.bed
awk '$5 == "R"' output/ASJ.TRIO.HG002.DEL.bed > output/ASJ.TRIO.HG002.DEL.Reclaimed.bed
awk '$5 == "R" || $5 == "S"' output/ASJ.TRIO.HG002.DEL.bed > output/ASJ.TRIO.HG002.DEL.Singleton.bed
awk '$5 == "S"' output/ASJ.TRIO.HG002.DEL.bed > output/ASJ.TRIO.HG002.DEL.Lost.bed




# convert to hg19
for FILE in output/ASJ.TRIO.HG002.DEL.*.bed
do 
	echo ${FILE}
	liftOver ${FILE} resource/hg38ToHg19.over.chain.gz ${FILE%bed}lift_hg19.bed ${FILE%bed}reject_hg19.bed
	echo
done 



# benchmark high-confidence (i.e. no singleton) calls
for FILE in output/ASJ.TRIO.HG002.DEL.*.lift_hg19.bed
do
	GS="resource/HG002_SVs_Tier1_v0.6.DEL.bed"

	EV=$( echo ${FILE} | cut -f5 -d'.' )

	COUNT=$( bedtools intersect -a ${FILE} -b ${GS} -f 0.5 -r -wa | bedtools sort -i - | uniq | wc -l )
	PREC=$( echo "scale=6;${COUNT}/$( wc -l < ${FILE} )" | bc )

	echo -e "HG002\t${EV}\t${PREC}"
done >> output/Singletons_Precision.txt




echo -e "\n\nDone! \n\n"

