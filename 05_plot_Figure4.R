library(ggplot2)
library(dplyr)


BR_col <- c("#94221F", "#3A69AE", "#628D56", "#C195C4", "#F2B342")

DATA <- read.table("output/Singletons_Precision.txt", header = T, sep='\t')

DATA$Evidence <- factor(DATA$Evidence, levels = c("Consensus", "Reclaimed", "Singleton", "Lost"))
DATA$Evidence <- factor(DATA$Evidence, labels = c("Consensus", "Reclaimed Singletons","All Singletons", "Lost Singletons"))

DATA$Sample <- factor(DATA$Sample, levels = c("NA12878", "HG002"))


tiff("Figure_4.tiff", width = 16, height = 9, units = "in", res=350)
ggplot(DATA, aes(x=Evidence, y=Precision, fill=Evidence)) + 
  geom_bar(stat="identity") + 
  facet_grid(.~Sample) + 
  ylim(0,1) + 
  scale_fill_manual(values = BR_col) +
  theme(text = element_text(size=20), 
        plot.title = element_text(size=20, hjust = 0.5),
        axis.text.x = element_blank(), 
        axis.title.x = element_blank(), 
        axis.ticks.x = element_blank())
dev.off()


cat("\n\nDone! \n\n")

