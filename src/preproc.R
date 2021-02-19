# Require dependencies ----
check_packages(
  bioc_packages = c("ropls", "ComplexHeatmap"),
  cran_packages = c(
    "readxl", "tidyverse", "mice", "naniar", "cowplot", "circlize", "ggplot2"
  )
)

# Library ----
library(ggplot2)
library(magrittr)

# Get data ----
# The data used in this project is comprised of three sheets in one xlsx file:
#
#   1. Nightingale NMR data
#   2. Sample metadata
#   3. Variable metadata
#
dataMatrix <- readxl::read_excel(
  data_path,
  sheet = "dataMatrix",
  na = c("0")
)
dataMatrix <- as.data.frame(dataMatrix)
dataMatrix$ID <- base::as.character(dataMatrix$ID)

sampleMetadata <- readxl::read_excel(
  data_path,
  sheet = "sampleMetadata"
)
sampleMetadata <- as.data.frame(sampleMetadata)

sampleMetadata$ID <- base::as.character(sampleMetadata$ID)
sampleMetadata$sex_3 <- base::as.factor(sampleMetadata$sex_3)

variableMetadata <- readxl::read_excel(
  data_path,
  sheet = "variableMetadata"
)
variableMetadata <- as.data.frame(variableMetadata)

# Clean data: ----
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

# Remove irrelevant variables ----
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

# Convert the ITC measurement to SI units. nCal to uJ ----
sampleMetadata$ITC <- sampleMetadata$ITC * 4.184

# Convert ApoA5 concentration from pg/mL to ng/mL ----
sampleMetadata$APOA5 <- sampleMetadata$APOA5 / 1000

# Set levels of "sex_3" ----
levels(sampleMetadata$sex_3) <- c("Male", "Female")

# DF:s for REAMDE.rmd
unproc_samplemeta <- sampleMetadata
unproc_datamatrix <- dataMatrix

# Set unreasonable outliers (judged as due to ELISA interference or wrong coding[HDL]) in sampleMetadata as NA ----
sampleMetadata[31, ]$hdl_3 <- NA 
sampleMetadata[114, ]$ANGPTL4 <- NA
sampleMetadata[18, ]$ANGPTL8 <- NA 
sampleMetadata[64, ]$APOC1 <- NA 

# Impute missing values for NMR data matrix using LCMD ----
tempdata_dataMatrix <- impute_by_LCMD(
  dataMatrix,
  include_vars = names(Filter(is.numeric, dataMatrix)),
  method = "MinDet"
)

missData.dataMatrix <- tempdata_dataMatrix$data$data_out