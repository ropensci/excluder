#' Mark survey previews
#'
#' @description
#' The `mark_preview()` function creates a column labeling
#' rows that are survey previews.
#' The function is written to work with data from
#' [Qualtrics](https://www.qualtrics.com/) surveys.
#'
#' @details
#' Default column names are set based on output from the
#' [`qualtRics::fetch_survey()`](
#' https://docs.ropensci.org/qualtRics/reference/fetch_survey.html).
#' The preview column in Qualtrics can be a numeric or character vector
#' depending on whether it is exported as choice text or numeric values.
#' This function works for both.
#'
#' The function outputs to console a message about the number of rows
#' that are survey previews.
#'
#' @param x Data frame (preferably imported from Qualtrics using \{qualtRics\}).
#' @param id_col Column name for unique row ID (e.g., participant).
#' @param preview_col Column name for survey preview.
#' @param quiet Logical indicating whether to print message to console.
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
mark_preview <- function(x,
                         id_col = "ResponseId",
                         preview_col = "Status",
                         quiet = FALSE) {

  # Check for presence of required column
  column_names <- names(x)
  ## id_col
  stopifnot("'id_col' should only have a single column name" =
              length(id_col) == 1L)
  if (!id_col %in% column_names) {
    stop("The column specifying the participant ID ('id_col') was not found.")
  }
  ## preview_col
  stopifnot("'preview_col' should have a single column name" =
              length(preview_col) == 1L)
  if (!preview_col %in% column_names) {
    stop("The column specifying previews ('preview_col') was not found.")
  }

  # Check for preview rows
  if (is.character(x[[preview_col]])) {
    filtered_data <- dplyr::filter(x, .data[[preview_col]] == "Survey Preview")
  } else if (is.numeric(x[[preview_col]])) {
    filtered_data <- dplyr::filter(x, .data[[preview_col]] == 1)
  } else {
    stop("The column ", preview_col,
         " is not of type character or numeric, so it cannot be checked.")
  }
  n_previews <- nrow(filtered_data)

  # Print message and return output
  if (identical(quiet, FALSE)) {
    if (n_previews > 0) {
      message(n_previews, " out of ", nrow(x),
              paste0(" rows were collected as previews. It is highly ",
                     "recommended to exclude these rows before further ",
                     "checking."))
    } else {
      message(n_previews, " out of ", nrow(x),
              " rows were collected as previews.")
    }
  }

  # Find rows to mark
  exclusions <- filtered_data %>%
    dplyr::mutate(exclusion_preview = "preview") %>%
    dplyr::select(tidyselect::all_of(id_col), .data$exclusion_preview)

  # Mark rows
  invisible(dplyr::left_join(x, exclusions, by = id_col) %>%
              dplyr::mutate(exclusion_preview =
                              stringr::str_replace_na(.data$exclusion_preview, "")))
}
