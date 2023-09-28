data <- read.table(file ="apa_plot.txt",row.names = 1, header=T) #optional
library(pheatmap)		

Max<-scan("MAX.txt")
Max<-ceiling(Max)
interval=Max/5
bk <- c(seq(0,Max,by=1)) 
pdf(file="APA.pdf")
pheatmap(data, cluster_cols = F, show_colnames =F,show_rownames = F,cluster_row = FALSE,color = c(colorRampPalette(colors = c("yellow","firebrick3"))(length(bk)/2),colorRampPalette(colors = c("firebrick3","black"))(length(bk)/2)),legend_breaks=seq(0,Max,interval),breaks=bk)
dev.off()
