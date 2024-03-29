# Figure 1
check_packages(
  bioc_packages = c("ComplexHeatmap"),
  cran_packages = c("Hmisc", "cowplot", "ggplot2")
)
library(cowplot)

# Get data ----
heatmap_data <- merge(
  sampleMetadata[c("ID", "ITC")],
  missData.dataMatrix,
  by = "ID"
)

## Remove redundant or irrelevant variables ----
heatmap_data <- heatmap_data[
  !names(heatmap_data) %in%
    c(
      "ITC", "ID", "XXL_VLDL_L", "XXL_VLDL_C", "XL_VLDL_L", "XL_VLDL_C",
      "L_VLDL_L", "L_VLDL_C", "M_VLDL_L", "M_VLDL_C",
      "S_VLDL_L", "S_VLDL_C", "XS_VLDL_L", "XS_VLDL_C",
      "IDL_L", "IDL_C", "L_LDL_L", "L_LDL_C",
      "L_LDL_L", "L_LDL_C", "M_LDL_L", "M_LDL_C",
      "S_LDL_L", "S_LDL_C", "XL_HDL_L", "XL_HDL_C",
      "XL_HDL_L", "XL_HDL_C", "L_HDL_L", "L_HDL_C",
      "M_HDL_L", "M_HDL_C", "S_HDL_L", "S_HDL_C", "Serum_C", "VLDL_C",
      "Remnant_C", "LDL_C", "HDL_C", "HDL2_C", "HDL3_C", "EstC", "FreeC",
      "Serum_TG", 
      "VLDL_TG",
      "LDL_TG", "HDL_TG", "TotCho", "ApoA1",
      "ApoB", "ApoB_ApoA1"
    )
]

## Correlations ----
cor2 <- Hmisc::rcorr(
  as.matrix(heatmap_data),
  type = "pearson"
)
cor2 <- cor2$r

## Annotations ----
library(ComplexHeatmap)

row_text_22 <- c(
  ">75nm", rep("", 4),
  "~64nm", rep("", 4),
  "~53.6nm", rep("", 4),
  "~44.5nm", rep("", 4),
  "~36.8nm", rep("", 4),
  "~31.3nm", rep("", 4),
  "~28.6nm", rep("", 4),
  "~25.5nm", rep("", 4),
  "~23nm", rep("", 4),
  "~18.7nm", rep("", 4),
  "~14.3nm", rep("", 4),
  "~12.1nm", rep("", 4),
  "~10.9nm", rep("", 4),
  "~8.7nm", rep("", 4),
  "Avg. diam", rep("", 2),
  "PL", rep("", 3),
  "FA", rep("", 15)
)

row_annotation_22 <- rowAnnotation(
  anno1 = anno_text(
    row_text_22,
    which = "row",
    gp = gpar(fontsize = 6, fontface = "plain", fontfamily = "Helvetica"),
  )
)

col_labels_22 <- c("VLDL", "IDL", "LDL", "HDL")

col_annotation_22 <- columnAnnotation(
  anno3 = anno_text(
    row_text_22,
    which = "row",
    gp = gpar(fontsize = 6, fontface = "plain", fontfamily = "Helvetica"),
  )
)

##New names ----
rnames1 <- data.frame(variableName = names(heatmap_data))
colnames1 <- seq(1, ncol(heatmap_data))

rnames2 <- base::merge(
  rnames1,
  variableMetadata,
  by.x = "variableName",
  sort = FALSE
)

rnames3 <- mapply(
  function(x, y) {paste0(x, ". ", y)},
  colnames1,
  rnames2$alternativeName1
)

rownames(cor2) <- rnames3
colnames(cor2) <- rnames3

# Draw heatmap ----
col_fun2 = circlize::colorRamp2(c(-1, 0, 1), c("blue", "white", "red"), transparency = 0)

