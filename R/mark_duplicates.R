#' Mark rows with duplicate IP addresses and/or locations
#'
#' The `mark_duplicates()` function creates a column that labels
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
#' This function returns the original data with a column called
#' `exclusion_duplicates` that includes values `duplicates` for rows with
#' duplicate IP addresses and/or location and `NA` for rows without duplicates.
#' For a function that just checks for and returns duplicate rows,
#' use [check_duplicates]. For a function that excludes these rows,
#' use [exclude_duplicates].
#'
#' @param .data Data frame or tibble (preferably exported from Qualtrics).
#' @param id_col Column name for unique row ID (e.g., participant).
#' @param ... Inherit parameters from [check_duplicates].
#'
#' @family mark functions
#' @family duplicates functions
#' @return
#' An object of the same type as `.data` that includes a column marking rows
#' with duplicate IP addresses and/or locations.
#' @export
#'
#' @examples
#' # Mark duplicate IP addresses and locations
#' data(qualtrics_text)
#' df <- mark_duplicates(qualtrics_text)
#'
#' # Mark only for duplicate locations
#' df <- mark_duplicates(qualtrics_text, dupl_location = FALSE)
#'
#' # Do not print message to console
#' df <- mark_duplicates(qualtrics_text, quiet = TRUE)
mark_duplicates <- function(.data, id_col = "ResponseId", ...) {

  # Check for presence of required column
  column_names <- names(.data)
  if (!id_col %in% column_names) {
    stop("The column specifying the participant ID (id_col) is incorrect. Please check your data and specify 'id_col'.")
  }

  # Find rows to mark
  exclusions <- excluder::check_duplicates(.data, ...) %>%
    dplyr::mutate(exclusion_duplicates = "duplicates") %>%
    dplyr::select(dplyr::all_of(id_col), exclusion_duplicates) %>%
    dplyr::distinct()

  # Mark rows
  dplyr::left_join(.data, exclusions, by = id_col)
}
