# Table S1-2
check_packages(
  bioc_packages = c(),
  cran_packages = c("writexl")
)

# S1: Get data ----
table_s1_data <- dataMatrix[names(heatmap_data)]

# Get new names ----
s1_names_df <- merge(
  data.frame(variableName = names(table_s1_data)),
  variableMetadata,
  by.x = "variableName",
  sort = FALSE
)

# Make table ----
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
  P.value.adjusted = sapply(
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

# Write to xslx ----
table_S1.2 <- list(
  Table.S1 = table_s1,
  Table.S2 = table_s2
)

writexl::write_xlsx(
  table_S1.2,
  path = "./out/table_S1-2.xlsx"
)
