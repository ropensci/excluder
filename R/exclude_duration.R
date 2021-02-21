#' Exclude rows with minimum or maximum durations
#'
#' @description
#' The `exclude_duration()` function removes
#' rows of data that have durations that are too fast or too slow.
#' The function is written to work with data from
#' [Qualtrics](https://qualtrics.com) surveys.
#'
#' @inherit check_duration details
#'
#' @inheritParams exclude_duplicates
#'
#' @family duration functions
#' @family exclude functions
#' @return
#' An object of the same type as `.data` that excludes rows
#' with fast and/or slow duration.
#' For a function that checks for these rows, use [check_duration()].
#' For a function that marks these rows, use [mark_duration()].
#' @export
#'
#' @examples
#' # Exclude durations faster than 100 seconds
#' data(qualtrics_text)
#' df <- exclude_duration(qualtrics_text, min_duration = 100)
#'
#' # Remove preview data first
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   exclude_duration()
#'
#' # Exclude only for durations slower than 800 seconds
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   exclude_duration(max_duration = 800)
#'
#' # Do not print message to console
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   exclude_duration(min_duration = 100, quiet = TRUE)
#'
exclude_duration <- function(.data, id_col = "ResponseId", ...) {

  # Check for presence of required column
  column_names <- names(.data)
  if (!id_col %in% column_names) {
    stop("The column specifying the participant ID (id_col) is incorrect. Please check your data and specify 'id_col'.")
  }

  # Find rows to exclude
  exclusions <- check_duration(.data, ...)

  # Exclude rows
  dplyr::anti_join(.data, exclusions, by = id_col)
}
