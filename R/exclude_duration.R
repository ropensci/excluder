#' Exclude rows with minimum or maximum durations
#'
#' @description
#' The `exclude_duration()` function removes
#' rows of data that have durations that are too fast or too slow.
#' The function is written to work with data from
#' [Qualtrics](https://www.qualtrics.com/) surveys.
#'
#' @inherit check_duration details
#'
#' @inheritParams exclude_duplicates
#'
#' @family duration functions
#' @family exclude functions
#' @return
#' An object of the same type as `x` that excludes rows
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
exclude_duration <- function(x,
                             id_col = "ResponseId",
                             silent = FALSE,
                             ...) {

  # Check for presence of required column
  column_names <- names(x)
  if (!id_col %in% column_names) {
    stop("The column specifying the participant ID (id_col) is incorrect. Please check your data and specify 'id_col'.")
  }

  # Find rows to exclude
  exclusions <- check_duration(x, quiet = TRUE, ...)
  n_exclusions <- nrow(exclusions)

  # Exclude rows
  remaining_data <- dplyr::anti_join(x, exclusions, by = id_col)
  n_remaining <- nrow(remaining_data)
  if (silent == FALSE) {
    message(n_exclusions, " out of ", nrow(x), " rows of short and/or long duration were excluded, leaving ", n_remaining, " rows.")
  }
  return(remaining_data)
}
