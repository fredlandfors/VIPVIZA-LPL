calc_forest <- function(
  lmData.in,
  conf_level = 0.95
  ) {
  # Description:
  #   Make table with correlation stats
  # Args:
  #   lmData.in: Data frame with variables to include in forest plot
  #   conf_level: confidence level, for adjusted confidence intervals
  # Output:
  #   lmData.out: table with corr stats for geom_pointrange etc 

  nameVars <- base::names(lmData.in)
  lengthVar <- base::length(lmData.in)

  biomarkerName <- base::data.frame(biomarkerName = base::rep(0, lengthVar))
  beta <- base::data.frame(beta = base::rep(0, lengthVar))
  se <- base::data.frame(se = base::rep(0, lengthVar))
  pValue <- base::data.frame(pValue = base::rep(0, lengthVar))
  lower95 <- base::data.frame(lower95 = base::rep(0, lengthVar))
  higher95 <- base::data.frame(higher95 = base::rep(0, lengthVar))
  R2 <- base::data.frame(R2 = base::rep(0, lengthVar))

  fits <- base::list()

  for (i in 1:lengthVar) {
    # biomarker name df
    biomarkerName[i, 1] <- nameVars[i]

    if (biomarkerName[i, 1] != "ITC" && biomarkerName[i, 1] != "ID") {
      # make formula
      formula1 <- stats::as.formula(base::paste("ITC ~", base::paste(nameVars[i])))
      # linear regression
      fit1 <- stats::lm(data = lmData.in, formula1)
      # store fits
      fits <- append(fits, list(fit1))
      # beta coefficient df
      beta[i, 1] <- stats::coef(base::summary(fit1))[, "Estimate"][2]
      # se df
      se[i, 1] <- stats::coef(base::summary(fit1))[, "Std. Error"][2]
      # pvalue df
      pValue[i, 1] <- stats::coef(base::summary(fit1))[, "Pr(>|t|)"][2]
      #confint
      confint1 <- stats::confint(fit1, level = conf_level)
      # lower 95% CI df
      lower95[i, 1] <- confint1[2, 1]
      # higher 95% CI df
      higher95[i, 1] <- confint1[2, 2]
      # R-squared
      R2[i, 1] <- base::summary(fit1)["r.squared"]
    }

    else {
      beta[i, 1] <- NA
      pValue[i, 1] <- NA
      lower95[i, 1] <- NA
      higher95[i, 1] <- NA
      R2[i, 1] <- NA
    }
  }

  lmData.out <- base::data.frame(
    biomarkerName = biomarkerName[1:lengthVar, 1],
    beta = beta[1:lengthVar, 1],
    se = se[1:lengthVar, 1],
    pValue = pValue[1:lengthVar, 1],
    lower95 = lower95[1:lengthVar, 1],
    higher95 = higher95[1:lengthVar, 1],
    R2 = R2[1:lengthVar, 1]
  )
  return(lmData.out)
}
