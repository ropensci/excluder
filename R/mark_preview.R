#' Mark survey previews
#'
#' @description
#' The `mark_preview()` function creates a column labeling
#' rows that are survey previews.
#' The function is written to work with data from
#' [Qualtrics](https://www.qualtrics.com/) surveys.
#'
#' @inherit check_preview details
#'
#' @inheritParams mark_duplicates
#'
#' @family preview functions
#' @family mark functions
#' @return
#' An object of the same type as `x` that includes a column marking rows
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
mark_preview <- function(x,
                         id_col = "ResponseId",
                         ...) {

  # Check for presence of required column
  column_names <- names(x)
  stopifnot("id_col should only have a single column name" =
              length(id_col) == 1L)
  if (!id_col %in% column_names) {
    stop("The column specifying the participant ID ('id_col') was not found.")
  }

  # Find rows to mark
  exclusions <- excluder::check_preview(x, ...) %>%
    dplyr::mutate(exclusion_preview = "preview") %>%
    dplyr::select(dplyr::all_of(id_col), .data$exclusion_preview)

  # Mark rows
  dplyr::left_join(x, exclusions, by = id_col)
}
