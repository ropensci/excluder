#' Mark survey previews
#'
#' @description
#' The `mark_preview()` function creates a column labeling
#' rows that are survey previews.
#' The function is written to work with data from
#' [Qualtrics](https://qualtrics.com) surveys.
#'
#' @inherit check_preview details
#'
#' @inheritParams mark_duplicates
#'
#' @family preview functions
#' @family mark functions
#' @return
#' An object of the same type as `.data` that includes a column marking rows
#' that are survey previews.
#' For a function that checks for these rows, use [check_preview()].
#' For a function that excludes these rows, use [exclude_preview()].
#' @export
#'
#' @examples
#' # Mark survey previews
#' data(qualtrics_text)
#' df <- mark_preview(qualtrics_text)
#'
#' # Works for Qualtrics data exported as numeric values, too
#' df <- qualtrics_numeric %>%
#'   mark_preview()
#'
#' # Do not print rows to console
#' df <- qualtrics_text %>%
#'   mark_preview(print_tibble = FALSE)
#'
mark_preview <- function(.data, id_col = "ResponseId", ...) {

  # Check for presence of required column
  column_names <- names(.data)
  if (!id_col %in% column_names) {
    stop("The column specifying the participant ID (id_col) is incorrect. Please check your data and specify 'id_col'.")
  }

  # Find rows to mark
  exclusions <- excluder::check_preview(.data, ...) %>%
    dplyr::mutate(exclusion_preview = "preview") %>%
    dplyr::select(dplyr::all_of(id_col), .data$exclusion_preview)

  # Mark rows
  dplyr::left_join(.data, exclusions, by = id_col)
}
