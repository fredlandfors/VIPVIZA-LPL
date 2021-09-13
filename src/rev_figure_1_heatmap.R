# Figure 2C: Revised manuscript ----
check_packages(
  bioc_packages = c("ComplexHeatmap"),
  cran_packages = c("Hmisc", "cowplot", "ggplot2")
)
library(cowplot)
library(ComplexHeatmap)

## Corr. function ----

## 2A: Heatmap ----
f5 <- merge(
  sampleMetadata[c("ID", "ITC")],
  missData.dataMatrix,
  by = "ID"
)

### Subset data ----
heatmap.vars <- names(f5)[
  !names(f5) %in% c(
  "ITC", "ID",
  "XXL_VLDL_L", "XXL_VLDL_C", "XL_VLDL_L", "XL_VLDL_C", "L_VLDL_L", "L_VLDL_C",
  "M_VLDL_L", "M_VLDL_C", "S_VLDL_L", "S_VLDL_C", "XS_VLDL_L", "XS_VLDL_C",
  "IDL_L", "IDL_C",
  "L_LDL_L", "L_LDL_C", "L_LDL_L", "L_LDL_C", "M_LDL_L", "M_LDL_C", "S_LDL_L",
  "S_LDL_C",
  "XL_HDL_L", "XL_HDL_C", "XL_HDL_L", "XL_HDL_C", "L_HDL_L", "L_HDL_C",
  "M_HDL_L", "M_HDL_C", "S_HDL_L", "S_HDL_C",
  "Serum_C", "VLDL_C", "Remnant_C", "LDL_C", "HDL_C", "HDL2_C", "HDL3_C",
  "EstC", "FreeC", "Serum_TG", "TotCho",
  "VLDL_TG", "LDL_TG", "HDL_TG",
  "ApoA1", "ApoB", "ApoB_ApoA1"
  )
]
f5 <- f5[c("Serum_TG", heatmap.vars)]

### Calc correlations ----
f5.cor <- Hmisc::rcorr(
  as.matrix(f5),
  type = "spearman"
)
f5.cor <- f5.cor$r

### Make new names ----
colnames1 <- seq(1, ncol(f5))
rnames1 <- data.frame(variableName = names(f5))
rnames2 <- base::merge(
  rnames1,
  variableMetadata,
  by.x = "variableName",
  sort = FALSE
)
# rnames3 <- mapply(
#   function(x, y) {paste0(x, ". ", y)},
#   colnames1,
#   rnames2$alternativeName1
# )
rnames3 <- sapply(
  colnames1,
  function(x) {paste0(x, ".")}
)
rownames(f5.cor) <- rnames3
colnames(f5.cor) <- rnames3

### Define color function ----
col_fun <- circlize::colorRamp2(c(-1, 0, 1), c("blue", "white", "red"), transparency = 0)

### Heatmap ----
#### Legend ----
nmr.legend <- list(
  at = c(-1, -0.5, 0, 0.5, 1),
  title_position = "topcenter",
  title = "Spearman's rank correlation coefficient (rho)",
  title_gp = gpar(fontsize = 5, fontface = "bold", fontfamily = "Helvetica"),
  labels_gp = gpar(fontsize = 4, fontface = "plain", fontfamily = "Helvetica"),
  direction = "horizontal",
  legend_width = unit(40, "mm"),
  grid_height = unit(1, "mm")
)

