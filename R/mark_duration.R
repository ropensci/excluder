#' Mark minimum or maximum durations
#'
#' @description
#' The `mark_duration()` function creates a column labeling
#' rows with fast and/or slow duration.
#' The function is written to work with data from
#' [Qualtrics](https://www.qualtrics.com/) surveys.
#'
#' @inherit check_duration details
#'
#' @inheritParams mark_duplicates
#'
#' @family duration functions
#' @family mark functions
#' @return
#' An object of the same type as `x` that includes a column marking rows
#' with fast and slow duration.
#' For a function that checks for these rows, use [check_duration()].
#' For a function that excludes these rows, use [exclude_duration()].
#' @export
#'
#' @examples
#' # Mark durations faster than 100 seconds
#' data(qualtrics_text)
#' df <- mark_duration(qualtrics_text, min_duration = 100)
#'
#' # Remove preview data first
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   mark_duration()
#'
#' # Mark only for durations slower than 800 seconds
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   mark_duration(max_duration = 800)
mark_duration <- function(x,
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
  exclusions <- check_duration(x, ...) %>%
    dplyr::mutate(exclusion_duration = "duration") %>%
    dplyr::select(dplyr::all_of(id_col), .data$exclusion_duration)

  # Mark rows
  dplyr::left_join(x, exclusions, by = id_col)
}
