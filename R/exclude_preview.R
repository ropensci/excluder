#' Exclude survey previews
#'
#' @description
#' The `exclude_preview()` function removes
#' rows that are survey previews.
#' The function is written to work with data from
#' [Qualtrics](https://www.qualtrics.com/) surveys.
#'
#' @inherit check_preview details
#'
#' @inheritParams exclude_duplicates
#'
#' @family preview functions
#' @family exclude functions
#' @return
#' An object of the same type as `x` that excludes rows
#' that are survey previews.
#' For a function that checks for these rows, use [check_preview()].
#' For a function that marks these rows, use [mark_preview()].
#' @export
#'
#' @examples
#' # Exclude survey previews
#' data(qualtrics_text)
#' df <- exclude_preview(qualtrics_text)
#'
#' # Works for Qualtrics data exported as numeric values, too
#' df <- qualtrics_numeric %>%
#'   exclude_preview()
#'
#' # Do not print rows to console
#' df <- qualtrics_text %>%
#'   exclude_preview(print_tibble = FALSE)
#'
exclude_preview <- function(x, id_col = "ResponseId", silent = FALSE, ...) {

  # Check for presence of required column
  column_names <- names(x)
  if (!id_col %in% column_names) {
    stop("The column specifying the participant ID (id_col) is incorrect. Please check your data and specify 'id_col'.")
  }

  # Find rows to exclude
  exclusions <- check_preview(x, quiet = TRUE, ...)
  n_exclusions <- nrow(exclusions)

  # Exclude rows
  remaining_data <- dplyr::anti_join(x, exclusions, by = id_col)
  n_remaining <- nrow(remaining_data)
  if (silent == FALSE) {
    message(n_exclusions, " out of ", nrow(x), " preview rows were excluded, leaving ", n_remaining, " rows.")
  }
  return(remaining_data)
}
