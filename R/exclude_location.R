#' Exclude locations outside of US
#'
#' @description
#' The `exclude_location()` function removes
#' rows that have locations outside of the US.
#' The function is written to work with data from
#' [Qualtrics](https://qualtrics.com) surveys.
#'
#' @inherit check_location details
#'
#' @inheritParams exclude_duplicates
#'
#' @family location functions
#' @family exclude functions
#' @return
#' An object of the same type as `.data` that excludes rows
#' that are located outside of the US and (if `include_na == FALSE`) rows with
#' no location information.
#' For a function that checks for these rows, use [check_location()].
#' For a function that marks these rows, use [mark_location()].
#' @export
#'
#' @examples
#' # Exclude locations outside of the US
#' data(qualtrics_text)
#' df <- exclude_location(qualtrics_text)
#'
#' # Remove preview data first
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   exclude_location()
#'
#' # Do not print message to console
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   exclude_location(quiet = TRUE)
#'
exclude_location <- function(.data, id_col = "ResponseId", ...) {

  # Check for presence of required column
  column_names <- names(.data)
  if (!id_col %in% column_names) {
    stop("The column specifying the participant ID (id_col) is incorrect. Please check your data and specify 'id_col'.")
  }

  # Find rows to exclude
  exclusions <- check_location(.data, quiet = TRUE, ...)
  n_exclusions <- nrow(exclusions)

  # Exclude rows
  remaining_data <- dplyr::anti_join(.data, exclusions, by = id_col)
  n_remaining <- nrow(remaining_data)
  message(n_exclusions, " rows outside of the US were excluded, leaving ", n_remaining, " rows.")
  return(remaining_data)
}
