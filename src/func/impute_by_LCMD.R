impute_by_LCMD <- function(df,
                           include_vars,
                           method = "KNN",
                           impute_thresh = 1,
                           nearest_neighbors = 5,
                           princ_comps = 2,
                           tune_sigma = 1,
                           q_value = 0.01,
                           scaling = FALSE) {
  # Description:
  #   Performs missing values imputation using methods from imputeLCMD.
  # Args:
  #   df: Data frame.
  #   vars_include: Variables to include in MICE model.
  #   method: "KNN", "QRILC", "MinDet", "MinProb", "SVD", "MLE", "remove_vars".
  #   scaling: If true, performs scaling before imputation.
  #   impute_thresh: imputation threshold.
  #   nearest_neighbors: specify k nearest neighbors for KNN imputation.
  #   princ_comps: specify n PC:s for SVD imputation.
  #   tune_sigma: specify sigma for QRILC and MinProb imputation.
  #   q_value: specify q-value for MinDet and MinProb imputation.
  # Dependencies:
  check_packages(
    bioc_packages = c("pcaMethods", "impute"),
    cran_packages = c("naniar", "imputeLCMD", "ggplot2")
  )
  # Returns:
  #   return_list: List of objects.
  # Define lists:

  return_list <- list()
  return_list$data <- list()
  return_list$functions <- list()
  return_list$plots <- list()

  # Define functions:

  return_list$functions$show_missing <- function(x) {
    get_perc <- function(z) {
      sum(is.na(z)) / length(z) * 100
    }
    y <- sort(apply(x, 2, get_perc), decreasing = FALSE)
    return(y)
  }

  #----------------------------------------------------------------------------
  # Scale data
  #----------------------------------------------------------------------------
  if (scaling == TRUE) {
    df <- scale(Filter(is.numeric, df))
  }

  #----------------------------------------------------------------------------
  # Missing values analysis
  #----------------------------------------------------------------------------
  return_list$data$data_import <- df

  return_list$plots$vismissplot <- naniar::vis_miss(df)
  return_list$plots$upsetplot <- naniar::gg_miss_upset(df)
  
  percent_missing <- return_list$functions$show_missing(df)
  return_list$data$percent_missing <- percent_missing
  
  if (length(
    percent_missing[percent_missing > 0 & percent_missing < impute_thresh * 100]
    ) > 0) {
  which_missing_between_0_thresh <- rownames(
    subset(
      data.frame(
        v1 = return_list$data$percent_missing,
        v2 = rep(impute_thresh, length(return_list$data$percent_missing))
      ),
      v1 < impute_thresh * 100 & v1 > 0
    )
  )
  }
  
  if (length(percent_missing[percent_missing > 0]) > 0) {
  which_missing_under_thresh <- rownames(
    subset(
      data.frame(
        v1 = return_list$data$percent_missing,
        v2 = rep(impute_thresh, length(return_list$data$percent_missing))
      ),
      v1 < impute_thresh * 100
    )
  )
  }
  else {
    stop("no missing values in df")
  }

  #----------------------------------------------------------------------------
  # Perform imputation
  #----------------------------------------------------------------------------
  split_include_data <- df[names(df) %in% which_missing_under_thresh]
  split_include_data <- 
    split_include_data[names(split_include_data) %in% include_vars]

  split_exclude_data <- df[!names(df) %in% include_vars]

  if (method == "KNN") {
    impute_obj <- imputeLCMD::impute.wrapper.KNN(
      as.matrix(split_include_data),
      K = nearest_neighbors
    )
    LCMD_out <- cbind(split_exclude_data, impute_obj)
    return_list$data$data_out <- LCMD_out
  }

  if (method == "QRILC") {
    impute_obj <- imputeLCMD::impute.QRILC(
      split_include_data,
      tune.sigma = tune_sigma
    )
    LCMD_out <- cbind(split_exclude_data, impute_obj[[1]])
    return_list$data$data_out <- LCMD_out
  }

  if (method == "MinDet") {
    impute_obj <- imputeLCMD::impute.MinDet(
      split_include_data,
      q = q_value
    )
    LCMD_out <- cbind(split_exclude_data, impute_obj)
    return_list$data$data_out <- LCMD_out
  }

  if (method == "MinProb") {
    impute_obj <- imputeLCMD::impute.MinProb(
      split_include_data,
      q = q_value,
      tune.sigma = tune_sigma
    )
    LCMD_out <- cbind(split_exclude_data, impute_obj)
    return_list$data$data_out <- LCMD_out
  }

  if (method == "SVD") {
    impute_obj <- imputeLCMD::impute.wrapper.SVD(
      as.matrix(split_include_data),
      K = princ_comps
    )
    LCMD_out <- cbind(split_exclude_data, impute_obj)
    return_list$data$data_out <- LCMD_out
  }

  if (method == "MLE") {
    impute_obj <- imputeLCMD::impute.wrapper.MLE(
      as.matrix(split_include_data)
    )
    LCMD_out <- cbind(split_exclude_data, impute_obj)
    return_list$data$data_out <- LCMD_out
  }

  if (method == "remove_vars") {
    LCMD_out <-
      df[!names(df) %in% names(which(return_list$data$percent_missing > 0))]
    return_list$data$data_out <- LCMD_out
  }

  #----------------------------------------------------------------------------
  # Post-imputation diagnostics: scatter plot
  #----------------------------------------------------------------------------
  plot_impdx_scatter <- function(preimp_data, postimp_data, vars1) {
    plot_data1 <- rbind(
      preimp_data[vars1],
      postimp_data[vars1],
      make.row.names = FALSE
    )

    m <- nrow(preimp_data)
    id_pre <- data.frame(imp = rep("pre", m))
    id_post <- data.frame(imp = rep("post", m))
    imp_status <- rbind(id_pre, id_post)

    plot_data2 <- cbind(plot_data1, imp_status)

    plot_data3 <- reshape(
      plot_data2,
      varying = vars1,
      timevar = "var",
      idvar = "id",
      v.names = "conc",
      direction = "long"
    )

    plot_data3$imputed <- sapply(
      plot_data3$conc,
      function(x) {
        ifelse(is.na(x), "yes", "no")
      }
    )

    plot_data3 <- split(plot_data3, plot_data3$imp)

    plot_data3$post$imputed <- sapply(
      plot_data3$pre$imputed,
      function(x) {
        ifelse(x == "yes",
          "yes",
          x
        )
      }
    )

    plot_data4 <- rbind(plot_data3$pre, plot_data3$post)

    p1 <- ggplot(plot_data4, aes(x = imp, y = conc)) +
      geom_jitter(aes(colour = imputed)) +
      facet_wrap(~var, scales = "free")

    return(p1)
  }

  if (method != "remove_vars") {
    p1 <- plot_impdx_scatter(
      preimp_data = df,
      postimp_data = LCMD_out,
      vars1 = which_missing_between_0_thresh
    )

    return_list$plots$scatter <- p1
  }

  #----------------------------------------------------------------------------
  # Post-imputation diagnostics: density plots
  #----------------------------------------------------------------------------
  plot_impdx_density <- function(preimp_data, postimp_data, vars1) {
    plot_data1 <- rbind(preimp_data[vars1],
      postimp_data[vars1],
      make.row.names = FALSE
    )

    m <- nrow(preimp_data)
    id_pre <- data.frame(imputation = rep("pre", m))
    id_post <- data.frame(imputation = rep("post", m))
    imp_status <- rbind(id_pre, id_post)

    plot_data2 <- cbind(plot_data1, imp_status)

    plot_data3 <- reshape(
      plot_data2,
      varying = vars1,
      timevar = "var",
      idvar = "id",
      v.names = "conc",
      direction = "long"
    )

    p1 <- ggplot(plot_data3, aes(x = conc)) +
      geom_density(aes(colour = imputation, fill = imputation), alpha = 0.1) +
      facet_wrap(~var, scales = "free")

    return(p1)
  }

  if (method != "remove_vars") {
    p2 <- plot_impdx_density(
      preimp_data = df,
      postimp_data = LCMD_out,
      vars1 = which_missing_between_0_thresh
    )

    return_list$plots$density <- p2
  }

  #----------------------------------------------------------------------------
  # Fin return
  #----------------------------------------------------------------------------

  return(return_list)
}
