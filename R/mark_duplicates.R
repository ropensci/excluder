#' Mark duplicate IP addresses and/or locations
#'
#' @description
#' The `mark_duplicates()` function creates a column labeling
#' rows of data that have the same IP address and/or same latitude and
#' longitude. The function is written to work with data from
#' [Qualtrics](https://qualtrics.com/) surveys.
#'
#' @inherit check_duplicates details
#'
#' @param .data Data frame or tibble (preferably exported from Qualtrics).
#' @param id_col Column name for unique row ID (e.g., participant).
#' @param ... Inherit parameters from check function.
#'
#' @family duplicates functions
#' @family mark functions
#' @return
#' An object of the same type as `.data` that includes a column marking rows
#' with duplicate IP addresses and/or locations.
#' For a function that just checks for and returns duplicate rows,
#' use [check_duplicates()]. For a function that excludes these rows,
#' use [exclude_duplicates()].
#'
#' @export
#'
#' @examples
#' # Mark duplicate IP addresses and locations
#' data(qualtrics_text)
#' df <- mark_duplicates(qualtrics_text)
#'
#' # Remove preview data first
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   mark_duplicates()
#'
#' # Mark only for duplicate locations
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   mark_duplicates(dupl_location = FALSE)
#'
mark_duplicates <- function(.data, id_col = "ResponseId", ...) {

  # Check for presence of required column
  column_names <- names(.data)
  if (!id_col %in% column_names) {
    stop("The column specifying the participant ID (id_col) is incorrect. Please check your data and specify 'id_col'.")
  }

  # Find rows to mark
  exclusions <- excluder::check_duplicates(.data, ...) %>%
    dplyr::mutate(exclusion_duplicates = "duplicates") %>%
    dplyr::select(dplyr::all_of(id_col), .data$exclusion_duplicates) %>%
    dplyr::distinct()

  # Mark rows
  dplyr::left_join(.data, exclusions, by = id_col)
}
