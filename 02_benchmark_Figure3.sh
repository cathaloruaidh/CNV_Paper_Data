# /bin/bash


##################################################
# 02_benchmark_Figure3.sh
# 
# Benchmark the CNV calls for the two evaluation
# samples against the curated gold standard
# CNV calls. This calculates the recall and 
# precision of the query call sets. 
##################################################



# header line
echo -e "Sample\tPipeline\tLength\tRecall\tPrecision" > output/Benchmarking_results.DEL.txt
echo -e "Sample\tPipeline\tLength\tRecall\tPrecision" > output/Benchmarking_results.DUP.txt



#  NA12878 DEL
for FILE in data/NA12878.*.DEL.bed
do 
	# all CNVs
	GS="resource/2023.5.11_NA12878_GS_STRICT_super_clean_DELs.uniq_no_Mills_chrX.lift_GRCh38.bed"
	PL=$( echo ${FILE} | cut -f2 -d'.' )

	COUNT=$( bedtools intersect -a ${GS} -b ${FILE} -f 0.5 -r -wa | bedtools sort -i - | uniq | wc -l )
	RECALL=$( echo "scale=6;${COUNT}/$( wc -l < ${GS} )" | bc )

	COUNT=$( bedtools intersect -a ${FILE} -b ${GS} -f 0.5 -r -wa | bedtools sort -i - | uniq | wc -l )
	PREC=$( echo "scale=6;${COUNT}/$( wc -l < ${FILE} )" | bc )

	echo -e "NA12878\t${PL}\tAll\t${RECALL}\t${PREC}"



	# CNVs of length <=1kbp
	GS="resource/2023.5.11_NA12878_GS_STRICT_super_clean_DELs.uniq_no_Mills_chrX.lift_GRCh38.le1kbp.bed"
	awk '$3-$2 <= 1000' ${FILE} > ${FILE%bed}le1kbp.bed

	COUNT=$( bedtools intersect -a ${GS} -b ${FILE%bed}le1kbp.bed -f 0.5 -r -wa | bedtools sort -i - | uniq | wc -l )
	RECALL=$( echo "scale=6;${COUNT}/$( wc -l < ${GS} )" | bc )

	COUNT=$( bedtools intersect -a ${FILE%bed}le1kbp.bed -b ${GS} -f 0.5 -r -wa | bedtools sort -i - | uniq | wc -l )
	PREC=$( echo "scale=6;${COUNT}/$( wc -l < ${FILE%bed}le1kbp.bed )" | bc )

	echo -e "NA12878\t${PL}\t<=1kbp\t${RECALL}\t${PREC}"



	# CNVs of length >1kbp
	GS="resource/2023.5.11_NA12878_GS_STRICT_super_clean_DELs.uniq_no_Mills_chrX.lift_GRCh38.gt1kbp.bed"
	awk '$3-$2 > 1000' ${FILE} > ${FILE%bed}gt1kbp.bed

	COUNT=$( bedtools intersect -a ${GS} -b ${FILE%bed}gt1kbp.bed -f 0.5 -r -wa | bedtools sort -i - | uniq | wc -l )
	RECALL=$( echo "scale=6;${COUNT}/$( wc -l < ${GS} )" | bc )

	COUNT=$( bedtools intersect -a ${FILE%bed}gt1kbp.bed -b ${GS} -f 0.5 -r -wa | bedtools sort -i - | uniq | wc -l )
	PREC=$( echo "scale=6;${COUNT}/$( wc -l < ${FILE%bed}gt1kbp.bed )" | bc )

	echo -e "NA12878\t${PL}\t>1kbp\t${RECALL}\t${PREC}"
done >> output/Benchmarking_results.DEL.txt





#  HG002
for CNV in DUP DEL
do
	for FILE in data/HG002.*.${CNV}.bed
	do 
		GS="resource/HG002_SVs_Tier1_v0.6.${CNV}.lift_GRCh38.bed"
	
		PL=$( echo ${FILE} | cut -f2 -d'.' )
	
		COUNT=$( bedtools intersect -a ${GS} -b ${FILE} -f 0.5 -r -wa | bedtools sort -i - | uniq | wc -l )
		RECALL=$( echo "scale=6;${COUNT}/$( wc -l < ${GS} )" | bc )
	
		COUNT=$( bedtools intersect -a ${FILE} -b ${GS} -f 0.5 -r -wa | bedtools sort -i - | uniq | wc -l )
		PREC=$( echo "scale=6;${COUNT}/$( wc -l < ${FILE} )" | bc )

		echo -e "HG002\t${PL}\tAll\t${RECALL}\t${PREC}"



		# CNVs of length <=1kbp
		GS="resource/HG002_SVs_Tier1_v0.6.${CNV}.lift_GRCh38.le1kbp.bed"
		awk '$3-$2 <= 1000' ${FILE} > ${FILE%bed}le1kbp.bed

		COUNT=$( bedtools intersect -a ${GS} -b ${FILE%bed}le1kbp.bed -f 0.5 -r -wa | bedtools sort -i - | uniq | wc -l )
		RECALL=$( echo "scale=6;${COUNT}/$( wc -l < ${GS} )" | bc )

		COUNT=$( bedtools intersect -a ${FILE%bed}le1kbp.bed -b ${GS} -f 0.5 -r -wa | bedtools sort -i - | uniq | wc -l )
		PREC=$( echo "scale=6;${COUNT}/$( wc -l < ${FILE%bed}le1kbp.bed )" | bc )

		echo -e "HG002\t${PL}\t<=1kbp\t${RECALL}\t${PREC}"



		# CNVs of length >1kbp
		GS="resource/HG002_SVs_Tier1_v0.6.${CNV}.lift_GRCh38.gt1kbp.bed"
		awk '$3-$2 > 1000' ${FILE} > ${FILE%bed}gt1kbp.bed

		COUNT=$( bedtools intersect -a ${GS} -b ${FILE%bed}gt1kbp.bed -f 0.5 -r -wa | bedtools sort -i - | uniq | wc -l )
		RECALL=$( echo "scale=6;${COUNT}/$( wc -l < ${GS} )" | bc )

		COUNT=$( bedtools intersect -a ${FILE%bed}gt1kbp.bed -b ${GS} -f 0.5 -r -wa | bedtools sort -i - | uniq | wc -l )
		PREC=$( echo "scale=6;${COUNT}/$( wc -l < ${FILE%bed}gt1kbp.bed )" | bc )

		echo -e "HG002\t${PL}\t>1kbp\t${RECALL}\t${PREC}"

	done >> output/Benchmarking_results.${CNV}.txt
done






echo -e "\n\nDone! \n\n"
