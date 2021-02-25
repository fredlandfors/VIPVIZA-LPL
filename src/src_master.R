# Description:
#   Sources all the scripts needed for the VIPVIZA-LPL project.
#   !OBSERVE! The script installs several packages if they are not already
#   installed.

#----------------------------------------------------------------------------
# Data paths
#----------------------------------------------------------------------------
data_path <- "~/projekt_data/2019-03-11_VIPVIZA-ITC_data/14766.xlsx"
markdown_path <- "~/projekt_data/2019-03-11_VIPVIZA-ITC_data/rData/markdown.RData"

#----------------------------------------------------------------------------
# Dependencies check
#----------------------------------------------------------------------------
check_packages <- function(cran_packages = c(""),
                           bioc_packages = c("")) {
  # Description:
  #   If package is not installed, the function installs the package
  if (!"" %in% cran_packages) {
    lapply(
      cran_packages,
      FUN = function(x) {
        if (!x %in% rownames(installed.packages())) {
          install.packages(x, dependencies = TRUE)
        }
      }
    )
  }
  if (!"" %in% bioc_packages) {
    lapply(
      bioc_packages,
      FUN = function(x) {
        if (!x %in% rownames(installed.packages())) {
          BiocManager::install(x, dependencies = TRUE)
        }
      }
    )
  }
  paste0("Checked if necessary packages were installed")
}

#----------------------------------------------------------------------------
# Preprocessing
#----------------------------------------------------------------------------

# Functions
source(file = "./src/func/outlier_analysis/geom_cwiseboxplot.R")
source(file = "./src/func/outlier_analysis/geom_rwiseboxplot.R")
source(file = "./src/func/outlier_analysis/plot_pca.R")
source(file = "./src/func/impute_by_MICE.R")
source(file = "./src/func/impute_by_LCMD.R")

# Source the preprocess script
source(file = "./src/preproc.R")

#----------------------------------------------------------------------------
# Analysis
#----------------------------------------------------------------------------

# Functions
source(file = "./src/func/mk_descstats_table.R")
source(file = "./src/func/calc_forest.R")

# Source output scripts
source(file = "./src/table_1.R")
source(file = "./src/figure_1.R")
source(file = "./src/figure_2.R")
source(file = "./src/table_S1-3.R")

# Save data environment for markdown
save.image(markdown_path)