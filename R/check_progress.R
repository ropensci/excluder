#' Title
#'
#' @param .data
#' @param min
#' @param finished_col
#' @param progress_col
#' @param quiet
#'
#' @return
#' @export
#'
#' @examples
check_progress <- function(.data, min = 100, finished_col = "Finished", progress_col = "Progress", quiet = FALSE) {

  # Quote column names
  finished_col <- dplyr::ensym(finished_col)
  progress_col <- dplyr::ensym(progress_col)

  # Find incomplete cases
  incomplete <- dplyr::filter(.data, !!finished_col == FALSE)
  n_incomplete <- nrow(incomplete)

  # If minimum percent specified, find cases below minimum
  if (min < 100) {
    incomplete <- dplyr::filter(.data, !!progress_col < min)
    n_below_min <- nrow(incomplete)
    if (quiet == FALSE) {
      message(n_incomplete, " participants did not complete the study, and ", n_below_min, " of those completed less than ", min, "% of the study.")
    }
  } else {
    if (quiet == FALSE) {
      message(n_incomplete, " participants did not complete the study.")
    }
  }
  return(incomplete)
}
