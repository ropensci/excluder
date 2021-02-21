#' Exclude rows with duplicate IP addresses and/or locations
#'
#' @description
#' The `exclude_duplicates()` function removes
#' rows of data that have the same IP address and/or same latitude and
#' longitude. The function is written to work with data from
#' [Qualtrics](https://qualtrics.com) surveys.
#'
#' @inherit check_duplicates details
#'
#' @param .data Data frame or tibble (preferably exported from Qualtrics).
#' @param id_col Column name for unique row ID (e.g., participant).
#' @param ... Inherit parameters from check function.
#'
#' @family duplicates functions
#' @family exclude functions
#' @return
#' An object of the same type as `.data` that excludes rows
#' with duplicate IP addresses and/or locations.
#' For a function that just checks for and returns duplicate rows,
#' use [check_duplicates()]. For a function that marks these rows,
#' use [mark_duplicates()].

#' @export
#'
#' @examples
#' # Exclude duplicate IP addresses and locations
#' data(qualtrics_text)
#' df <- exclude_duplicates(qualtrics_text)
#'
#' # Remove preview data first
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   exclude_duplicates()
#'
#' # Exclude only for duplicate locations
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   exclude_duplicates(dupl_location = FALSE)
#'
#' # Do not print message to console
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   exclude_duplicates(quiet = TRUE)
#'
exclude_duplicates <- function(.data, id_col = "ResponseId", ...) {

  # Check for presence of required column
  column_names <- names(.data)
  if (!id_col %in% column_names) {
    stop("The column specifying the participant ID (id_col) is incorrect. Please check your data and specify 'id_col'.")
  }

  # Find rows to exclude
  exclusions <- check_duplicates(.data, quiet = TRUE, ...)
  n_exclusions <- nrow(exclusions)

  # Exclude rows
  remaining_data <- dplyr::anti_join(.data, exclusions, by = id_col)
  n_remaining <- nrow(remaining_data)
  message(n_exclusions, " out of ", nrow(.data), " duplicate rows were excluded, leaving ", n_remaining, " rows.")
  return(remaining_data)
}
