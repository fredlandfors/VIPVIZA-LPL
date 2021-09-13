# Figure 2A: Revised manuscript ----
check_packages(
  bioc_packages = c(""),
  cran_packages = c("ggplot2")
)

# Text size ----
forest_text_x <- 3
forest_text_y <- 5

# Forest plot ----
forest_data <- merge(
  sampleMetadata,#[c("ID", "ITC")],
  missData.dataMatrix,
  by = "ID"
)

## Subset vars from heatmap ----
forest_data <- forest_data[c("ID", "ITC", "Serum_TG", heatmap.vars)]

## Scale all vars except ID and ITC ----
forest_data_2 <- data.frame(
  forest_data["ITC"],
  sapply(forest_data[, -c(1, 2)], scale)
)

## Calculate regressions ----
forest_table <- calc_forest(
  forest_data_2,
  conf_level = 1 - 0.05 / 22
)[-1, ]

## Get names and reorder ----
forest_table_ord <- forest_table
forest_table_ord$plot_order <- seq(1, nrow(forest_table))
forest_table_ord$x_labels <- names3$fin.names

## Draw forest plot ----
forest <- ggplot(forest_table_ord) +
  ggtitle("Effect estimates:\n Plasma LPL activity vs. NMR lipid parameters") +
  geom_pointrange(
    aes(
      x = reorder(x_labels, plot_order),
      y = beta,
      ymin = lower95,
      ymax = higher95
    ),
    size = 0.3
  ) +
  geom_hline(yintercept = 0, lty = 2) +
  xlab("") +
  scale_x_discrete(position = "bottom") +
  ylab("LPL activity (\U00B5J) per 1-SD") +
  scale_y_continuous(
    position = "left",
    limits = c(-0.4, 0.4)
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(
      color = "black", size = 6, family = "Helvetica", face = "bold", 
      hjust = 0.5
    ),
    legend.position = "none",
    axis.title.y = element_text(family = "Helvetica", size = forest_text_y, face = "bold"),
    axis.text.x = element_text(family = "Helvetica", size = forest_text_x, face = "bold", colour = "black", angle = 90, vjust = 0.1),
    axis.text.y = element_text(family = "Helvetica", size = forest_text_y, face = "plain", colour = "black")
  ) +
  guides(x = guide_axis(angle = 45))
