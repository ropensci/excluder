#' Check for minimum or maximum durations
#'
#' @description
#' The `check_duration()` function subsets rows of data, retaining rows
#' that have durations that are too fast or too slow.
#' The function is written to work with data from
#' [Qualtrics](https://qualtrics.com) surveys.
#'
#' @details
#' Default column names are set based on output from the
#' [qualtRics::fetch_survey()].
#' By default, minimum durations of 10 seconds are checked, but either
#' minima or maxima can be checked with the `min_duration` and
#' `max_duration` arguments. The function outputs to console separate
#' messages about the number of rows that are too fast or too slow.
#'
#' This function returns the fast and slow rows.
#'
#' @param .data Data frame or tibble (preferably exported from Qualtrics).
#' @param min_duration Minimum duration that is too fast in seconds.
#' @param max_duration Maximum duration that is too slow in seconds.
#' @param duration_col Column name for durations.
#' @param print_tibble Logical indicating whether to print returned tibble to
#' console.
#' @param quiet Logical indicating whether to print message to console.
#'
#' @family duration functions
#' @family check functions
#' @return
#' An object of the same type as `.data` that includes the rows with fast and/or
#' slow duration.
#' For a function that marks these rows, use [mark_duration()].
#' For a function that excludes these rows, use [exclude_duration()].
#' @export
#'
#' @examples
#' # Check for durations faster than 100 seconds
#' data(qualtrics_text)
#' check_duration(qualtrics_text, min_duration = 100)
#'
#' # Remove preview data first
#' qualtrics_text %>%
#'   exclude_preview() %>%
#'   check_duration(min_duration = 100)
#'
#' # Check only for durations slower than 800 seconds
#' qualtrics_text %>%
#'   exclude_preview() %>%
#'   check_duration(max_duration = 800)
#'
#' # Do not print rows to console
#' qualtrics_text %>%
#'   exclude_preview() %>%
#'   check_duration(min_duration = 100, print_tibble = FALSE)
#'
#' # Do not print message to console
#' qualtrics_text %>%
#'   exclude_preview() %>%
#'   check_duration(min_duration = 100, quiet = TRUE)
#'
check_duration <- function(.data, min_duration = 10, max_duration = NULL, duration_col = "Duration (in seconds)", print_tibble = TRUE, quiet = FALSE) {

  # Check for presence of required column
  column_names <- names(.data)
  if (!duration_col %in% column_names) stop("The column specifying duration (duration_col) is incorrect. Please check your data and specify 'duration_col'.")

  # Quote column names
  duration_col <- dplyr::ensym(duration_col)

  # Extract duration vector
  duration_vector <- dplyr::pull(.data, duration_col)

  # Check column type
  if (!is.numeric(duration_vector)) {
    stop("Incorrect data type for duration_col. Please ensure data type is numeric.")
  }

  # Find participants quicker than minimum
  if (!is.null(min_duration)) {
    too_quick <- too_quick_slow <- dplyr::filter(.data, !!duration_col < min_duration)
    n_too_quick <- nrow(too_quick)
    if (quiet == FALSE) {
      message(n_too_quick, " out of ", nrow(.data), " rows took less time than the minimum duration of ", min_duration, " seconds.")
    }
  }
  # Find participants slower than maximum
  if (!is.null(max_duration)) {
    too_slow <- too_quick_slow <- dplyr::filter(.data, !!duration_col > max_duration)
    n_too_slow <- nrow(too_slow)
    if (quiet == FALSE) {
      message(n_too_slow, " out of ", nrow(.data), " rows took more time than the maximum duration of ", max_duration, " seconds.")
    }
  }
  # Combine quick and slow participants
  if (!is.null(min_duration) & !is.null(max_duration)) {
    too_quick_slow <- rbind(too_quick, too_slow)
  } else if (is.null(min_duration) & is.null(max_duration)) {
    warning("You must specify either a minimum or maximum duration with 'min_duration' or 'max_duration.'")
    too_quick_slow <- NULL
  }
  if (print_tibble == TRUE) {
    return(too_quick_slow)
  } else {
    invisible(too_quick_slow)
  }
}