####  Annotation-----
size.split <- c(
  1,
  rep(2, 5),
  rep(3, 5),
  rep(4, 5),
  rep(5, 5),
  rep(6, 5),
  rep(7, 5),
  rep(8, 5),
  rep(9, 5),
  rep(10, 5),
  rep(11, 5),
  rep(12, 5),
  rep(13, 5),
  rep(14, 5),
  rep(15, 5),
  rep(16, 3),
  rep(17, 4),
  rep(18, 16)
)
size.labels <- c(
  "-",
  "XXL",
  "XL",
  "L",
  "M",
  "S", 
  "XS",
  "-", 
  "L",
  "M",
  "S", 
  "XL",
  "L",
  "M",
  "S", 
  "-",
  "-",
  "-"  
)
anno.class <- c(
  "Tot.TG",
  rep("VLDL", 30),
  rep("IDL", 5),
  rep("LDL", 15),
  rep("HDL", 20),
  rep("Avg.", 3),
  rep("Phospholipids", 4),
  rep("Fatty acids", 16)
)
anno1 <- rowAnnotation(
  empty1 = anno_empty(border = FALSE, width = unit(3.5, "mm")),
  foo = anno_block(
    gp = gpar(fill = "white"),
    labels = size.labels, 
    labels_gp = gpar(col = "black", fontsize = 4, fontface = "bold", fontfamily = "Helvetica"),
    width = unit(3.5, "mm")
  )
)
anno2 <- columnAnnotation(
  empty2 = anno_empty(border = FALSE, height = unit(3.5, "mm")),
  foo = anno_block(
    gp = gpar(fill = "white"),
    labels = size.labels, 
    labels_gp = gpar(col = "black", fontsize = 4, fontface = "bold", fontfamily = "Helvetica"),
    height = unit(3.5, "mm")
  )
)
anno3.text <- c(
  "Tot.TG",
  rep(c("P", "PL", "CE", "FC", "TG"), 14),
  "VLDL-D", "LDL-D", "HDL-D",
  rnames2$alternativeName1[75:94]
)
anno3 <- rowAnnotation(
  lip1 = anno_text(
    x = anno3.text,
    which = "row",
    gp = gpar(col = "black", fontsize = 3, fontface = "bold", fontfamily = "Helvetica")
  )
)
anno4.text <- c(
  rep("", 3),
  ">75 nm", rep("", 4),
  "~64 nm", rep("", 4),
  "~53.6 nm", rep("", 4),
  "~44.5 nm", rep("", 4),
  "~36.8 nm", rep("", 4),
  "~31.3 nm", rep("", 4),
  "~28.6 nm", rep("", 4),
  "~25.5 nm", rep("", 4),
  "~23 nm", rep("", 4),
  "~18.7 nm", rep("", 4),
  "~14.3 nm", rep("", 4),
  "~12.1 nm", rep("", 4),
  "~10.9 nm", rep("", 4),
  "~8.7 nm", rep("", 3),
  "", rep("", 2),
  "", rep("", 9),
  "", rep("", 8)
)
anno4 <- columnAnnotation(
  dist1 = anno_text(
    x = anno4.text,
    which = "column",
    gp = gpar(col = "black", fontsize = 3.5, fontface = "bold", fontfamily = "Helvetica"),
    rot = 0,
    just = "centre"
  )
)
#OBS!
anno4 <- columnAnnotation(
  dist1 = anno_text(
    x = anno3.text, 
    which = "column",
    gp = gpar(col = "black", fontsize = 3, fontface = "bold", fontfamily = "Helvetica"),
    rot = 90,
    just = c(1, 0)
  )
)

####  Main -----
nmr.heatmap <- Heatmap(
  f5.cor,
  name = "f5",
  cluster_rows = FALSE,
  cluster_columns = FALSE,
  row_split = size.split,
  column_split = size.split,
  border = TRUE,
  row_gap = unit(0, "mm"),
  column_gap = unit(0, "mm"), 
  row_names_gp = gpar(fontsize = 3, fontface = "bold", fontfamily = "Helvetica"),
  row_names_side = "left",
  column_names_gp = gpar(fontsize = 3, fontface = "bold", fontfamily = "Helvetica"),
  column_names_side = "top",
  row_title = NULL,
  column_title = "Collinearity estimates: NMR lipid parameters",
  column_title_gp = gpar(fontsize = 6, fontface = "bold", fontfamily = "Helvetica"),
  width = unit(6.2, "inches"),
  height = unit(4.5, "inches"),
  left_annotation = anno1,
  top_annotation = anno2,
  right_annotation = anno3,
  bottom_annotation = anno4,
  col = col_fun,
  show_heatmap_legend = TRUE,
  heatmap_legend_param = nmr.legend
)
