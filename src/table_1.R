# Table 1 ----
check_packages(
  bioc_packages = c(),
  cran_packages = c("writexl")
)

# Get vars ----
vars_table_1 <- c(
  "age_3",
  "sex_3",
  "sbt_3",
  "dbt_3",
  "bmi_3",
  "skol_3",
  "stg_3",
  "ldl_3",
  "hdl_3",
  "blods0_3",
  "ITC",
  "ANGPTL3",
  "ANGPTL4",
  "ANGPTL8",
  "APOC1",
  "APOC2",
  "APOC3",
  "APOA5"
)
names_table_1 <- subset(
  variableMetadata,
  variableName %in% vars_table_1
)

# Make table ----
table_1 <- mk_descstats_table(
  sampleMetadata[vars_table_1],
  n_digits = 3,
  use_var_metadata = TRUE,
  old_names = names_table_1$variableName,
  new_names = names_table_1$alternativeName2,
  new_unit = names_table_1$unit
)

names(table_1) <- c(" ", "n", "Mean", "Median")

table_1[3, 2] <- paste0("  ", table_1[3, 3])
table_1[3, 3] <-  ""
  
table_1[4, 2] <- paste0("  ", table_1[4, 3])
table_1[4, 3] <-  ""

# Write to xlsx ----
writexl::write_xlsx(
  list(Table.1 = table_1),
  path = "./out/table_1.xlsx"
)