#' Exclude unacceptable screen resolution
#'
#' @description
#' The `exclude_resolution()` function removes
#' rows that have unacceptable screen resolution.
#' The function is written to work with data from
#' [Qualtrics](https://qualtrics.com/) surveys.
#'
#' @inherit check_resolution details
#'
#' @inheritParams exclude_duplicates
#'
#' @family resolution functions
#' @family exclude functions
#' @return
#' An object of the same type as `x` that excludes rows
#' that have unacceptable screen resolutions.
#' For a function that checks for these rows, use [check_resolution()].
#' For a function that marks these rows, use [mark_resolution()].
#' @export
#'
#' @examples
#' # Exclude low screen resolutions
#' data(qualtrics_text)
#' df <- exclude_resolution(qualtrics_text)
#'
#' # Remove preview data first
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   exclude_resolution()
#'
exclude_resolution <- function(x, id_col = "ResponseId", silent = FALSE, ...) {

  # Check for presence of required column
  column_names <- names(x)
  if (!id_col %in% column_names) {
    stop("The column specifying the participant ID (id_col) is incorrect. Please check your data and specify 'id_col'.")
  }

  # Find rows to exclude
  exclusions <- check_resolution(x, quiet = TRUE, ...)
  n_exclusions <- nrow(exclusions)

  # Exclude rows
  remaining_data <- dplyr::anti_join(x, exclusions, by = id_col)
  n_remaining <- nrow(remaining_data)
  if (silent == FALSE) {
    message(n_exclusions, " out of ", nrow(x), " rows with unacceptable screen resolution were excluded, leaving ", n_remaining, " rows.")
  }
  return(remaining_data)
}
