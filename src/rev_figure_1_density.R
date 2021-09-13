# Figure 2B: Revised manuscript ----
check_packages(
  bioc_packages = c(""),
  cran_packages = c("boot", "ggplot2")
)
library(boot)

## Text size ----
violin_text_x <- 3
violin_text_y <- 5

## Forest plot ----
lm.data <- merge(
  sampleMetadata,
  missData.dataMatrix,
  by = "ID"
)

### Subset vars from heatmap ----
lm.data <- lm.data[c("ID", "ITC", names(f5))]

### Scale all vars except ID and ITC ----
lm.data.2 <- data.frame(
  lm.data["ITC"],
  sapply(lm.data[, -c(1, 2)], scale)
)

### Calculate regressions ----
model.list <- list()
x.vars <- names(lm.data.2)[-1]

for (i in 1:length(x.vars)) {
  form1 <- paste0("ITC ~ ", x.vars[i])
  fit.compare2 <- function(data, ind, form) {
    model.1 <- lm(formula = form1, data = data[ind, ])
    r2.diff <- summary(model.1)$r.squared
    return(r2.diff)
  }
  boot.r2.compare <- boot(lm.data.2, R = 10000, statistic = fit.compare2, sim = "ordinary")
  r2.diff <- data.frame(
    r2 = boot.r2.compare$t
  )
  model.list[[i]] <- r2.diff
}

model.df <- data.frame(Reduce(cbind, model.list))

### Rename ----
names1 <- data.frame(variableName = x.vars)
names2 <- base::merge(
  names1,
  variableMetadata,
  by.x = "variableName",
  sort = FALSE
)
names2$time <- rownames(names2)
numbers <- seq(1, ncol(model.df))
names2$fin.names <- mapply(
  function(x, y) {paste0(x, ". ", y)},
  numbers,
  names2$alternativeName1
)
names3 <- names2[c("time", "fin.names")]

### Reshape ----
model.reshaped <- reshape(
  model.df,
  varying = names(model.df),
  v.names = "r.squared",
  timevar = "time",
  idvar = "id",
  direction = "long"
)
model.reshaped <- merge(
  model.reshaped,
  names3,
  by = "time"
)
model.reshaped$plot_order <- as.factor(model.reshaped$time)

### func ----
violin_func <- function(x) {
  data.frame(
    y = median(x),
    ymin = quantile(x, probs = 0.05/22),
    ymax = quantile(x, probs = 1 - 0.05/22)
  )
} 

### draw plot ----
violin <- ggplot(data = model.reshaped,
                 mapping = aes(x = plot_order, y = r.squared * 100)) + 
  ggtitle("Explained variance:\n Plasma LPL activity regressed on NMR lipid parameters") +
  geom_hline(yintercept = 50, linetype = "dashed", size = 0.5) +
  geom_violin(
    draw_quantiles = 0.5,
    scale = "width"
  ) +
  xlab("") +
  scale_x_discrete(labels = unique(model.reshaped$fin.names)) +
  ylab("Explained variance (R\U00B2 %)") +
  scale_y_continuous(limits = c(0, 100)) +
  theme_bw() +
  theme(
    plot.title = element_text(
      color = "black", size = 6, family = "Helvetica", face = "bold", 
      hjust = 0.5
    ),
    legend.position = "none",
    axis.title.y = element_text(
      family = "Helvetica", size = violin_text_y, face = "bold"
    ),
    axis.text.x = element_text(
      family = "Helvetica", size = violin_text_x, face = "bold", colour = "black",
      angle = 90, vjust = 0.1
    ),
    axis.text.y = element_text(
      family = "Helvetica", size = violin_text_y, face = "plain", colour = "black"
    )
  ) +
  guides(x = guide_axis(angle = 45))

