# Figure 3: Revised manuscript ----
check_packages(
  bioc_packages = c(""),
  cran_packages = c("ggstatsplot", "cowplot", "ggplot2")
)

# Get data (Plot order were changed, therefore named "fig_1...") ----
fig_1_data <- sampleMetadata

# Wrangle data ----
fig_1_data$APOA5_log <- log2(fig_1_data$APOA5)
fig_1_data$APOC1_log <- log2(fig_1_data$APOC1)
fig_1_data$APOC2_log <- log2(fig_1_data$APOC2)
fig_1_data$APOC3_log <- log2(fig_1_data$APOC3)
fig_1_data$ANGPTL3_log <- log2(fig_1_data$ANGPTL3)
fig_1_data$ANGPTL4_log <- log2(fig_1_data$ANGPTL4)
fig_1_data$ANGPTL8_log <- log2(fig_1_data$ANGPTL8)

fig_1_data$APOC1_APOC2 <- log2(fig_1_data$APOC1 / fig_1_data$APOC2)
fig_1_data$APOC3_APOC2 <- log2(fig_1_data$APOC3 / fig_1_data$APOC2)

# Graphical parameters ----
fig_1_linesize <- 0.5
fig_1_pointsize <- 1

# Define multiple comparisons correction ----
p_correct_n <- 9

# Define statistical tests function ----
calc_fig_1_test <-  function(df, x, y, x_unit = "1-X") {
  form1 <- formula(paste0(y, " ~ ", x))
  fit1 <- lm(form1, data = df)
  sum1 <- summary(fit1)
  
  options(scipen = 3, digits = 4)
  
  string1 <- paste0(
    "Effect = ",
    round(sum1$coefficients[x, "Estimate"], 4),
    " \U00B5J/s per ", x_unit,
    ",\nadj. P = ",
    round(
      p.adjust(
        sum1$coefficients[x, "Pr(>|t|)"],
        method = "bonferroni",
        n = p_correct_n
      ),
     2
    ),
    ", R\U00B2 = ",
    round(sum1$r.squared, 2)
  )
  
  options(scipen = 0, digits = 7)
  
  return(string1)
}

# Ratio ----
ratio1 <- ggstatsplot::ggscatterstats(
  data = fig_1_data,
  x = "APOC1_APOC2",
  y = "ITC",
  xlab = "APOC1/APOC2 (log2)",
  ylab = "LPL activity (\U00B5J/s)",
  title = "",
  smooth.line.args = list(size = fig_1_linesize, color = "black"),
  point.args	= list(size = fig_1_pointsize),
  ggtheme = ggplot2::theme_classic(),
  marginal.type = "histogram",
  xfill = "white",
  yfill = "white",
  messages = FALSE,
  ggplot.component = list(
    scale_y_continuous(limits = c(0, 2)),
    theme(
      text = element_text(family = "Helvetica", size = 6),
      axis.title = element_text(family = "Helvetica", size = 6, face = "bold"),
      axis.text = element_text(family = "Helvetica", size = 6, colour = "black", face = "plain")
    )
  ),
  ggstatsplot.layer = FALSE,
  output = "plot",
  bf.message = FALSE,
  results.subtitle = FALSE
)

ratio2 <- ggstatsplot::ggscatterstats(
  data = fig_1_data,
  x = "APOC3_APOC2",
  y = "ITC",
  xlab = "APOC3/APOC2 (log2)",
  ylab = "LPL activity (\U00B5J/s)",
  title = "",
  smooth.line.args = list(size = fig_1_linesize, color = "black"),
  point.args	= list(size = fig_1_pointsize),
  ggtheme = ggplot2::theme_classic(),
  marginal.type = "histogram",
  xfill = "white",
  yfill = "white",
  messages = FALSE,
  ggplot.component = list(
    scale_y_continuous(limits = c(0, 2)),
    theme(
      text = element_text(family = "Helvetica", size = 6),
      axis.title = element_text(family = "Helvetica", size = 6, face = "bold"),
      axis.text = element_text(family = "Helvetica", size = 6, colour = "black", face = "plain")
    )
  ),
  ggstatsplot.layer = FALSE,
  output = "plot",
  bf.message = FALSE,
  results.subtitle = FALSE
)

