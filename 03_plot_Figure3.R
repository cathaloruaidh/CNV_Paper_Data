library(ggplot2)
library(dplyr)


BR_col <- c("#94221F", "#3A69AE", "#628D56", "#C195C4", "#F2B342")


# Deletion calls
DATA <- read.table("output/Benchmarking_results.DEL.txt", header = T, sep='\t')

DATA$Pipeline_f <- factor(DATA$Pipeline, levels = c("TRIO", "INDIVIDUAL", "KHAN"))
DATA$Sample_f <- factor(DATA$Sample, levels = c("NA12878", "HG002"))


png("Figure_3.png", width = 16, height = 9, units = "in", res=350)
DATA %>%
  ggplot(aes(x=Recall, y=Precision, fill = Pipeline_f)) + 
  geom_point(size = 7, alpha=0.9, shape=21) + 
  scale_fill_manual(values = c(BR_col[3], BR_col[2], BR_col[1])) + 
  xlim(c(0.0, 1.0)) + 
  labs(fill = "Pipeline") + 
  ylim(c(0.0, 1.0)) + 
  coord_fixed(ratio = 1) +
  facet_grid(~Sample_f) + 
  theme(text = element_text(size=25), 
        plot.title = element_text(size=25, hjust = 0.5))
dev.off()  




# Duplication calls
DATA <- read.table("output/Benchmarking_results.DEL.txt", header = T, sep='\t')

DATA$Pipeline_f <- factor(DATA$Pipeline, levels = c("TRIO", "INDIVIDUAL", "KHAN"))


png("Figure_SN.png", width = 16, height = 9, units = "in", res=350)
DATA %>%
  ggplot(aes(x=Recall, y=Precision, fill = Pipeline_f)) + 
  geom_point(size = 7, alpha=0.9, shape=21) + 
  scale_fill_manual(values = c(BR_col[3], BR_col[2], BR_col[1])) + 
  xlim(c(0.0, 1.0)) + 
  labs(fill = "Pipeline") + 
  ylim(c(0.0, 1.0)) + 
  coord_fixed(ratio = 1) +
  facet_grid(~Sample_f) + 
  theme(text = element_text(size=25), 
        plot.title = element_text(size=25, hjust = 0.5))
dev.off()  



cat("\n\nDone! \n\n")
