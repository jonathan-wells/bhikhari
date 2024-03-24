library(tidyverse)
library(ggrepel)

data <-read.csv("~/Projects/feschottelab/bhikhari/data/KD_ASO_alltime_test_032124.csv", sep=",", header=TRUE)
vol <- data %>% 
  na.omit() %>%
  mutate(
    Expression = case_when(log2FoldChange >= 1 & padj <= 0.05 ~ "Up-regulated",
                           log2FoldChange <= -1 & padj <= 0.05 ~ "Down-regulated",
                           TRUE ~ "Unchanged")
  ) %>%
  arrange(desc(abs(log2FoldChange)))


display_n <- 4
display_genes <- bind_rows(
  vol %>% 
    filter(Expression == 'Up-regulated') %>% 
    head(display_n),
  vol %>% 
    filter(Expression == 'Down-regulated') %>% 
    head(display_n),
  vol %>%
    filter(Genes %in% c('BHIKHARI_LTR', 'BHIKHARI_I-int'))
)


ggplot(vol, aes(x=log2FoldChange, y=-log(padj,10))) +
  geom_point(aes(color = Expression), size = 2) +
  xlab(expression("log"[2]*"FC")) + 
  ylab(expression("-log"[10]*"FDR")) +
  xlim(-5, 5) +
  scale_color_manual(values = c("#E69F00", "gray50", "#F2CC85")) +
  guides(colour = guide_legend(override.aes = list(size=5.5))) +
  geom_text_repel(data = display_genes, 
                  mapping = aes(x=log2FoldChange, y=-log(padj,10), label = Genes),
                  size=3.5,
                  force=15,
                  max.overlaps=20) +
  theme(axis.title.x = element_text(size = 20,face="bold"), 
        axis.title.y = element_text(size = 20,face="bold"),
        axis.text=element_text(size=20),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        axis.line = element_line(colour = "black"))
