#' Mark unacceptable screen resolution
#'
#' @description
#' The `mark_resolution()` function creates a column labeling
#' rows that have unacceptable screen resolution.
#' The function is written to work with data from
#' [Qualtrics](https://www.qualtrics.com/) surveys.
#'
#' @inherit check_resolution details
#'
#' @inheritParams mark_duplicates
#'
#' @family resolution functions
#' @family mark functions
#' @return
#' An object of the same type as `x` that includes a column marking rows
#' that have unacceptable screen resolutions.
#' For a function that checks for these rows, use [check_resolution()].
#' For a function that excludes these rows, use [exclude_resolution()].
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
mark_resolution <- function(x,
                            id_col = "ResponseId",
                            ...) {

  # Check for presence of required column
  column_names <- names(x)
  if (!id_col %in% column_names) {
    stop("The column specifying the participant ID (id_col) is incorrect. Please check your data and specify 'id_col'.")
  }

  # Find rows to mark
  exclusions <- excluder::check_resolution(x, ...) %>%
    dplyr::mutate(exclusion_resolution = "unacceptable_resolution") %>%
    dplyr::select(dplyr::all_of(id_col), .data$exclusion_resolution)

  # Mark rows
  dplyr::left_join(x, exclusions, by = id_col)
}
