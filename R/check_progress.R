#' Check for survey progress
#'
#' @description
#' The `check_progress()` function subsets rows of data, retaining rows
#' that have incomplete progress.
#' The function is written to work with data from
#' [Qualtrics](https://www.qualtrics.com/) surveys.
#'
#' @details
#' Default column names are set based on output from the
#' [qualtRics::fetch_survey()].
#' The default requires 100% completion, but lower levels of completion
#' maybe acceptable and can be allowed by specifying the `min_progress` argument.
#' The finished column in Qualtrics can be a numeric or character vector
#' depending on whether it is exported as choice text or numeric values.
#' This function works for both.
#'
#' The function outputs to console a message about the number of rows
#' that have incomplete progress.
#'
#' @param x Data frame (preferably directly from Qualtrics imported
#' using {qualtRics}.)
#' @param min_progress Amount of progress considered acceptable to include.
#' @param finished_col Column name for whether survey was completed.
#' @param progress_col Column name for percentage of survey completed.
#' @param print_tibble Logical indicating whether to print returned tibble to
#' console.
#' @param quiet Logical indicating whether to print message to console.
#'
#' @family progress functions
#' @family check functions
#' @return The output is a data frame of the rows
#' that have incomplete progress.
#' For a function that marks these rows, use [mark_progress()].
#' For a function that excludes these rows, use [exclude_progress()].
#' @export
#'
#' @examples
#' # Check for rows with incomplete progress
#' data(qualtrics_text)
#' check_progress(qualtrics_text)
#'
#' # Remove preview data first
#' qualtrics_text %>%
#'   exclude_preview() %>%
#'   check_progress()
#'
#' # Include a lower acceptable completion percentage
#' qualtrics_numeric %>%
#'   exclude_preview() %>%
#'   check_progress(min_progress = 98)
#'
#' # Do not print rows to console
#' qualtrics_text %>%
#'   exclude_preview() %>%
#'   check_progress(print_tibble = FALSE)
#'
#' # Do not print message to console
#' qualtrics_text %>%
#'   exclude_preview() %>%
#'   check_progress(quiet = TRUE)
check_progress <- function(x, min_progress = 100, finished_col = "Finished", progress_col = "Progress", print_tibble = TRUE, quiet = FALSE) {

  # Check for presence of required columns
  column_names <- names(x)
  if (!finished_col %in% column_names) stop("The column specifying whether a participant finshed (finished_col) is incorrect. Please check your data and specify finished_col.")
  if (!progress_col %in% column_names) stop("The column specifying participant progress (progress_col) is absent. Please check your data and specify progress_col.")

  # Find incomplete cases
  if (is.logical(dplyr::pull(x, finished_col))) {
    incomplete <- dplyr::filter(x, .data[[finished_col]] == FALSE)
  } else if (is.numeric(dplyr::pull(x, finished_col))) {
    incomplete <- dplyr::filter(x, .data[[finished_col]] == 0)
  } else {
    stop("The column ", finished_col, " is not of type logical or numeric, so it cannot be checked.")
  }
  n_incomplete <- nrow(incomplete)

  # If minimum percent specified, find cases below minimum
  if (min_progress < 100) {
    incomplete <- dplyr::filter(x, .data[[progress_col]] < min_progress)
    n_below_min <- nrow(incomplete)
    if (quiet == FALSE) {
      message(n_incomplete, " rows did not complete the study, and ", n_below_min, " of those completed less than ", min_progress, "% of the study.")
    }
  } else {
    if (quiet == FALSE) {
      message(n_incomplete, " out of ", nrow(x), " rows did not complete the study.")
    }
  }
  if (print_tibble == TRUE) {
    return(incomplete)
  } else {
    invisible(incomplete)
  }
}
