# Table S1-3
check_packages(
  bioc_packages = c(),
  cran_packages = c("writexl")
)

# S1: Get data ----
table_s1_data <- dataMatrix[names(heatmap_data)]

## Get new names ----
s1_names_df <- merge(
  data.frame(variableName = names(table_s1_data)),
  variableMetadata,
  by.x = "variableName",
  sort = FALSE
)

## Make table ----
table_s1 <- data.frame(
  Variable = s1_names_df$alternativeName1,
  Description = s1_names_df$alternativeName2,
  Unit = s1_names_df$unit,
  n = sapply(table_s1_data, function(x) {length(na.omit(x))}),
  Mean = sapply(table_s1_data, function(x) {summary(x)["Mean"]}),
  Standard.deviation = sapply(table_s1_data, function(x) {sd(na.omit(x))}),
  Median = sapply(table_s1_data, function(x) {summary(x)["Median"]}),
  Min = sapply(table_s1_data, function(x) {summary(x)["Min."]}),
  Max = sapply(table_s1_data, function(x) {summary(x)["Max."]}),
  First.Quartile = sapply(table_s1_data, function(x) {summary(x)["1st Qu."]}),
  Third.Quartile = sapply(table_s1_data, function(x) {summary(x)["3rd Qu."]})
)

# S2: Get data ----
table_s2_data <- forest_table

table_s2 <- data.frame(
  Variable = s1_names_df$alternativeName1,
  Description = s1_names_df$alternativeName2,
  Unit = s1_names_df$unit,
  LPL.uJ.per.1SD.change = table_s2_data$beta,
  Standard.error = table_s2_data$se,
  Lower.95.confidence.interval = table_s2_data$lower95,
  Upper.95.confidence.interval = table_s2_data$higher95,
  P.value = table_s2_data$pValue,
  P.value.corrected = sapply(
    table_s2_data$pValue,
    function(x) {
      p.adjust(
      x, 
      method = "bonferroni",
      n = 22)
    }
  ),
  Variance.explained.R2 = table_s2_data$R2
)

# S3: Get data ----
s3_data <- merge(
  sampleMetadata[c("ID", "ITC", "APOA5", "ANGPTL3", "ANGPTL4", 
                   "ANGPTL8", "APOC1", "APOC2", "APOC3")],
  missData.dataMatrix,
  by = "ID"
)

## Log2 transform ----
s3_data$APOA5 <- log(s3_data$APOA5, base = 2)
s3_data$ANGPTL3 <- log(s3_data$ANGPTL3, base = 2)
s3_data$ANGPTL4 <- log(s3_data$ANGPTL4, base = 2)
s3_data$ANGPTL8 <- log(s3_data$ANGPTL8, base = 2)
s3_data$APOC1 <- log(s3_data$APOC1, base = 2)
s3_data$APOC2 <- log(s3_data$APOC2, base = 2)
s3_data$APOC3 <- log(s3_data$APOC3, base = 2)

## Get run order ----
x.name <- rep(names(s3_data[10:147]), ncol(s3_data[3:9]))
y.name <- vector()
for (i in 3:9) {
  y.name <- c(
    y.name,
    rep(names(s3_data[i]), ncol(s3_data[10:147]))
  )
}

## Scale variables ----
s3_data <- rapply(
  s3_data,
  scale,
  classes = "numeric",
  how = "replace"
)

## Run models ----
bonf_s3 <- 0.05 / (7 * 22)

s3_models <- mapply(
  function(x, y) {
    s3_form <- formula(paste0(y, " ~ ", x))
    s3_fit <- lm(formula = s3_form, data = s3_data)
    s3_out <- data.frame(
      Regulator = y,
      Lipid.class = x,
      Standardised.Beta =  coef(summary(s3_fit))[, "Estimate"][2],
      Standard.error = coef(summary(s3_fit))[, "Std. Error"][2],
      Lower.95.confidence.interval = confint(s3_fit, level = 1 - bonf_s3)[2, 1],
      Upper.95.confidence.interval = confint(s3_fit, level = 1 - bonf_s3)[2, 2],
      P.value = coef(summary(s3_fit))[, "Pr(>|t|)"][2],
      P.value.corrected = p.adjust(
        coef(summary(s3_fit))[, "Pr(>|t|)"][2],
        method = "bonferroni",
        n = 7 * 22
      ),
      Variance.explained.R2 = summary(s3_fit)["r.squared"]$r.squared
    )
    return(s3_out)
  },
  x.name,
  y.name
)
table_s3 <- as.data.frame(t(s3_models))
table_s3 <- data.frame(sapply(
  table_s3,
  function(x) {
    Reduce(rbind, x)
  }
))

## Format columns ----
table_s3$Standardised.Beta <- as.numeric(table_s3$Standardised.Beta)
table_s3$Standard.error <- as.numeric(table_s3$Standard.error)
table_s3$Lower.95.confidence.interval <- as.numeric(table_s3$Lower.95.confidence.interval)
table_s3$Upper.95.confidence.interval <- as.numeric(table_s3$Upper.95.confidence.interval)
table_s3$P.value <- as.numeric(table_s3$P.value)
table_s3$P.value.corrected <- as.numeric(table_s3$P.value.corrected)
table_s3$Variance.explained.R2 <- as.numeric(table_s3$Variance.explained.R2)

# Format names ----
table_s3$Lipid.class <- sapply(
  table_s3$Lipid.class,
  function(x) {
    z <- variableMetadata$alternativeName1[match(x, variableMetadata$variableName)]
    return(z)
  }
)

# Subset vars from table s1
table_s3 <- subset(
  table_s3,
  Lipid.class %in% table_s1$Variable
)

# Write to xslx ----
table_S1.3 <- list(
  Supplementary.table.1 = table_s1,
  Supplementary.table.2 = table_s2,
  Supplementary.table.3 = table_s3
)

writexl::write_xlsx(
  table_S1.3,
  path = "./out/table_S1-3.xlsx"
)
