#' Mark minimum or maximum durations
#'
#' @description
#' The `mark_duration()` function creates a column labeling
#' rows with fast and/or slow duration.
#' The function is written to work with data from
#' [Qualtrics](https://www.qualtrics.com/) surveys.
#'
#' @details
#' Default column names are set based on output from the
#' [`qualtRics::fetch_survey()`](
#' https://docs.ropensci.org/qualtRics/reference/fetch_survey.html).
#' By default, minimum durations of 10 seconds are checked, but either
#' minima or maxima can be checked with the `min_duration` and
#' `max_duration` arguments. The function outputs to console separate
#' messages about the number of rows that are too fast or too slow.
#'
#' This function returns the fast and slow rows.
#'
#' @param x Data frame (preferably imported from Qualtrics using \{qualtRics\}).
#' @param min_duration Minimum duration that is too fast in seconds.
#' @param max_duration Maximum duration that is too slow in seconds.
#' @param id_col Column name for unique row ID (e.g., participant).
#' @param duration_col Column name for durations.
#' @param quiet Logical indicating whether to print message to console.
#'
#' @family duration functions
#' @family mark functions
#' @return
#' An object of the same type as `x` that includes a column marking rows
#' with fast and slow duration.
#' For a function that checks for these rows, use [check_duration()].
#' For a function that excludes these rows, use [exclude_duration()].
#' @export
#'
#' @examples
#' # Mark durations faster than 100 seconds
#' data(qualtrics_text)
#' df <- mark_duration(qualtrics_text, min_duration = 100)
#'
#' # Remove preview data first
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   mark_duration()
#'
#' # Mark only for durations slower than 800 seconds
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   mark_duration(max_duration = 800)
mark_duration <- function(x,
                          min_duration = 10,
                          max_duration = NULL,
                          id_col = "ResponseId",
                          duration_col = "Duration (in seconds)",
                          quiet = FALSE) {

  # Check for presence of required columns
  column_names <- names(x)
  ## id_col
  stopifnot("'id_col' should only have a single column name" =
              length(id_col) == 1L)
  if (!id_col %in% column_names) {
    stop("The column specifying the participant ID ('id_col') was not found.")
  }
  ## duration_col
  stopifnot("'duration_col' should have a single column name" =
              length(duration_col) == 1L)
  if (!duration_col %in% column_names) {
    stop("The column specifying duration ('duration_col') was not found.")
  }

  # Extract duration vector
  duration_vector <- x[[duration_col]]

  # Check column type
  if (!is.numeric(duration_vector)) {
    stop("Please ensure 'duration_col' data type is numeric.")
  }

  # Find participants quicker than minimum
  stopifnot("'min_duration' should have a single value" =
              length(min_duration) == 1L)
  if (!is.null(min_duration)) {
    too_quick <- too_quick_slow <- x[which(duration_vector < min_duration), ]
    n_too_quick <- nrow(too_quick)
    if (identical(quiet, FALSE)) {
      message(n_too_quick, " out of ", nrow(x),
              " rows took less time than the minimum duration of ",
              min_duration, " seconds.")
    }
  }

  # Find participants slower than maximum
  if (!is.null(max_duration)) {
    stopifnot("'max_duration' should have a single value" =
                length(max_duration) == 1L)
    too_slow <- too_quick_slow <- x[which(duration_vector > max_duration), ]
    n_too_slow <- nrow(too_slow)
    if (identical(quiet, FALSE)) {
      message(n_too_slow, " out of ", nrow(x),
              " rows took more time than the maximum duration of ",
              max_duration, " seconds.")
    }
  }

  # Combine quick and slow participants
  if (!is.null(min_duration) & !is.null(max_duration)) {
    too_quick_slow <- dplyr::bind_rows(too_quick, too_slow)
  } else if (is.null(min_duration) & is.null(max_duration)) {
    stop("You must specify either a minimum or maximum duration.'")
    too_quick_slow <- NULL
  }

  # Find rows to mark
  exclusions <- too_quick_slow %>%
    dplyr::mutate(exclusion_duration = "duration") %>%
    dplyr::select(tidyselect::all_of(id_col), .data$exclusion_duration)

  # Mark rows
  invisible(dplyr::left_join(x, exclusions, by = id_col) %>%
              dplyr::mutate(exclusion_duration =
                              stringr::str_replace_na(.data$exclusion_duration, "")))
}
