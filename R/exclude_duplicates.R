#' Exclude rows with duplicate IP addresses and/or locations
#'
#' The `exclude_duplicates()` function removes
#' rows of data that have the same IP address and/or same latitude and
#' longitude. The function is written to work with data from
#' [Qualtrics](https://qualtrics.com) surveys.
#'
#' Default column names are set based on output from the
#' [qualtRics::fetch_survey]. By default, IP address and location are both
#' checked, but they can be checked separately with the `dupl_ip` and
#' `dupl_location` arguments. The function outputs to console separate
#' messages about the number of rows with duplicate IP addresses and rows
#' with duplicate locations.
#' These counts are computed independently, so rows may be counted for both
#' types of duplicates.
#'
#' This function returns the original data with the duplicate rows removed.
#' For a function that just checks for and returns duplicate rows,
#' use [check_duplicates]. For a function that marks these rows,
#' use [mark_duplicates].
#'
#' @param .data Data frame or tibble (preferably exported from Qualtrics).
#' @param id_col Column name for unique row ID (e.g., participant).
#' @param ... Inherit parameters from [check_duplicates].
#'
#' @family exclude functions
#' @family duplicates functions
#' @return
#' An object of the same type as `.data` that excludes rows with duplicate
#' IP addresses and/or locations.
#' @export
#'
#' @examples
#' # Exclude duplicate IP addresses and locations
#' data(qualtrics_text)
#' df <- exclude_duplicates(qualtrics_text)
#'
#' # Exclude only for duplicate locations
#' df <- exclude_duplicates(qualtrics_text, dupl_location = FALSE)
#'
#' # Do not print message to console
#' df <- exclude_duplicates(qualtrics_text, quiet = TRUE)
exclude_duplicates <- function(.data, id_col = "ResponseId", ...) {

  # Check for presence of required column
  column_names <- names(.data)
  if (!id_col %in% column_names) {
    stop("The column specifying the participant ID (id_col) is incorrect. Please check your data and specify 'id_col'.")
  }

  # Find rows to exclude
  exclusions <- check_duplicates(.data, ...)

  # Exclude rows
  dplyr::anti_join(.data, exclusions, by = id_col)
}
