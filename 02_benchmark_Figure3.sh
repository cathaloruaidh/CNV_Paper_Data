# /bin/bash


##################################################
# 02_benchmark_Figure3.sh
# 
# Benchmark the CNV calls for the two evaluation
# samples against the curated gold standard
# deletion calls. This calculates the recall and 
# precision of the call sets. 
##################################################



# header line
echo -e "Sample\tPipeline\tRecall\tPrecision" > output/Benchmarking_results.txt



#  NA12878
for FILE in data/NA12878.*.DEL.lift_hg19.bed
do 
	GS="resource/2023.5.11_NA12878_GS_STRICT_super_clean_DELs.uniq_no_Mills_chrX.bed"

	PL=$( echo ${FILE} | cut -f2 -d'.' )

	COUNT=$( bedtools intersect -a ${GS} -b ${FILE} -f 0.5 -r -wa | bedtools sort -i - | uniq | wc -l )
	RECALL=$( echo "scale=6;${COUNT}/$( wc -l < ${GS} )" | bc )

	COUNT=$( bedtools intersect -a ${FILE} -b ${GS} -f 0.5 -r -wa | bedtools sort -i - | uniq | wc -l )
	PREC=$( echo "scale=6;${COUNT}/$( wc -l < ${FILE} )" | bc )

	echo -e "NA12878\t${PL}\t${RECALL}\t${PREC}"
done >> output/Benchmarking_results.txt





#  HG002
for FILE in data/HG002.*.DEL.lift_hg19.bed
do 
	GS="resource/HG002_SVs_Tier1_v0.6.DEL.bed"

	PL=$( echo ${FILE} | cut -f2 -d'.' )

	COUNT=$( bedtools intersect -a ${GS} -b ${FILE} -f 0.5 -r -wa | bedtools sort -i - | uniq | wc -l )
	RECALL=$( echo "scale=6;${COUNT}/$( wc -l < ${GS} )" | bc )
	
	COUNT=$( bedtools intersect -a ${FILE} -b ${GS} -f 0.5 -r -wa | bedtools sort -i - | uniq | wc -l )
	PREC=$( echo "scale=6;${COUNT}/$( wc -l < ${FILE} )" | bc )

	echo -e "HG002\t${PL}\t${RECALL}\t${PREC}"
done >> output/Benchmarking_results.txt