heatmap_22 <- Heatmap(
  cor2,
  cluster_rows = FALSE,
  cluster_columns = FALSE,
  
  row_split = c(rep("1", 70), rep("2", 3), rep("3", 20)),
  column_split = c(rep("1", 70), rep("2", 3), rep("3", 20)),
  
  row_names_gp = gpar(fontsize = 5, fontface = "bold", fontfamily = "Helvetica"),
  row_names_side = "right",
  column_names_gp = gpar(fontsize = 5, fontface = "bold", fontfamily = "Helvetica"),
  column_names_side = "top",
  
  width = unit(5.2, "inches"),
  height = unit(5.2, "inches"),
  
  left_annotation = row_annotation_22,
  
  col = col_fun2,
  
  ## Heatmap legend  ----
  show_heatmap_legend = TRUE,
  heatmap_legend_param = list(
    at = c(-1, -0.5, 0, 0.5, 1),
    title_position = "topcenter",
    title = "Pearsons's correlation coefficient (r)",
    title_gp = gpar(fontsize = 6, fontface = "bold", fontfamily = "Helvetica"),
    labels_gp = gpar(fontsize = 6, fontface = "plain", fontfamily = "Helvetica"),
    direction = "horizontal",
    legend_width = unit(2, "inches"),
    legend_height = unit(0.5, "inches")
  )
)

# Forest plot ----
forest_data <- merge(
  sampleMetadata,#[c("ID", "ITC")],
  missData.dataMatrix,
  by = "ID"
)

## Subset vars from heatmap ----
forest_data <- forest_data[c("ID", "ITC", names(heatmap_data))]

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

## Draw forest plot ----
forest_table_ord <- forest_table
forest_table_ord$plot_order <- seq(1, nrow(forest_table))
forest_table_ord$x_labels <- sapply(
  forest_table_ord$plot_order, 
  function(x) {paste0(x, ".")}
)

forest_22 <- ggplot(forest_table_ord) +
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
  theme_classic() +
  theme(
    legend.position = "none",
    axis.title.y = element_text(family = "Helvetica", size = 6, face = "bold"),
    axis.text.x = element_text(family = "Helvetica", size = 6, face = "bold", colour = "black", angle = 90, vjust = 0.1),
    axis.text.y = element_text(family = "Helvetica", size = 6, face = "plain", colour = "black")
  )

# Variance explained barplot ----
forest_table_ord$R2 <- forest_table_ord$R2 * 100

barvar_22 <- ggplot(forest_table_ord) +
  geom_hline(yintercept = 50, lty = 2) +
  
  geom_bar(
    aes(
      x = reorder(x_labels, plot_order),
      y = R2
    ),
    stat = "identity",
    colour = "black",
    fill = "white"
  ) +
  
  xlab("") +
  scale_x_discrete(position = "bottom") +
  ylab("Variance explained (R\U00B2 %)") +
  scale_y_continuous(
    position = "left",
    limits = c(0, 100)
  ) +
  theme_classic() +
  theme(
    legend.position = "none",
    axis.title.y = element_text(family = "Helvetica", size = 6, face = "bold"),
    axis.text.x = element_text(family = "Helvetica", size = 6, face = "bold", colour = "black", angle = 90, vjust = 0.1),
    axis.text.y = element_text(family = "Helvetica", size = 6, face = "plain", colour = "black")
  )

# Merge plots ----
grob <- grid.grabExpr(
  draw(heatmap_22, heatmap_legend_side = "bottom")
)

figure_22 <- plot_grid(
  plot_grid(NULL, forest_22, rel_widths = c(4, 96), nrow  = 1),
  plot_grid(NULL, barvar_22, rel_widths = c(4, 96), nrow = 1),
  grob,
  ncol = 1,
  rel_heights = rev(c(68, 16, 16)),
  #hjust = c(-2, 0, 0),
  #vjust = c(1, -1, 0),
  labels = c("A.", "B.", "C.")
)

# Save plot ----
cowplot::save_plot(
  "./out/figure_1.pdf",
  figure_22,
  base_height = 10,
  base_width = 7.1,
  dpi = 1000
)

