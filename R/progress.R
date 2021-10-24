#' Mark survey progress
#'
#' @description
#' The `mark_progress()` function creates a column labeling
#' rows that have incomplete progress.
#' The function is written to work with data from
#' [Qualtrics](https://www.qualtrics.com/) surveys.
#'
#' @details
#' Default column names are set based on output from the
#' [`qualtRics::fetch_survey()`](
#' https://docs.ropensci.org/qualtRics/reference/fetch_survey.html).
#' The default requires 100% completion, but lower levels of completion
#' maybe acceptable and can be allowed by specifying the `min_progress`
#' argument.
#' The finished column in Qualtrics can be a numeric or character vector
#' depending on whether it is exported as choice text or numeric values.
#' This function works for both.
#'
#' The function outputs to console a message about the number of rows
#' that have incomplete progress.
#'
#' @param x Data frame (preferably imported from Qualtrics using \{qualtRics\}).
#' @param min_progress Amount of progress considered acceptable to include.
#' @param id_col Column name for unique row ID (e.g., participant).
#' @param finished_col Column name for whether survey was completed.
#' @param progress_col Column name for percentage of survey completed.
#' @param quiet Logical indicating whether to print message to console.
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
mark_progress <- function(x,
                          min_progress = 100,
                          id_col = "ResponseId",
                          finished_col = "Finished",
                          progress_col = "Progress",
                          quiet = FALSE) {

  # Check for presence of required column
  validate_columns(x, id_col)
  validate_columns(x, finished_col)
  validate_columns(x, progress_col)

  # Find incomplete cases
  if (is.logical(x[[finished_col]])) {
    incomplete <- dplyr::filter(x, .data[[finished_col]] == FALSE)
  } else if (is.numeric(x[[finished_col]])) {
    incomplete <- dplyr::filter(x, .data[[finished_col]] == 0)
  } else {
    stop(
      "The column ", finished_col,
      " is not of type logical or numeric, so it cannot be checked."
    )
  }
  n_incomplete <- nrow(incomplete)

  # If minimum percent specified, find cases below minimum
  stopifnot(
    "min_progress should have a single value" =
      length(min_progress) == 1L
  )
  if (min_progress < 100) {
    incomplete <- dplyr::filter(x, .data[[progress_col]] < min_progress)
    n_below_min <- nrow(incomplete)
    if (identical(quiet, FALSE)) {
      cli::cli_alert_info(
        "{n_incomplete} row{?/s} did not complete the study, and {n_below_min} of those completed less than {min_progress}% of the study."
      )
    }
  } else {
    if (identical(quiet, FALSE)) {
      cli::cli_alert_info(
        "{n_incomplete} out of {nrow(x)} row{?/s} did not complete the study."
      )
    }
  }

  # Find rows to mark
  exclusions <- incomplete %>%
    dplyr::mutate(exclusion_progress = "incomplete_progress") %>%
    dplyr::select(tidyselect::all_of(id_col), .data$exclusion_progress)

  # Mark rows
  invisible(dplyr::left_join(x, exclusions, by = id_col) %>%
    dplyr::mutate(
      exclusion_progress =
        stringr::str_replace_na(
          .data$exclusion_progress, ""
        )
    ))
}

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
#' [`qualtRics::fetch_survey()`](
#' https://docs.ropensci.org/qualtRics/reference/fetch_survey.html).
#' The default requires 100% completion, but lower levels of completion
#' maybe acceptable and can be allowed by specifying the `min_progress`
#' argument.
#' The finished column in Qualtrics can be a numeric or character vector
#' depending on whether it is exported as choice text or numeric values.
#' This function works for both.
#'
#' The function outputs to console a message about the number of rows
#' that have incomplete progress.
#'
#' @inheritParams mark_progress
#' @param print Logical indicating whether to print returned tibble to
#' console.
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
#'   check_progress(print = FALSE)
#'
#' # Do not print message to console
#' qualtrics_text %>%
#'   exclude_preview() %>%
#'   check_progress(quiet = TRUE)
check_progress <- function(x,
                           min_progress = 100,
                           id_col = "ResponseId",
                           finished_col = "Finished",
                           progress_col = "Progress",
                           quiet = FALSE,
                           print = TRUE) {

  # Mark and filter progress
  exclusions <- mark_progress(x,
    min_progress = min_progress,
    id_col = id_col,
    finished_col = finished_col,
    progress_col = progress_col,
    quiet = quiet
  ) %>%
    dplyr::filter(.data$exclusion_progress == "incomplete_progress") %>%
    dplyr::select(-.data$exclusion_progress)

  # Determine whether to print results
  print_data(exclusions, print)
}

#' Exclude survey progress
#'
#' @description
#' The `exclude_progress()` function removes
#' rows that have incomplete progress.
#' The function is written to work with data from
#' [Qualtrics](https://www.qualtrics.com/) surveys.
#'
#' @inherit check_progress details
#'
#' @inheritParams mark_progress
#' @param print Logical indicating whether to print returned tibble to
#' console.
#' @param silent Logical indicating whether to print message to console. Note
#' this argument controls the exclude message not the check message.
#'
#' @family progress functions
#' @family exclude functions
#' @return
#' An object of the same type as `x` that excludes rows
#' that have incomplete progress.
#' For a function that checs for these rows, use [check_progress()].
#' For a function that marks these rows, use [mark_progress()].
#' @export
#'
#' @examples
#' # Exclude rows with incomplete progress
#' data(qualtrics_text)
#' df <- exclude_progress(qualtrics_text)
#'
#' # Remove preview data first
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   exclude_progress()
#'
#' # Include a lower acceptable completion percentage
#' df <- qualtrics_numeric %>%
#'   exclude_preview() %>%
#'   exclude_progress(min_progress = 98)
#'
#' # Do not print rows to console
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   exclude_progress(print = FALSE)
exclude_progress <- function(x,
                             min_progress = 100,
                             id_col = "ResponseId",
                             finished_col = "Finished",
                             progress_col = "Progress",
                             quiet = TRUE,
                             print = FALSE,
                             silent = FALSE) {

  # Mark and filter progress
  remaining_data <- mark_progress(x,
    min_progress = min_progress,
    id_col = id_col,
    finished_col = finished_col,
    progress_col = progress_col,
    quiet = quiet
  ) %>%
    dplyr::filter(.data$exclusion_progress != "incomplete_progress") %>%
    dplyr::select(-.data$exclusion_progress)

  # Print exclusion statement
  if (identical(silent, FALSE)) {
    print_exclusion(remaining_data, x, "rows with incomplete progress")
  }

  # Determine whether to print results
  print_data(remaining_data, print)
}
