#' Title
#'
#' @param .data
#' @param min_progress
#' @param finished_col
#' @param progress_col
#' @param quiet
#'
#' @return
#' @export
#'
#' @examples
check_progress <- function(.data, min_progress = 100, finished_col = "Finished", progress_col = "Progress", quiet = FALSE) {

  # Quote column names
  finished_col <- dplyr::ensym(finished_col)
  progress_col <- dplyr::ensym(progress_col)

  # Find incomplete cases
  incomplete <- dplyr::filter(.data, !!finished_col == FALSE)
  n_incomplete <- nrow(incomplete)

  # If minimum percent specified, find cases below minimum
  if (min_progress < 100) {
    incomplete <- dplyr::filter(.data, !!progress_col < min_progress)
    n_below_min <- nrow(incomplete)
    if (quiet == FALSE) {
      message(n_incomplete, " participants did not complete the study, and ", n_below_min, " of those completed less than ", min_progress, "% of the study.")
    }
  } else {
    if (quiet == FALSE) {
      message(n_incomplete, " participants did not complete the study.")
    }
  }
  return(incomplete)
}
