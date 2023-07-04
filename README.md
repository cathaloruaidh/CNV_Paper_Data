# CNV Paper Data
This repository contains the data generated as part of our consensus CNV calling pipeline for WGS data. 
We used two well known genomes (NA12878 and HG002) as evaluation samples to benchmark our calling pipeline per individual and also including trio information. 
We have also included the output of a previously published pipeline on the same data for comparison (Khan et al., Schizophr Res, 2018 ; see [here](https://doi.org/10.1016/j.schres.2018.02.034)).
The `resource` directory contains the gold standard CNV calls. 
The `data` directory contains CNVs taken from the output of the three consensus CNV calling pipelines. 

If you have any queries or feedback, please contact the [author](mailto:cathalormond@gmail.com). 
If you use these data in your publication, please cite this repository (pending the publication of our manuscript). 


#  NA12878 deletion calls
As part of our work, we have curated a list of gold standard deletion calls for NA12878 taken from five publicly available resources. 
These data had been generated from various data types, including SNP data, aCGH data, and NGS data. 
We retained deletions that were present in at least two of the resources. 
The BED file for these can be downloadde directly here: 
```
wget https://raw.githubusercontent.com/cathaloruaidh/CNV_Paper_Data/master/resource/2023.5.11_NA12878_GS_STRICT_super_clean_DELs.uniq_no_Mills_chrX.bed

```


# Prerequisites
In additiona to some basic *nix software, the following are required to run the supplied scripts:
* `bcftools`
* `bedtools`
* `liftOver`
* `R`

Additionally, the following `R` libraries are required
* `ggplot2`
* `dplyr`



# Download and initialise
Download the repository:

```
git clone https://github.com/cathaloruaidh/CNV_Paper_Data.git
cd CNV_Paper_Data

```

Make all bash scripts excecutable:
```
chmod +x *sh

```

Download and extract the gold standard deletion calls for HG002 (saved to `resource`): 
```
./01_resources.sh

```


# Benchmarking
Benchmark the deletions from the two evaluation samples against the gold standards:

```
./02_benchmark_Figure3.sh

```

The results are stored in `output/Benchmarking_results.txt`. 
Plot these results (Figure 3 in the publication): 
```
Rscript 03_plot_Figure3.R

```


# Singletons
Extract the deletions from the two trios and split by the level of evidence supporting each call: 

```
./04_benchmark_Figure4.sh

```

The results are stored in `output/Singletons_Precision.txt`. 
Plot these results (Figure 4 in the publication): 
```
Rscript 05_plot_Figure4.R

```


