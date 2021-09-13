# Reviewed manuscript ----
check_packages(
  bioc_packages = c(),
  cran_packages = c("ggstatsplot", "cowplot", "ggplot2", "wesanderson",
                    "boot")
)
library(cowplot)

## Get data ----
itc <- merge(
  sampleMetadata[c("ID", "ITC")],
  missData.dataMatrix,
  by = "ID"
)

## Fig A: Scatter ----
### Subset data ----
itc.a <- itc[c("ID", "ITC", "VLDL_D", "Serum_TG")]

### Scale ----
itc.a$VLDL_D <- scale(itc.a$VLDL_D)
itc.a$Serum_TG <- scale(itc.a$Serum_TG)

### Define graphical parameters ----
fig_4_linesize <- 0.5
fig_4_pointsize <- 1

### Define multiple comparisons correction ----
p_correct_n <- 22

### Define statistical tests function ----
calc_fig_4_test <- function(df, x, y, x_unit = "1-X") {
  form1 <- formula(paste0(y, " ~ ", x))
  fit1 <- lm(form1, data = df)
  sum1 <- summary(fit1)

  options(scipen = 3, digits = 4)

  string1 <- paste0(
    "Effect = ",
    round(sum1$coefficients[x, "Estimate"], 2),
    " \U00B5J/s per ", x_unit,
    ", R\U00B2 = ",
    round(sum1$r.squared, 2)
  )

  options(scipen = 0, digits = 7)

  return(string1)
}

### Draw individual plots ----
itc.a.p1 <- ggstatsplot::ggscatterstats(
  data = itc.a,
  x = "VLDL_D",
  y = "ITC",
  xlab = "Mean VLDL particle diameter (1-SD)",
  ylab = "LPL activity (\U00B5J/s)",
  title = "",
  smooth.line.args = list(size = fig_4_linesize, color = "black"),
  point.args = list(size = fig_4_pointsize),
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
    ),
    scale_x_continuous(breaks = seq(-2, 4, 1), limits = c(-2, 4))
  ),
  ggstatsplot.layer = FALSE,
  output = "plot",
  bf.message = FALSE,
  results.subtitle = FALSE
)

itc.a.p2 <- ggstatsplot::ggscatterstats(
  data = itc.a,
  x = "Serum_TG",
  y = "ITC",
  xlab = "Total triglycerides (1-SD)",
  ylab = "LPL activity (\U00B5J/s)",
  title = "",
  smooth.line.args = list(size = fig_4_linesize, color = "black"),
  point.args = list(size = fig_4_pointsize),
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
    ),
    scale_x_continuous(breaks = seq(-2, 4, 1), limits = c(-2, 4))
  ),
  ggstatsplot.layer = FALSE,
  output = "plot",
  bf.message = FALSE,
  results.subtitle = FALSE
)

### Bootstrap 95 % CI:s for R2 ----
library(boot)
set.seed(123)

fit.vldld <- function(data, ind) {
  model <- lm(ITC ~ VLDL_D, data = data[ind, ])
  c(coef(model), rsq = summary(model)$r.squared)
}
boot.r2.vldld <- boot(itc, R = 10000, statistic = fit.vldld, sim = "ordinary")
boot.ci(boot.r2.vldld, index = 3, type = "perc")

fit.stg <- function(data, ind) {
  model <- lm(ITC ~ Serum_TG, data = data[ind, ])
  c(coef(model), rsq = summary(model)$r.squared)
}
boot.r2.stg <- boot(itc, R = 10000, statistic = fit.stg)
boot.ci(boot.r2.stg, index = 3, type = "perc")

violin <- data.frame(
  VLDL_D = data.frame(boot.r2.vldld$t)[,"X3"],
  Tot_TG = data.frame(boot.r2.stg$t)[,"X3"]
)
violin.reshape <- reshape(
  violin,
  varying = names(violin),
  timevar = "time",
  idvar = "boot",
  v.names = "r2",
  direction = "long"
)
violin.reshape$var <- ifelse(
  violin.reshape$time == 1,
  "VLDL-D",
  "Tot.TG"
)

