#' Mark unacceptable screen resolution
#'
#' @description
#' The `mark_resolution()` function creates a column labeling
#' rows that have unacceptable screen resolution.
#' The function is written to work with data from
#' [Qualtrics](https://qualtrics.com) surveys.
#'
#' @inherit check_resolution details
#'
#' @inheritParams mark_duplicates
#'
#' @family resolution functions
#' @family mark functions
#' @return
#' An object of the same type as `.data` that includes a column marking rows
#' that have unacceptable screen resolutions.
#' For a function that excludes these rows, use [exclude_resolution()].
#' For a function that marks these rows, use [mark_resolution()].
#' @export
#'
#' @examples
#' # Mark low screen resolutions
#' data(qualtrics_text)
#' df <- mark_resolution(qualtrics_text)
#'
#' # Remove preview data first
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   mark_resolution()
#'
#' # Do not print message to console
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   mark_resolution(quiet = TRUE)
#'
mark_resolution <- function(.data, id_col = "ResponseId", ...) {

  # Check for presence of required column
  column_names <- names(.data)
  if (!id_col %in% column_names) {
    stop("The column specifying the participant ID (id_col) is incorrect. Please check your data and specify 'id_col'.")
  }

  # Find rows to mark
  exclusions <- excluder::check_resolution(.data, ...) %>%
    dplyr::mutate(exclusion_resolution = "resolution_exclusion") %>%
    dplyr::select(dplyr::all_of(id_col), exclusion_resolution)

  # Mark rows
  dplyr::left_join(.data, exclusions, by = id_col)
}
