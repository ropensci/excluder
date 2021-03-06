#' Exclude survey progress
#'
#' @description
#' The `exclude_progress()` function removes
#' rows that have incomplete progress.
#' The function is written to work with data from
#' [Qualtrics](https://qualtrics.com) surveys.
#'
#' @inherit check_progress details
#'
#' @inheritParams exclude_duplicates
#'
#' @family progress functions
#' @family exclude functions
#' @return
#' An object of the same type as `.data` that excludes rows
#' that have incomplete progress.
#' For a function that checs for these rows, use [check_progress()].
#' For a function that marks these rows, use [mark_progress()].
#' @export
#'
#' @examples
#' # Exclude rows with incomplete progress
#' data(qualtrics_text)
#' df <- exclude_progress(qualtrics_text)
#'
#' # Remove preview data first
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   exclude_progress()
#'
#' # Include a lower acceptable completion percentage
#' df <- qualtrics_numeric %>%
#'   exclude_preview() %>%
#'   exclude_progress(min_progress = 98)
#'
#' # Do not print rows to console
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   exclude_progress(print_tibble = FALSE)
#'
exclude_progress <- function(.data, id_col = "ResponseId", silent = FALSE, ...) {

  # Check for presence of required column
  column_names <- names(.data)
  if (!id_col %in% column_names) {
    stop("The column specifying the participant ID (id_col) is incorrect. Please check your data and specify 'id_col'.")
  }

  # Find rows to exclude
  exclusions <- check_progress(.data, quiet = TRUE, ...)
  n_exclusions <- nrow(exclusions)

  # Exclude rows
  remaining_data <- dplyr::anti_join(.data, exclusions, by = id_col)
  n_remaining <- nrow(remaining_data)
  if (silent == FALSE) {
    message(n_exclusions, " out of ", nrow(.data), " rows with incomplete progress were excluded, leaving ", n_remaining, " rows.")
  }
  return(remaining_data)
}