# r2.1 - r2.2
fit.compare <- function(data, ind) {
  model.1 <- lm(ITC ~ VLDL_D, data = data[ind, ])
  model.2 <- lm(ITC ~ Serum_TG, data = data[ind, ])
  r2.diff <- summary(model.1)$r.squared - summary(model.2)$r.squared
  return(r2.diff)
}
boot.r2.compare <- boot(itc, R = 10000, statistic = fit.compare, sim = "ordinary")
boot.ci(boot.r2.compare, index = 1, type = "perc", conf = 1 - 0.05/22)

r2.diff <- data.frame(
  r2 = boot.r2.compare$t,
  var = rep("VLDL-D - Tot.TG")
)
r2.diff.2 <- rbind(
  violin.reshape[c("r2", "var")],
  r2.diff
)
dens.diff <- ggplot(data = r2.diff, aes(x = r2 * 100, fill = var)) + 
  ggtitle("Model comparison: \n Mean VLDL diameter vs. Total triglycerides") +
  xlab("VLDL-D - Tot.TG explained variance diff. (R\U00B2 %)") + 
  scale_x_continuous(limits = c(-10, 50), breaks = seq(0, 50, 10)) +
  ylab("Density") +
  geom_density(alpha = 0.5) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "black") +
  geom_vline(xintercept = 0.0507 * 100, linetype = "dashed", color = "grey75") +
  geom_vline(xintercept = 0.3263 * 100, linetype = "dashed", color = "grey75") +
  geom_vline(xintercept = mean(r2.diff$r2) * 100, linetype = "dashed", color = "white") +
  scale_fill_manual(values = c("black")) +
  labs(fill = "R\U00B2") +
  theme_classic() +
  theme(
    plot.title = element_text(
      color = "black",
      size = 6,
      family = "Helvetica",
      face = "bold",
      hjust = 0.5
    ),
    legend.title = element_text(size = 5, family = "Helvetica", face = "bold"),
    legend.text = element_text(size = 5, family = "Helvetica", face = "plain"),
    legend.background = element_blank(), 
    legend.key.size = unit(0.5, "line"),
    legend.direction = "vertical",
    legend.position = c(1, 1),
    legend.justification = c("right", "top"),
    legend.margin = margin(1, 1, 1, 1),
    
    strip.background = element_blank(),
    strip.text = element_text(size = 6, family = "Helvetica", face = "bold"),
    axis.text.x = element_text(
      colour = "black", size = 6, family = "Helvetica", face = "plain"
    ),
    axis.text.y = element_text(
      colour = "black", size = 6, family = "Helvetica", face = "plain"
    ),
    axis.title = element_text(size = 6, family = "Helvetica", face = "bold")
  )

### Draw complete plot w. stats ----
pdf.options(encoding = "ISOLatin1.enc")

itc.a.p <- plot_grid(
  itc.a.p1, 
  itc.a.p2,
  dens.diff,
  nrow = 1,
  rel_widths = c(1,1,1),
  labels = c("A.", "B.", "C.")
)
itc.a_ggdraw <- cowplot::ggdraw(itc.a.p) +
  cowplot::draw_label(
    paste0("Model statistics: \n", calc_fig_4_test(itc.a, "VLDL_D", "ITC", x_unit = "nm")),
    x = 1 / 6, y = 0.99, hjust = 0.45, vjust = 1,
    fontfamily = "Helvetica", fontface = "bold", color = "black", size = 6,
  ) +
  cowplot::draw_label(
    paste0("Model statistics: \n", calc_fig_4_test(itc.a, "Serum_TG", "ITC", x_unit = "mmol/L")),
    x = 3 / 6, y = 0.99, hjust = 0.45, vjust = 1,
    fontfamily = "Helvetica", fontface = "bold", color = "black", size = 6,
  )
### Save to pdf ----
cowplot::save_plot(
  "./out/figure_S1.pdf",
  itc.a_ggdraw,
  base_height = 2.25,
  base_width = 7.1,
  dpi = 1000
)

