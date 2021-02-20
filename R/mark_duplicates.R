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
#' This function returns the rows of duplicates. For a function that excludes
#' these rows, use [exclude_duplicates]. For a function that marks these rows,
#' use [mark_duplicates].
#'
#' @param .data
#' @param id_col
#' @param ...
#'
#' @family mark functions
#' @family duplicates functions
#' @return
#' @export
#'
#' @examples
mark_duplicates <- function(.data, id_col = "ResponseId", ...) {

  # Check for presence of required column
  column_names <- names(.data)
  if (!id_col %in% column_names) {
    stop("The column specifying the participant ID (id_col) is incorrect. Please check your data and specify 'id_col'.")
  }

  # Find rows to mark
  exclusions <- excluder::check_duplicates(.data, print_tibble = FALSE) %>%
    dplyr::mutate(exclusion_duplicates = "duplicates_exclusion") %>%
    dplyr::select(dplyr::all_of(id_col), exclusion_duplicates) %>%
    dplyr::distinct()

  # Mark rows
  dplyr::left_join(.data, exclusions, by = id_col)
}
