# Require packages
check_packages(
  bioc_packages = c("ropls", "mixOmics", "ComplexHeatmap"),
  cran_packages = c(
    "readxl", "tidyverse", "ggraptR", "mice", "naniar",
    "knitr", "corrplot", "cowplot", "bestNormalize",
    "circlize", "xtable", "caret"
  )
)

# The data used in this project is comprised of three sheets in one xlsx file:
#
#   1. Nightingale NMR data
#   2. Sample metadata
#   3. Variable metadata
#
# Get data:
dataMatrix <- read_excel(
  "~/projekt_data/2019-03-11_VIPVIZA-ITC_data/14766.xlsx",
  sheet = "dataMatrix",
  na = c("0")
)
dataMatrix <- as.data.frame(dataMatrix)
dataMatrix$ID <- base::as.character(dataMatrix$ID)

sampleMetadata <- read_excel(
  "~/projekt_data/2019-03-11_VIPVIZA-ITC_data/14766.xlsx",
  sheet = "sampleMetadata"
)
sampleMetadata <- as.data.frame(sampleMetadata)

sampleMetadata$ID <- base::as.character(sampleMetadata$ID)
sampleMetadata$sex_3 <- base::as.factor(sampleMetadata$sex_3)

variableMetadata <- read_excel(
  "~/projekt_data/2019-03-11_VIPVIZA-ITC_data/14766.xlsx",
  sheet = "variableMetadata"
)
variableMetadata <- as.data.frame(variableMetadata)

# Clean data:
sampleMetadata <- sampleMetadata %>%
  dplyr::mutate(bmi_3 = vikt_3 / (Height * 0.01 * Height * 0.01)) %>%
  dplyr::mutate(age_3 = alder_0 + 3) %>%
  dplyr::select(-c(alder_0))

variableMetadata <- variableMetadata %>%
  dplyr::add_row(
    variableName = "bmi_3",
    unit = "kg/m2",
    platform = "clinical",
    alternativeName1 = "BMI",
    alternativeName2 = "Body mass index"
  )

variableMetadata$variableName[variableMetadata$variableName == "alder_0"] <- "age_3"
variableMetadata$alternativeName1[variableMetadata$alternativeName1 == "alder_0"] <- "age_3"

# Remove irrelevant variables
dataMatrix <- dataMatrix %>%
  dplyr::select(-c(Glc, Lac, Cit, Ala, Gln, His, Ile, Leu, Val, Phe, Tyr, Ace, AcAce, bOHBut, Crea, Alb, Gp))

variableMetadata <- variableMetadata %>%
  dplyr::filter(variableName != "Glc") %>%
  dplyr::filter(variableName != "Lac") %>%
  dplyr::filter(variableName != "Cit") %>%
  dplyr::filter(variableName != "Ala") %>%
  dplyr::filter(variableName != "Gln") %>%
  dplyr::filter(variableName != "His") %>%
  dplyr::filter(variableName != "Ile") %>%
  dplyr::filter(variableName != "Leu") %>%
  dplyr::filter(variableName != "Val") %>%
  dplyr::filter(variableName != "Phe") %>%
  dplyr::filter(variableName != "Tyr") %>%
  dplyr::filter(variableName != "Ace") %>%
  dplyr::filter(variableName != "AcAce") %>%
  dplyr::filter(variableName != "bOHBut") %>%
  dplyr::filter(variableName != "Crea") %>%
  dplyr::filter(variableName != "Alb") %>%
  dplyr::filter(variableName != "Gp")

# Convert the ITC measurement to SI units. nCal to uJ
sampleMetadata$ITC <- sampleMetadata$ITC * 4.184

# Set levels of "sex_3"
levels(sampleMetadata$sex_3) <- c("Male", "Female")

# DF:s for REAMDE.rmd
unproc_samplemeta <- sampleMetadata
unproc_datamatrix <- dataMatrix

# Set unfeasible outliers in sampleMetadata as NA
sampleMetadata[31, ]$hdl_3 <- NA
sampleMetadata[114, ]$ANGPTL4 <- NA
sampleMetadata[18, ]$ANGPTL8 <- NA
sampleMetadata[64, ]$APOC1 <- NA

# Impute missing values for sample metadata using MICE
tempData_samplemeta <- impute_by_MICE(
  sampleMetadata,
  vars_include = c(
    "sex_3",
    "vikt_3",
    "midja_3",
    "skol_3",
    "stg_3",
    "ldl_3",
    "hdl_3",
    "blods0_3",
    "sbt_3",
    "dbt_3",
    "Height",
    "bmi_3",
    "age_3"
  ),
  method1 = "pmm",
  set_seed = 1234
)

missData.sampleMetadata <- tempData_samplemeta$data$mice_data_out

# Impute missing values for NMR data matrix using LCMD
tempdata_dataMatrix <- impute_by_LCMD(
  dataMatrix,
  include_vars = names(Filter(is.numeric, dataMatrix)),
  method = "MinDet"
)

missData.dataMatrix <- tempdata_dataMatrix$data$data_out

# Data sets can be merged after multiple imputation
fullData <- dplyr::inner_join(
  x = missData.sampleMetadata,
  y = missData.dataMatrix,
  by = 'ID'
)

# Save environment data to file
save.image("~/projekt_data/2019-03-11_VIPVIZA-ITC_data/rData/preproc.RData")