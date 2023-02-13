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
#' @param rename Logical indicating whether to rename columns (using [rename_columns()])
#' @param quiet Logical indicating whether to print message to console.
#' @param print Logical indicating whether to print returned tibble to
#' console.
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
                         rename = TRUE,
                         quiet = FALSE,
                         print = TRUE) {
  # Rename columns
  if (rename) {
    x <- rename_columns(x, alert = FALSE)
  }

  # Check for presence of required column
  validate_columns(x, id_col)
  validate_columns(x, preview_col)

  # Extract preview vector
  preview_vector <- x[[preview_col]]

  # Check for preview rows
  if (is.character(preview_vector)) {
    filtered_data <- dplyr::filter(x, .data[[preview_col]] == "Survey Preview")
  } else if (is.numeric(preview_vector)) {
    filtered_data <- dplyr::filter(x, .data[[preview_col]] == 1)
  }
  n_previews <- nrow(filtered_data)

  # Print message and return output
  if (identical(quiet, FALSE)) {
    if (n_previews > 0) {
      cli::cli_alert_info(
        "{n_previews} row{?s} w{?as/ere} collected as previews. It is highly recommended to exclude these rows before further processing."
      )
    } else {
      cli::cli_alert_info(
        "{n_previews} out of {nrow(x)} row{?s} {cli::qty(n_previews)}w{?as/ere} collected as previews."
      )
    }
  }

  # Mark exclusion rows
  marked_data <- mark_rows(x, filtered_data, id_col, "preview")
  print_data(marked_data, print)
}


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
#' @inheritParams mark_preview
#' @param keep Logical indicating whether to keep or remove exclusion column.
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
#'   check_preview(print = FALSE)
#'
#' # Do not print message to console
#' qualtrics_text %>%
#'   check_preview(quiet = TRUE)
check_preview <- function(x,
                          id_col = "ResponseId",
                          preview_col = "Status",
                          rename = TRUE,
                          keep = FALSE,
                          quiet = FALSE,
                          print = TRUE) {
  # Mark and filter preview
  exclusions <- mark_preview(x,
    id_col = id_col,
    preview_col = preview_col,
    rename = rename,
    quiet = quiet
  ) %>%
    dplyr::filter(.data$exclusion_preview == "preview") %>%
    keep_marked_column(.data$exclusion_preview, keep)

  # Determine whether to print results
  print_data(exclusions, print)
}


#' Exclude survey previews
#'
#' @description
#' The `exclude_preview()` function removes
#' rows that are survey previews.
#' The function is written to work with data from
#' [Qualtrics](https://www.qualtrics.com/) surveys.
#'
#' @inherit check_preview details
#'
#' @inheritParams mark_preview
#' @param silent Logical indicating whether to print message to console. Note
#' this argument controls the exclude message not the check message.
#'
#' @family preview functions
#' @family exclude functions
#' @return
#' An object of the same type as `x` that excludes rows
#' that are survey previews.
#' For a function that checks for these rows, use [check_preview()].
#' For a function that marks these rows, use [mark_preview()].
#' @export
#'
#' @examples
#' # Exclude survey previews
#' data(qualtrics_text)
#' df <- exclude_preview(qualtrics_text)
#'
#' # Works for Qualtrics data exported as numeric values, too
#' df <- qualtrics_numeric %>%
#'   exclude_preview()
#'
#' # Do not print rows to console
#' df <- qualtrics_text %>%
#'   exclude_preview(print = FALSE)
exclude_preview <- function(x,
                            id_col = "ResponseId",
                            preview_col = "Status",
                            rename = TRUE,
                            quiet = TRUE,
                            print = TRUE,
                            silent = FALSE) {
  # Mark and filter preview
  remaining_data <- mark_preview(x,
    id_col = id_col,
    preview_col = preview_col,
    rename = rename,
    quiet = quiet
  ) %>%
    dplyr::filter(.data$exclusion_preview != "preview") %>%
    dplyr::select(-.data$exclusion_preview)

  # Print exclusion statement
  if (identical(silent, FALSE)) {
    print_exclusion(remaining_data, x, "preview rows")
  }

  # Determine whether to print results
  print_data(remaining_data, print)
}
