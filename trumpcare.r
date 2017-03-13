## CBO Estimates viz
## Dumbell geom and theme courtesty @hrbrmstr

library(tidyverse)
library(ggalt)
library(hrbrthemes)
library(Cairo)

party.colors <- c("#2E74C0", "#CB454A")

data <- read_csv("data/cbo-table4.csv")

data_s <- dplyr::select(data, Law:Age, Net)
data_w <- spread(data_s, Law, Net)
data_w$Dummy <- c("Current Law", "AHCA")


cairo_pdf(file="figures/cbo.pdf", height = 6, width = 6)
p <- ggplot(data_w, aes(y=Age, x=Current, xend=AHCA, fill = Dummy))

p + geom_dumbbell(size=3, color="#e3e2e1",
                colour_x = party.colors[1], colour_xend = party.colors[2],
                dot_guide=TRUE, dot_guide_size=0.25) +
    labs(x="Net Premium Paid",
         y=NULL,
         fill = "",
         title="CBO Estimates of Net Premium Payments\nUnder Current Law and the AHCA",
         caption="Source: CBO Estimates, March 13th 2017, Table 4. Figure: Kieran Healy.") +
  theme_ipsum(grid="X") +
    theme(panel.grid.major.x=element_line(size=0.05),
          legend.position = "top") +
    facet_wrap(~ Income, ncol = 1) +
    scale_x_continuous(labels = scales::dollar,
                       breaks = c(0, 5000, 10000, 15000)) +
    guides(fill = guide_legend(override.aes = list(color = rev(party.colors))))
dev.off()
