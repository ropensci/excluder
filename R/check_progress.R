check_progress <- function(df, minimum = 100, quiet = FALSE) {
  # Find incomplete cases
  incomplete <- dplyr::filter(df, `Finished` == FALSE)
  n_incomplete <- nrow(incomplete)
  # If minimum percent specified, find cases below minimum
  if (minimum < 100) {
    below_minimum <- dplyr::filter(df, `Progress` < minimum)
    n_below_minimum <- nrow(below_minimum)
    if (quiet == FALSE) {
      message(n_incomplete, " participants did not complete the study, and ", n_below_minimum, " completed less than ", minimum, "% of the study.")
      incomplete <- below_minimum
    }
  } else {
    if (quiet == FALSE) {
      message(n_incomplete, " participants did not complete the study.")
    }
  }
  return(incomplete)
}

