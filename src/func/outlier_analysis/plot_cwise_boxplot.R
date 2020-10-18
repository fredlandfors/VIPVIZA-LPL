plot_cwise_boxplot <- function(x, id) {
  return_list <- list()
  rownames(x) <- id[, 1]
  
  cwise_boxplot_data <- sapply(x, scale)
  
  return_list$column_means <- sapply(
    as.data.frame(cwise_boxplot_data),
    function(x) {
      mean(x, na.rm = TRUE)
    }
  )
  
  return_list$boxplot <- boxplot(cwise_boxplot_data)
  boxplot(cwise_boxplot_data)
  
  return(return_list)
}