mk_descstats_table <- function(df1,
                               n_digits,
                               use_var_metadata = FALSE,
                               old_names = NULL,
                               new_names = NULL,
                               new_unit = NULL) {
  # Description:
  #   Make table with descriptive stats
  # Args:
  #   df1: Data frame with variables to include in table.
  #   use_var_metadata: append names with metadata (yes/no)
  #   old_names: vector with old names
  #   new_names: vector with new names
  #   new_unit: vector with new units for parenthesis
  # Dependencies:
  check_packages(
    bioc_packages = c(""),
    cran_packages = c("")
  )
  # Returns:
  #   table1: Table with descriptive stats.

  #----------------------------------------------------------------------------
  # Column 1: variable names column
  #----------------------------------------------------------------------------
  varName <- names(df1)

  if (use_var_metadata == TRUE) {
    df_cha <- data.frame(
      old_n = old_names,
      new_n = new_names,
      new_u = new_unit
    )
  }

  # Change var names
  for (i in 1:length(varName)) {
    # Numeric
    if (is.numeric(df1[, i]) == TRUE) {
      if (use_var_metadata == TRUE) {
        names_df <- subset(df_cha, old_n == varName[i])
        varName[i] <- paste0(names_df$new_n, " (", names_df$new_u, ")")
      }
    }

    # Factors
    if (is.factor(df1[, i]) == TRUE) {
      if (use_var_metadata == TRUE) {
        names_df <- subset(df_cha, old_n == varName[i])
        varName[i] <- paste0(names_df$new_n)
      }

      # Add factor levels to name
      fct_names <- levels(na.omit(df1[, i]))

      varName[i] <- paste0(
        varName[i],
        "&  ",
        paste0(fct_names, collapse = "&  ")
      )
    }
  }


  #----------------------------------------------------------------------------
  # Column 2: n
  #----------------------------------------------------------------------------
  nCase <- seq(1, ncol(df1))
  for (i in 1:length(nCase)) {
    nCase[i] <- length(na.omit(df1[, i]))
  }
  #----------------------------------------------------------------------------
  # Column 3: mean+-SD or n+% var
  #----------------------------------------------------------------------------
  case_mean_or_percent <- rep("", ncol(df1))
  for (i in 1:length(case_mean_or_percent)) {
    # Numeric
    if (is.numeric(df1[, i]) == TRUE & nCase[i] > 0) {
      cc_M <- signif(mean(na.omit(df1[, i])), n_digits)
      cc_SD <- signif(sd(na.omit(df1[, i])), n_digits)
      case_mean_or_percent[i] <- paste(cc_M, " (SD: \u00B1 ", cc_SD, ")", sep = "")
    }

    # Factors
    if (is.factor(df1[, i]) == TRUE) {
      # Calc n fct levels
      fct_levels <- length(levels(na.omit(df1[, i])))
      fct_names <- levels(na.omit(df1[, i]))

      # .. with >= 2 levels
      if (fct_levels >= 2) {
        calcPerc <- as.numeric(rep(0, fct_levels))
        calcN <- as.numeric(rep(0, fct_levels))
        stringPerc <- as.character(rep("filler", fct_levels))

        for (m in seq_len(fct_levels)) {
          calcN[m] <- table(df1[, i])[m]
          calcPerc[m] <- 100 * (table(df1[, i])[m] / length(na.omit(df1[, i])))
          calcPerc[m] <- round(calcPerc[m], 1)
        }

        for (m in seq_len(fct_levels)) {
          stringPerc[m] <- paste0(" &", calcN[m], " (", calcPerc[m], " %)")
        }

        case_mean_or_percent[i] <- paste0(stringPerc, collapse = "")
      }
    }
  }

  #----------------------------------------------------------------------------
  # Column 4: median+IQR+range
  #----------------------------------------------------------------------------
  case_median <- rep("", ncol(df1))
  for (i in 1:length(case_median)) {
    # Numeric
    if (is.numeric(df1[, i]) == TRUE & nCase[i] > 0) {
      cc_median <- signif(summary(df1[, i])["Median"], n_digits)
      cc_iqr1 <- signif(summary(df1[, i])["1st Qu."], n_digits)
      cc_iqr3 <- signif(summary(df1[, i])["3rd Qu."], n_digits)
      cc_min <- signif(summary(df1[, i])["Min."], n_digits)
      cc_max <- signif(summary(df1[, i])["Max."], n_digits)
      case_median[i] <- paste0(
        cc_median, " (IQR: ", cc_iqr1, " - ", cc_iqr3,
        "; range: ", cc_min, " - ", cc_max, ")"
      )
    }
  }

  #----------------------------------------------------------------------------
  # Make table
  #----------------------------------------------------------------------------
  table1 <- data.frame(
    variable = varName,
    n = nCase,
    mean = case_mean_or_percent,
    median = case_median,
    stringsAsFactors = FALSE
  )

  table1_append <- data.frame()

  for (i in seq_len(nrow(table1))) {
    if (is.factor(df1[, i]) == TRUE) {
      new_vars <- strsplit(table1[i, "variable"], "&")[[1]][-1]
      new_mean1 <- strsplit(table1[i, "mean"], "&")[[1]][-1]
      n_fact <- length(new_vars)
      n_appended <- nrow(table1_append)

      append1 <- data.frame(
        index = seq(i + n_appended + 1, i + n_fact + n_appended),
        variable = new_vars,
        cases = rep("", n_fact),
        mean = new_mean1,
        median = rep("", n_fact),
        stringsAsFactors = FALSE
      )

      table1_append <- rbind(table1_append, append1)
    }
  }

  insertRow <- function(existingDF, newrow, r) {
    existingDF[seq(r + 1, nrow(existingDF) + 1), ] <- existingDF[seq(r, nrow(existingDF)), ]
    existingDF[r, ] <- newrow
    existingDF
  }

  table1_fin <- table1

  for (i in seq_len(nrow(table1_append))) {
    table1_fin <- insertRow(
      table1_fin,
      table1_append[i, -1],
      table1_append[i, "index"]
    )
  }

  table1_fin2 <- vapply(
    table1_fin,
    function(x) {
      for (i in seq_len(nrow(table1_fin))) {
        x[i] <- ifelse(
          grepl("&", x[i]),
          strsplit(x[i], split = "&")[[1]][1],
          x[i]
        )
      }
      return(x)
    },
    FUN.VALUE = character(nrow(table1_fin))
  )

  table1_fin2[is.na(table1_fin2)] <- ""

  table1_fin2 <- data.frame(table1_fin2, stringsAsFactors = FALSE)

  #----------------------------------------------------------------------------
  # Final return
  #----------------------------------------------------------------------------
  return(table1_fin2)
}
