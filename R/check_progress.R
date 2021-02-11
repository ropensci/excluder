check_progress <- function(.data, min = 100, quiet = FALSE) {
  # Find incomplete cases
  incomplete <- dplyr::filter(.data, `Finished` == FALSE)
  n_incomplete <- nrow(incomplete)
  # If minimum percent specified, find cases below minimum
  if (min < 100) {
    below_min <- dplyr::filter(.data, `Progress` < min)
    n_below_min <- nrow(below_min)
    if (quiet == FALSE) {
      message(n_incomplete, " participants did not complete the study, and ", n_below_min, " completed less than ", min, "% of the study.")
      incomplete <- below_min
    }
  } else {
    if (quiet == FALSE) {
      message(n_incomplete, " participants did not complete the study.")
    }
  }
  return(incomplete)
}
