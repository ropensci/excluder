#' Title
#'
#' @param .data
#' @param min_duration
#' @param max_duration
#' @param duration_col
#' @param print_tibble
#' @param quiet
#'
#' @return
#' @export
#'
#' @examples
check_duration <- function(.data, min_duration = NULL, max_duration = NULL, duration_col = "Duration (in seconds)", print_tibble = TRUE, quiet = FALSE) {

  # Check for presence of required column
  column_names <- names(.data)
  if (!duration_col %in% column_names) stop("The column specifying duration (duration_col) is incorrect. Please check your data and specify duration_col.")

  # Quote column names
  duration_col <- dplyr::ensym(duration_col)

  # Find participants quicker than minimum
  if (!is.null(min_duration)) {
    too_quick <- too_quick_slow <- dplyr::filter(.data, !!duration_col < min_duration)
    n_too_quick <- nrow(too_quick)
    if (quiet == FALSE) {
      message(n_too_quick, " participants took less time than the minimum duration of ", min_duration, ".")
    }
  }
  # Find participants slower than maximum
  if (!is.null(max_duration)) {
    too_slow <- too_quick_slow <- dplyr::filter(.data, !!duration_col > max_duration)
    n_too_slow <- nrow(too_slow)
    if (quiet == FALSE) {
      message(n_too_slow, " participants took more time than the maximum duration of ", max_duration, ".")
    }
  }
  # Combine quick and slow participants
  if (!is.null(min_duration) & !is.null(max_duration)) {
    too_quick_slow <- rbind(too_quick, too_slow)
  } else if (is.null(min_duration) & is.null(max_duration)) {
    warning("You must specify either a minimum or maximum duration.")
    too_quick_slow <- NULL
  }
  if (print_tibble == TRUE) {
    return(too_quick_slow)
  } else {
    invisible(too_quick_slow)
  }
}
