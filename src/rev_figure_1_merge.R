# Figure 2: Revised manuscript ----
check_packages(
  bioc_packages = c(""),
  cran_packages = c("cowplot", "ggplot2")
)

## Draw heatmap grob ----
### params ----
stg.col <- "#FAEFD1"
vldl.col <- "#00A08A"
idl.col <- "#F98400"
ldl.col <- "#F2AD00"
hdl.col <- "#5BBCD6"
diam.col <- "#D5D5D3"
pl.col <- "#A2A475"
ffa.col <- "#81A88D"
text.gpar <- gpar(fontsize = 4, fontface = "bold", fontfamily = "Helvetica")
text.gpar.2 <- gpar(col = "black", fontsize = 4, fontface = "italic", fontfamily = "Helvetica")
text.gpar.3 <- gpar(col = "black", fontsize = 4, fontface = "italic", fontfamily = "Helvetica")

grob <- grid.grabExpr(
  draw(nmr.heatmap, heatmap_legend_side = "bottom") +
    ### stg ----
    decorate_row_names("f5", slice = 1, {
      grid.rect(gp = gpar(fill = stg.col), x = unit(4.25, "mm"),
                width = unit(4, "mm"))
      grid.text(
        label = "Tot.",
        gp = gpar(fontsize = 3.5, fontface = "bold", fontfamily = "Helvetica"), 
        x = unit(4.25, "mm")
      )
    }) +
    decorate_column_names("f5", slice = 1, {
      grid.rect(gp = gpar(fill = stg.col), y = unit(-2.5, "mm"),
                height = unit(3.25, "mm"))
      grid.text(
        label = "Tot.",
        gp = gpar(fontsize = 3.5, fontface = "bold", fontfamily = "Helvetica"), 
        y = unit(-2.5, "mm"),
        rot = 90
      )
    }) +
    ### vldl ----
    decorate_row_names("f5", slice = 2, {
      grid.rect(gp = gpar(fill = vldl.col), x = unit(4.25, "mm"),
                width = unit(4, "mm"))
      grid.text(
        label = "VLDL",
        gp = text.gpar, 
        x = unit(4.25, "mm"),
        rot = 90
      )
      grid.text(
        label = ">75 nm",
        gp = text.gpar.3,
        x = unit(-1, "mm"),
        rot = 90
      )
      }) +
    decorate_row_names("f5", slice = 3, {
      grid.rect(gp = gpar(fill = vldl.col), x = unit(4.25, "mm"),
                width = unit(4, "mm"))
      grid.text(
        label = "VLDL",
        gp = text.gpar, 
        x = unit(4.25, "mm"),
        rot = 90
      )
      grid.text(
        label = "~64 nm",
        gp = text.gpar.3,
        x = unit(-2, "mm"),
        rot = 90
      )
    }) +
    decorate_row_names("f5", slice = 4, {
      grid.rect(gp = gpar(fill = vldl.col), x = unit(4.25, "mm"),
                width = unit(4, "mm"))
      grid.text(
        label = "VLDL",
        gp = text.gpar, 
        x = unit(4.25, "mm"),
        rot = 90
      )
      grid.text(
        label = "~53.6 nm",
        gp = text.gpar.3,
        x = unit(-1, "mm"),
        rot = 90
      )
    }) +
    decorate_row_names("f5", slice = 5, {
      grid.rect(gp = gpar(fill = vldl.col), x = unit(4.25, "mm"),
                width = unit(4, "mm"))
      grid.text(
        label = "VLDL",
        gp = text.gpar, 
        x = unit(4.25, "mm"),
        rot = 90
      )
      grid.text(
        label = "~44.5 nm",
        gp = text.gpar.3,
        x = unit(-2, "mm"),
        rot = 90
      )
    }) +
    decorate_row_names("f5", slice = 6, {
      grid.rect(gp = gpar(fill = vldl.col), x = unit(4.25, "mm"),
                width = unit(4, "mm"))
      grid.text(
        label = "VLDL",
        gp = text.gpar, 
        x = unit(4.25, "mm"),
        rot = 90
      )
      grid.text(
        label = "~36.8 nm",
        gp = text.gpar.3,
        x = unit(-1, "mm"),
        rot = 90
      )
    }) +
    decorate_row_names("f5", slice = 7, {
      grid.rect(gp = gpar(fill = vldl.col), x = unit(4.25, "mm"),
                width = unit(4, "mm"))
      grid.text(
        label = "VLDL",
        gp = text.gpar, 
        x = unit(4.25, "mm"),
        rot = 90
      )
      grid.text(
        label = "~31.3 nm",
        gp = text.gpar.3,
        x = unit(-2, "mm"),
        rot = 90
      )
    }) +
    decorate_column_names("f5", slice = 2, {
      grid.rect(gp = gpar(fill = vldl.col), y = unit(-2.5, "mm"),
                height = unit(3.25, "mm"))
      grid.text(
        label = "VLDL",
        gp = text.gpar, 
        y = unit(-2.5, "mm")
      )
      grid.text(
        label = ">75 nm",
        gp = text.gpar.2,
        y = unit(3, "mm"),
        rot = 0
      )
    }) +
    decorate_column_names("f5", slice = 3, {
      grid.rect(gp = gpar(fill = vldl.col), y = unit(-2.5, "mm"),
                height = unit(3.25, "mm"))
      grid.text(
        label = "VLDL",
        gp = text.gpar, 
        y = unit(-2.5, "mm")
      )
      grid.text(
        label = "~64 nm",
        gp = text.gpar.2,
        y = unit(3, "mm"),
        rot = 0
      )
    }) +
    decorate_column_names("f5", slice = 4, {
      grid.rect(gp = gpar(fill = vldl.col), y = unit(-2.5, "mm"),
                height = unit(3.25, "mm"))
      grid.text(
        label = "VLDL",
        gp = text.gpar, 
        y = unit(-2.5, "mm")
      )
      grid.text(
        label = "~53.6 nm",
        gp = text.gpar.2,
        y = unit(3, "mm"),
        rot = 0
      )
    }) +
    decorate_column_names("f5", slice = 5, {
      grid.rect(gp = gpar(fill = vldl.col), y = unit(-2.5, "mm"),
                height = unit(3.25, "mm"))
      grid.text(
        label = "VLDL",
        gp = text.gpar, 
        y = unit(-2.5, "mm")
      )
      grid.text(
        label = "~44.5 nm",
        gp = text.gpar.2,
        y = unit(3, "mm"),
        rot = 0
      )
    }) +
    decorate_column_names("f5", slice = 6, {
      grid.rect(gp = gpar(fill = vldl.col), y = unit(-2.5, "mm"),
                height = unit(3.25, "mm"))
      grid.text(
        label = "VLDL",
        gp = text.gpar, 
        y = unit(-2.5, "mm")
      )
      grid.text(
        label = "~36.8 nm",
        gp = text.gpar.2,
        y = unit(3, "mm"),
        rot = 0
      )
    }) +
    decorate_column_names("f5", slice = 7, {
      grid.rect(gp = gpar(fill = vldl.col), y = unit(-2.5, "mm"),
                height = unit(3.25, "mm"))
      grid.text(
        label = "VLDL",
        gp = text.gpar, 
        y = unit(-2.5, "mm")
      )
      grid.text(
        label = "~31.3 nm",
        gp = text.gpar.2,
        y = unit(3, "mm"),
        rot = 0
      )
    }) +
    ### idl ----
    decorate_row_names("f5", slice = 8, {
      grid.rect(gp = gpar(fill = idl.col), x = unit(4.25, "mm"),
                width = unit(4, "mm"))
      grid.text(
        label = "IDL",
        gp = text.gpar, 
        x = unit(4.25, "mm"),
        rot = 90
      )
      grid.text(
        label = "~28.6 nm",
        gp = text.gpar.3,
        x = unit(-1, "mm"),
        rot = 90
      )
    }) +
    decorate_column_names("f5", slice = 8, {
      grid.rect(gp = gpar(fill = idl.col), y = unit(-2.5, "mm"),
                height = unit(3.25, "mm"))
      grid.text(
        label = "IDL",
        gp = text.gpar, 
        y = unit(-2.5, "mm")
      )
      grid.text(
        label = "~28.6 nm",
        gp = text.gpar.2,
        y = unit(3, "mm"),
        rot = 0
      )
    }) +
    ### ldl ----
    decorate_row_names("f5", slice = 9, {
      grid.rect(gp = gpar(fill = ldl.col), x = unit(4.25, "mm"),
                width = unit(4, "mm"))
      grid.text(
        label = "LDL",
        gp = text.gpar, 
        x = unit(4.25, "mm"),
        rot = 90
      )
      grid.text(
        label = "~25.5 nm",
        gp = text.gpar.3,
        x = unit(-2, "mm"),
        rot = 90
      )
    }) +
    decorate_row_names("f5", slice = 10, {
      grid.rect(gp = gpar(fill = ldl.col), x = unit(4.25, "mm"),
                width = unit(4, "mm"))
      grid.text(
        label = "LDL",
        gp = text.gpar, 
        x = unit(4.25, "mm"),
        rot = 90
      )
      grid.text(
        label = "~23 nm",
        gp = text.gpar.3,
        x = unit(-1, "mm"),
        rot = 90
      )
    }) +
    decorate_row_names("f5", slice = 11, {
      grid.rect(gp = gpar(fill = ldl.col), x = unit(4.25, "mm"),
                width = unit(4, "mm")) 
      grid.text(
        label = "LDL",
        gp = text.gpar, 
        x = unit(4.25, "mm"),
        rot = 90
      )
      grid.text(
        label = "~18.7 nm",
        gp = text.gpar.3,
        x = unit(-2, "mm"),
        rot = 90
      )
    }) +
    decorate_column_names("f5", slice = 9, {
      grid.rect(gp = gpar(fill = ldl.col), y = unit(-2.5, "mm"),
                height = unit(3.25, "mm"))
      grid.text(
        label = "LDL",
        gp = text.gpar, 
        y = unit(-2.5, "mm")
      )
      grid.text(
        label = "~25.5 nm",
        gp = text.gpar.2,
        y = unit(3, "mm"),
        rot = 0
      )
    }) +
    decorate_column_names("f5", slice = 10, {
      grid.rect(gp = gpar(fill = ldl.col), y = unit(-2.5, "mm"),
                height = unit(3.25, "mm"))
      grid.text(
        label = "LDL",
        gp = text.gpar, 
        y = unit(-2.5, "mm")
      )
      grid.text(
        label = "~23 nm",
        gp = text.gpar.2,
        y = unit(3, "mm"),
        rot = 0
      )
    }) +
    decorate_column_names("f5", slice = 11, {
      grid.rect(gp = gpar(fill = ldl.col), y = unit(-2.5, "mm"),
                height = unit(3.25, "mm"))
      grid.text(
        label = "LDL",
        gp = text.gpar, 
        y = unit(-2.5, "mm")
      )
      grid.text(
        label = "~18.7 nm",
        gp = text.gpar.2,
        y = unit(3, "mm"),
        rot = 0
      )
    }) +
    ### hdl ----
    decorate_row_names("f5", slice = 12, {
      grid.rect(gp = gpar(fill = hdl.col), x = unit(4.25, "mm"),
                width = unit(4, "mm"))
      grid.text(
        label = "HDL",
        gp = text.gpar, 
        x = unit(4.25, "mm"),
        rot = 90
      )
      grid.text(
        label = "~14.3 nm",
        gp = text.gpar.3,
        x = unit(-1, "mm"),
        rot = 90
      )
    }) +
    decorate_row_names("f5", slice = 13, {
      grid.rect(gp = gpar(fill = hdl.col), x = unit(4.25, "mm"),
                width = unit(4, "mm")) 
      grid.text(
        label = "HDL",
        gp = text.gpar, 
        x = unit(4.25, "mm"),
        rot = 90
      )
      grid.text(
        label = "~12.1 nm",
        gp = text.gpar.3,
        x = unit(-2, "mm"),
        rot = 90
      )
    }) +
    decorate_row_names("f5", slice = 14, {
      grid.rect(gp = gpar(fill = hdl.col), x = unit(4.25, "mm"),
                width = unit(4, "mm")) 
      grid.text(
        label = "HDL",
        gp = text.gpar, 
        x = unit(4.25, "mm"),
        rot = 90
      )
      grid.text(
        label = "~10.9 nm",
        gp = text.gpar.3,
        x = unit(-1, "mm"),
        rot = 90
      )
    }) +
    decorate_row_names("f5", slice = 15, {
      grid.rect(gp = gpar(fill = hdl.col), x = unit(4.25, "mm"),
                width = unit(4, "mm")) 
      grid.text(
        label = "HDL",
        gp = text.gpar, 
        x = unit(4.25, "mm"),
        rot = 90
      )
      grid.text(
        label = "~8.7 nm",
        gp = text.gpar.3,
        x = unit(-2, "mm"),
        rot = 90
      )
    }) +
    decorate_column_names("f5", slice = 12, {
      grid.rect(gp = gpar(fill = hdl.col), y = unit(-2.5, "mm"),
                height = unit(3.25, "mm"))
      grid.text(
        label = "HDL",
        gp = text.gpar, 
        y = unit(-2.5, "mm")
      )
      grid.text(
        label = "~14.3 nm",
        gp = text.gpar.2,
        y = unit(3, "mm"),
        rot = 0
      )
    }) +
    decorate_column_names("f5", slice = 13, {
      grid.rect(gp = gpar(fill = hdl.col), y = unit(-2.5, "mm"),
                height = unit(3.25, "mm"))
      grid.text(
        label = "HDL",
        gp = text.gpar, 
        y = unit(-2.5, "mm")
      )
      grid.text(
        label = "~12.1 nm",
        gp = text.gpar.2,
        y = unit(3, "mm"),
        rot = 0
      )
    }) +
    decorate_column_names("f5", slice = 14, {
      grid.rect(gp = gpar(fill = hdl.col), y = unit(-2.5, "mm"),
                height = unit(3.25, "mm"))
      grid.text(
        label = "HDL",
        gp = text.gpar, 
        y = unit(-2.5, "mm")
      )
      grid.text(
        label = "~10.9 nm",
        gp = text.gpar.2,
        y = unit(3, "mm"),
        rot = 0
      )
    }) +
    decorate_column_names("f5", slice = 15, {
      grid.rect(gp = gpar(fill = hdl.col), y = unit(-2.5, "mm"),
                height = unit(3.25, "mm"))
      grid.text(
        label = "HDL",
        gp = text.gpar, 
        y = unit(-2.5, "mm")
      )
      grid.text(
        label = "~8.7 nm",
        gp = text.gpar.2,
        y = unit(3, "mm"),
        rot = 0
      )
    }) +
    ### diam ----
    decorate_row_names("f5", slice = 16, {
      grid.rect(gp = gpar(fill = diam.col), x = unit(4.25, "mm"),
                width = unit(4, "mm"))
      grid.text(
        label = "Diam",
        gp = text.gpar, 
        x = unit(4.25, "mm"),
        rot = 0
      )
    }) +
    decorate_column_names("f5", slice = 16, {
      grid.rect(gp = gpar(fill = diam.col), y = unit(-2.5, "mm"),
                height = unit(3.25, "mm"))
      grid.text(
        label = "Diam.",
        gp = text.gpar, 
        y = unit(-2.5, "mm")
      )
    }) +
    ### pl ----
    decorate_row_names("f5", slice = 17, {
      grid.rect(gp = gpar(fill = pl.col), x = unit(4.25, "mm"),
                width = unit(4, "mm"))
      grid.text(
        label = "PL",
        gp = text.gpar, 
        x = unit(4.25, "mm"),
        rot = 90
      )
    }) +
    decorate_column_names("f5", slice = 17, {
      grid.rect(gp = gpar(fill = pl.col), y = unit(-2.5, "mm"),
                height = unit(3.25, "mm"))
      grid.text(
        label = "PL",
        gp = text.gpar, 
        y = unit(-2.5, "mm")
      )
    }) +
    ### ffa ----
    decorate_row_names("f5", slice = 18, {
      grid.rect(gp = gpar(fill = ffa.col), x = unit(4.25, "mm"),
                width = unit(4, "mm"))
      grid.text(
        label = "FFA",
        gp = text.gpar, 
        x = unit(4.25, "mm"),
        rot = 90
      )
    }) +
    decorate_column_names("f5", slice = 18, {
      grid.rect(gp = gpar(fill = ffa.col), y = unit(-2.5, "mm"),
                height = unit(3.25, "mm"))
      grid.text(
        label = "FFA",
        gp = text.gpar, 
        y = unit(-2.5, "mm")
      )
    }) 
)

## Plot grid ----
figure_2 <- plot_grid(
  #forest,
  plot_grid(NULL, forest, NULL, rel_widths = c(2.55, 94.75, 3.45), nrow  = 1),
  #violin,
  plot_grid(NULL, violin, NULL, rel_widths = c(2.80, 93.75, 3.45), nrow = 1),
  #heatmap,
  plot_grid(NULL, grob, NULL, 
            NULL, NULL, NULL,
            rel_widths = c(0, 100, 0),
            rel_heights = c(90, 10),
            nrow = 2),
  ncol = 1,
  rel_heights = rev(c(60, 20, 20)),
  labels = c("A.", "B.", "C.")
)

## Save plot to pdf ----
cowplot::save_plot(
  "./out/figure_1.pdf",
  figure_2,
  base_height = 10,
  base_width = 7.1,
  dpi = 1000
)
