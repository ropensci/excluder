#' Title
#'
#' @param .data
#' @param min_progress
#' @param finished_col
#' @param progress_col
#' @param print_tibble
#' @param quiet
#'
#' @return
#' @export
#'
#' @examples
check_progress <- function(.data, min_progress = 100, finished_col = "Finished", progress_col = "Progress", print_tibble = TRUE, quiet = FALSE) {

  # Check for presence of required columns
  column_names <- names(.data)
  if (!finished_col %in% column_names) stop("The column specifying whether a participant finshed (finished_col) is incorrect. Please check your data and specify finished_col.")
  if (!progress_col %in% column_names) stop("The column specifying participant progress (progress_col) is absent. Please check your data and specify progress_col.")

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
  if (print_tibble == TRUE) {
    return(incomplete)
  } else {
    invisible(incomplete)
  }
}
