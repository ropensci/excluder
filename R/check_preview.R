#' Check for survey previews
#'
#' @description
#' The `check_preview()` function subsets rows of data, retaining rows
#' that are survey previews.
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
#' @param x Data frame (preferably directly from Qualtrics imported
#' using {qualtRics}.)
#' @param preview_col Column name for survey preview.
#' @param print_tibble Logical indicating whether to print returned tibble to
#' console.
#' @param quiet Logical indicating whether to print message to console.
#'
#' @family preview functions
#' @family check functions
#' @return The output is a data frame of the rows
#' that are survey previews.
#' For a function that marks these rows, use [mark_preview()].
#' For a function that excludes these rows, use [exclude_preview()].
#' @export
#'
#' @examples
#' # Check for survey previews
#' data(qualtrics_text)
#' check_preview(qualtrics_text)
#'
#' # Works for Qualtrics data exported as numeric values, too
#' qualtrics_numeric %>%
#'   check_preview()
#'
#' # Do not print rows to console
#' qualtrics_text %>%
#'   check_preview(print_tibble = FALSE)
#'
#' # Do not print message to console
#' qualtrics_text %>%
#'   check_preview(quiet = TRUE)
check_preview <- function(x,
                          preview_col = "Status",
                          print_tibble = TRUE,
                          quiet = FALSE) {

  # Check for presence of required column
  column_names <- names(x)
  stopifnot("preview_col should have a single column name" =
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
              " rows were collected as previews. It is highly recommended to exclude these rows before further checking.")
    } else {
      message(n_previews, " out of ", nrow(x),
              " rows were collected as previews.")
    }
  }
  if (identical(print_tibble, TRUE)) {
    return(filtered_data)
  } else {
    invisible(filtered_data)
  }
}