# Compute figs using ggstatsplot ----
apoa5 <- ggstatsplot::ggscatterstats(
  data = fig_1_data,
  x = "APOA5_log",
  y = "ITC",
  xlab = "APOA5 (log2 ng/mL)",
  ylab = "LPL activity (\U00B5J/s)",
  title = "",
  smooth.line.args = list(size = fig_1_linesize, color = "black"),
  point.args	= list(size = fig_1_pointsize),
  ggtheme = ggplot2::theme_classic(),
  marginal.type = "histogram",
  xfill = "white",
  yfill = "white",
  messages = FALSE,
  ggplot.component = list(
    scale_y_continuous(limits = c(0, 2)),
    theme(
      text = element_text(family = "Helvetica", size = 6),
      axis.title = element_text(family = "Helvetica", size = 6, face = "bold"),
      axis.text = element_text(family = "Helvetica", size = 6, colour = "black", face = "plain")
    )
  ),
  ggstatsplot.layer = FALSE,
  output = "plot",
  bf.message = FALSE,
  results.subtitle = FALSE
)
angptl3 <- ggstatsplot::ggscatterstats(
  data = fig_1_data,
  x = "ANGPTL3",
  y = "ITC",
  xlab = "ANGPTL3 (ng/mL)",
  ylab = "LPL activity (\U00B5J/s)",
  title = "",
  smooth.line.args = list(size = fig_1_linesize, color = "black"),
  point.args	= list(size = fig_1_pointsize),
  ggtheme = ggplot2::theme_classic(),
  marginal.type = "histogram",
  xfill = "white",
  yfill = "white",
  messages = FALSE,
  ggplot.component = list(
    scale_y_continuous(limits = c(0, 2)),
    theme(
      text = element_text(family = "Helvetica", size = 6),
      axis.title = element_text(family = "Helvetica", size = 6, face = "bold"),
      axis.text = element_text(family = "Helvetica", size = 6, colour = "black", face = "plain")
    )
  ),
  ggstatsplot.layer = FALSE,
  output = "plot",
  bf.message = FALSE,
  results.subtitle = FALSE
)
angptl4 <- ggstatsplot::ggscatterstats(
  data = fig_1_data,
  x = "ANGPTL4_log",
  y = "ITC",
  xlab = "ANGPTL4 (log2 ng/mL)",
  ylab = "LPL activity (\U00B5J/s)",
  title = "",
  smooth.line.args = list(size = fig_1_linesize, color = "black"),
  point.args	= list(size = fig_1_pointsize),
  ggtheme = ggplot2::theme_classic(),
  marginal.type = "histogram",
  xfill = "white",
  yfill = "white",
  messages = FALSE,
  ggplot.component = list(
    scale_y_continuous(limits = c(0, 2)),
    theme(
      text = element_text(family = "Helvetica", size = 6),
      axis.title = element_text(family = "Helvetica", size = 6, face = "bold"),
      axis.text = element_text(family = "Helvetica", size = 6, colour = "black", face = "plain")
    )
  ),
  ggstatsplot.layer = FALSE,
  output = "plot",
  bf.message = FALSE,
  results.subtitle = FALSE
)
angptl8 <- ggstatsplot::ggscatterstats(
  data = fig_1_data,
  x = "ANGPTL8_log",
  y = "ITC",
  xlab = "ANGPTL8 (log2 pg/mL)",
  ylab = "LPL activity (\U00B5J/s)",
  title = "",
  smooth.line.args = list(size = fig_1_linesize, color = "black"),
  point.args	= list(size = fig_1_pointsize),
  ggtheme = ggplot2::theme_classic(),
  marginal.type = "histogram",
  xfill = "white",
  yfill = "white",
  messages = FALSE,
  ggplot.component = list(
    scale_y_continuous(limits = c(0, 2)),
    theme(
      text = element_text(family = "Helvetica", size = 6),
      axis.title = element_text(family = "Helvetica", size = 6, face = "bold"),
      axis.text = element_text(family = "Helvetica", size = 6, colour = "black", face = "plain")
    )
  ),
  ggstatsplot.layer = FALSE,
  output = "plot",
  bf.message = FALSE,
  results.subtitle = FALSE
)
apoc1 <- ggstatsplot::ggscatterstats(
  data = fig_1_data,
  x = "APOC1",
  y = "ITC",
  xlab = "APOC1 (ug/mL)",
  ylab = "LPL activity (\U00B5J/s)",
  title = "",
  smooth.line.args = list(size = fig_1_linesize, color = "black"),
  point.args	= list(size = fig_1_pointsize),
  ggtheme = ggplot2::theme_classic(),
  marginal.type = "histogram",
  xfill = "white",
  yfill = "white",
  messages = FALSE,
  ggplot.component = list(
    scale_y_continuous(limits = c(0, 2)),
    theme(
      text = element_text(family = "Helvetica", size = 6),
      axis.title = element_text(family = "Helvetica", size = 6, face = "bold"),
      axis.text = element_text(family = "Helvetica", size = 6, colour = "black", face = "plain")
    )
  ),
  ggstatsplot.layer = FALSE,
  output = "plot",
  bf.message = FALSE,
  results.subtitle = FALSE
)
apoc2 <- ggstatsplot::ggscatterstats(
  data = fig_1_data,
  x = "APOC2_log",
  y = "ITC",
  xlab = "APOC2 (log2 mg/mL)",
  ylab = "LPL activity (\U00B5J/s)",
  title = "",
  smooth.line.args = list(size = fig_1_linesize, color = "black"),
  point.args	= list(size = fig_1_pointsize),
  ggtheme = ggplot2::theme_classic(),
  marginal.type = "histogram",
  xfill = "white",
  yfill = "white",
  messages = FALSE,
  ggplot.component = list(
    scale_y_continuous(limits = c(0, 2)),
    theme(
      text = element_text(family = "Helvetica", size = 6),
      axis.title = element_text(family = "Helvetica", size = 6, face = "bold"),
      axis.text = element_text(family = "Helvetica", size = 6, colour = "black", face = "plain")
    )
  ),
  ggstatsplot.layer = FALSE,
  output = "plot",
  bf.message = FALSE,
  results.subtitle = FALSE
)
apoc3 <- ggstatsplot::ggscatterstats(
  data = fig_1_data,
  x = "APOC3_log",
  y = "ITC",
  xlab = "APOC3 (log2 mg/mL)",
  ylab = "LPL activity (\U00B5J/s)",
  title = "",
  smooth.line.args = list(size = fig_1_linesize, color = "black"),
  point.args	= list(size = fig_1_pointsize),
  ggtheme = ggplot2::theme_classic(),
  marginal.type = "histogram",
  xfill = "white",
  yfill = "white",
  messages = FALSE,
  ggplot.component = list(
    scale_y_continuous(limits = c(0, 2)),
    theme(
      text = element_text(family = "Helvetica", size = 6),
      axis.title = element_text(family = "Helvetica", size = 6, face = "bold"),
      axis.text = element_text(family = "Helvetica", size = 6, colour = "black", face = "plain")
    )
  ),
  ggstatsplot.layer = FALSE,
  output = "plot",
  bf.message = FALSE,
  results.subtitle = FALSE
)

