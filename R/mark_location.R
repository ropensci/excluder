#' Mark locations outside of US
#'
#' @description
#' The `mark_location()` function creates a column labeling
#' rows that have locations outside of the US.
#' The function is written to work with data from
#' [Qualtrics](https://qualtrics.com) surveys.
#'
#' @inherit check_location details
#'
#' @inheritParams mark_duplicates
#'
#' @family location functions
#' @family mark functions
#' @return
#' An object of the same type as `.data` that includes a column marking rows
#' that are located outside of the US and (if `include_na == FALSE`) rows with
#' no location information.
#' For a function that checks for these rows, use [check_location()].
#' For a function that excludes these rows, use [exclude_location()].
#' @export
#'
#' @examples
#' # Mark locations outside of the US
#' data(qualtrics_text)
#' df <- mark_location(qualtrics_text)
#'
#' # Remove preview data first
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   mark_location()
#'
#' # Do not print message to console
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   mark_location(quiet = TRUE)
#'
mark_location <- function(.data, id_col = "ResponseId", ...) {

  # Check for presence of required column
  column_names <- names(.data)
  if (!id_col %in% column_names) {
    stop("The column specifying the participant ID (id_col) is incorrect. Please check your data and specify 'id_col'.")
  }

  # Find rows to mark
  exclusions <- excluder::check_location(.data, ...) # %>%
  exclusions$exclusion_location <- "location_outside_us"
  exclusions <- dplyr::select(exclusions, dplyr::all_of(id_col), exclusion_location)

  # Mark rows
  dplyr::left_join(.data, exclusions, by = id_col)
}
