#' Mark survey progress
#'
#' @description
#' The `mark_progress()` function creates a column labeling
#' rows that have incomplete progress.
#' The function is written to work with data from
#' [Qualtrics](https://qualtrics.com/) surveys.
#'
#' @inherit check_progress details
#'
#' @inheritParams mark_duplicates
#'
#' @family progress functions
#' @family mark functions
#' @return
#' An object of the same type as `x` that includes a column marking rows
#' that have incomplete progress.
#' For a function that checks for these rows, use [check_progress()].
#' For a function that excludes these rows, use [exclude_progress()].
#' @export
#'
#' @examples
#' # Mark rows with incomplete progress
#' data(qualtrics_text)
#' df <- mark_progress(qualtrics_text)
#'
#' # Remove preview data first
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   mark_progress()
#'
#' # Include a lower acceptable completion percentage
#' df <- qualtrics_numeric %>%
#'   exclude_preview() %>%
#'   mark_progress(min_progress = 98)
#'
#' # Do not print rows to console
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   mark_progress(print_tibble = FALSE)
#'
mark_progress <- function(x, id_col = "ResponseId", ...) {

  # Check for presence of required column
  column_names <- names(x)
  if (!id_col %in% column_names) {
    stop("The column specifying the participant ID (id_col) is incorrect. Please check your data and specify 'id_col'.")
  }

  # Find rows to mark
  exclusions <- excluder::check_progress(x, ...) %>%
    dplyr::mutate(exclusion_progress = "incomplete_progress") %>%
    dplyr::select(dplyr::all_of(id_col), .data$exclusion_progress)

  # Mark rows
  dplyr::left_join(x, exclusions, by = id_col)
}