# Make grid and save
figure_1 <- cowplot::plot_grid(
  angptl3,
  angptl4,
  angptl8,
  apoc2,
  apoc1,
  apoc3,
  ratio1,
  ratio2,
  apoa5,
  labels = c("A.", "B.", "C.", "D.", "E.", "F.", "G.", "H.", "I.")
)

# Make pdf ----
pdf.options(encoding = "ISOLatin1.enc")

figure_1_ggdraw <- cowplot::ggdraw(figure_1) +
  cowplot::draw_label(
    calc_fig_1_test(fig_1_data, "ANGPTL3", "ITC", x_unit = "ng/mL"),
    x = 1/6, y = 0.99, hjust = 0.45, vjust = 1,
    fontfamily = "Helvetica", fontface = "plain", color = "black", size = 6,
  ) +
  cowplot::draw_label(
    calc_fig_1_test(fig_1_data, "ANGPTL4_log", "ITC", x_unit = "log2 ng/mL"),
    x = 3/6, y = 0.99, hjust = 0.45, vjust = 1,
    fontfamily = "Helvetica", fontface = "plain", color = "black", size = 6,
  ) +
  cowplot::draw_label(
    calc_fig_1_test(fig_1_data, "ANGPTL8_log", "ITC", x_unit = "log2 pg/mL"),
    x = 5/6, y = 0.99, hjust = 0.45, vjust = 1,
    fontfamily = "Helvetica", fontface = "plain", color = "black", size = 6,
  ) +
  cowplot::draw_label(
    calc_fig_1_test(fig_1_data, "APOC2_log", "ITC", x_unit = "log2 mg/mL"),
    x = 1/6, y = 0.99 - 1/3, hjust = 0.45, vjust = 1,
    fontfamily = "Helvetica", fontface = "plain", color = "black", size = 6,
  ) +
  cowplot::draw_label(
    calc_fig_1_test(fig_1_data, "APOC1", "ITC", x_unit = "log2 \U00B5g/mL"),
    x = 3/6, y = 0.99 - 1/3, hjust = 0.45, vjust = 1,
    fontfamily = "Helvetica", fontface = "plain", color = "black", size = 6,
  ) +
  cowplot::draw_label(
    calc_fig_1_test(fig_1_data, "APOC3_log", "ITC", x_unit = "log2 mg/mL"),
    x = 5/6, y = 0.99 - 1/3, hjust = 0.45, vjust = 1,
    fontfamily = "Helvetica", fontface = "plain", color = "black", size = 6,
  ) +
  cowplot::draw_label(
    calc_fig_1_test(fig_1_data, "APOC1_APOC2", "ITC", x_unit = "log2"),
    x = 1/6, y = 0.99 - 2/3, hjust = 0.45, vjust = 1,
    fontfamily = "Helvetica", fontface = "plain", color = "black", size = 6,
  ) +
  cowplot::draw_label(
    calc_fig_1_test(fig_1_data, "APOC3_APOC2", "ITC", x_unit = "log2"),
    x = 3/6, y = 0.99 - 2/3, hjust = 0.45, vjust = 1,
    fontfamily = "Helvetica", fontface = "plain", color = "black", size = 6,
  ) +
  cowplot::draw_label(
    calc_fig_1_test(fig_1_data, "APOA5_log", "ITC", x_unit = "log2 ng/mL"),
    x = 5/6, y = 0.99 - 2/3, hjust = 0.45, vjust = 1,
    fontfamily = "Helvetica", fontface = "plain", color = "black", size = 6,
  ) 

# Save plot ----
cowplot::save_plot(
  "./out/figure_2.pdf",
  figure_1_ggdraw,
  base_height = 7.1,
  base_width = 7.1,
  dpi = 1000
)
