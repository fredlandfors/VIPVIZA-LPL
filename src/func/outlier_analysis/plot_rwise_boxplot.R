plot_rwise_boxplot <- function(x, id) {
  return_list <- list()
  
  rwise_boxplot_data <- t(
    vapply(x, scale, FUN.VALUE = numeric(nrow(x)))
  )
  
  colnames(rwise_boxplot_data) <- id[, 1]
  
  return_list$row_means <- vapply(
    as.data.frame(rwise_boxplot_data),
    function(x) {
      mean(x, na.rm = TRUE)
    },
    numeric(1)
  )
  
  return_list$boxplot <- boxplot(rwise_boxplot_data)
  boxplot(rwise_boxplot_data)
  
  return(return_list)
}