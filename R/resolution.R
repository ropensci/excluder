#' Mark unacceptable screen resolution
#'
#' @description
#' The `mark_resolution()` function creates a column labeling
#' rows that have unacceptable screen resolution.
#' The function is written to work with data from
#' [Qualtrics](https://www.qualtrics.com/) surveys.
#'
#' @details
#' To record this information in your Qualtrics survey, you must
#' [insert a meta info question](https://www.qualtrics.com/support/survey-platform/survey-module/editing-questions/question-types-guide/advanced/meta-info-question/).
#'
#' Default column names are set based on output from the
#' [`qualtRics::fetch_survey()`](
#' https://docs.ropensci.org/qualtRics/reference/fetch_survey.html).
#'
#' The function outputs to console a message about the number of rows
#' with unacceptable screen resolution.
#'
#' @param x Data frame (preferably imported from Qualtrics using \{qualtRics\}).
#' @param res_min Minimum acceptable screen resolution (width and height).
#' @param width_min Minimum acceptable screen width.
#' @param height_min Minimum acceptable screen height.
#' @param id_col Column name for unique row ID (e.g., participant).
#' @param res_col Column name for screen resolution (in format widthxheight).
#' @param rename Logical indicating whether to rename columns (using [rename_columns()])
#' @param quiet Logical indicating whether to print message to console.
#' @param print Logical indicating whether to print returned tibble to
#' console.
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
                            res_min = 1000,
                            width_min = 0,
                            height_min = 0,
                            id_col = "ResponseId",
                            res_col = "Resolution",
                            rename = TRUE,
                            quiet = FALSE,
                            print = TRUE) {
  # Rename columns
  if (rename) {
    x <- rename_columns(x, alert = FALSE)
    id_col <- "ResponseId"
  }

  # Check for presence of required column
  validate_columns(x, id_col)
  validate_columns(x, res_col)

  # Extract duration vector
  res_vector <- x[[res_col]]

  # Check width or height minimum
  stopifnot("width_min should have a single value" = length(width_min) == 1L)
  stopifnot("height_min should have a single value" = length(height_min) == 1L)
  if (identical(res_min, 0) && identical(width_min, 0) &&
    identical(height_min, 0)) {
    stop(paste0(
      "You must specify a minimum resolution for width or height ",
      "with 'width_min' or 'height_min'."
    ))
  }

  # Check column type
  if (!is.character(res_vector)) {
    stop("Please ensure that 'res_col' data type is character.")
  } else if (any(stringr::str_detect(res_vector, "x") == FALSE, na.rm = TRUE)) {
    stop("Resolution column includes values not using widthxheight format.")
  }

  filtered_data <- x %>%
    tidyr::separate(res_col,
      c("width", "height"),
      sep = "x",
      remove = FALSE
    ) %>%
    dplyr::mutate(
      width = readr::parse_number(.data$width),
      height = readr::parse_number(.data$height)
    ) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(max_res = max(dplyr::across(c("width", "height")))) %>%
    dplyr::filter(.data$max_res < res_min | .data$width < width_min |
      .data$height < height_min)
  n_wrong_resolution <- nrow(filtered_data)

  # Print message and return output
  if (identical(quiet, FALSE)) {
    cli::cli_alert_info(
      "{n_wrong_resolution} out of {nrow(x)} row{?/s} had screen resolutions less than {width_min} or height less than {height_min}."
    )
  }

  # Mark exclusion rows
  marked_data <- mark_rows(x, filtered_data, id_col, "resolution")
  print_data(marked_data, print)
}


#' Check screen resolution
#'
#' @description
#' The `check_resolution()` function subsets rows of data, retaining rows
#' that have unacceptable screen resolution. This can be used, for example, to
#' determine data collected via phones when desktop monitors are required.
#' The function is written to work with data from
#' [Qualtrics](https://www.qualtrics.com/) surveys.
#'
#' @details
#' To record this information in your Qualtrics survey, you must
#' [insert a meta info question](https://www.qualtrics.com/support/survey-platform/survey-module/editing-questions/question-types-guide/advanced/meta-info-question/).
#'
#' Default column names are set based on output from the
#' [`qualtRics::fetch_survey()`](
#' https://docs.ropensci.org/qualtRics/reference/fetch_survey.html).
#'
#' The function outputs to console a message about the number of rows
#' with unacceptable screen resolution.
#'
#' @inheritParams mark_resolution
#' @param keep Logical indicating whether to keep or remove exclusion column.
#'
#' @family resolution functions
#' @family check functions
#' @return The output is a data frame of the rows that have unacceptable screen
#' resolutions. This includes new columns for resolution width and height.
#' For a function that marks these rows, use [mark_resolution()].
#' For a function that excludes these rows, use [exclude_resolution()].
#' @export
#'
#' @examples
#' # Check for survey previews
#' data(qualtrics_text)
#' check_resolution(qualtrics_text)
#'
#' # Remove preview data first
#' qualtrics_text %>%
#'   exclude_preview() %>%
#'   check_resolution()
#'
#' # Do not print rows to console
#' qualtrics_text %>%
#'   exclude_preview() %>%
#'   check_resolution(print = FALSE)
#'
#' # Do not print message to console
#' qualtrics_text %>%
#'   exclude_preview() %>%
#'   check_resolution(quiet = TRUE)
check_resolution <- function(x,
                             res_min = 1000,
                             width_min = 0,
                             height_min = 0,
                             id_col = "ResponseId",
                             res_col = "Resolution",
                             rename = TRUE,
                             keep = FALSE,
                             quiet = FALSE,
                             print = TRUE) {
  # Mark and filter resolution
  exclusions <- mark_resolution(x,
    width_min = width_min,
    height_min = height_min,
    id_col = id_col,
    res_col = res_col,
    rename = rename,
    quiet = quiet
  ) %>%
    dplyr::filter(.data$exclusion_resolution == "resolution") %>%
    keep_marked_column("exclusion_resolution", keep)

  # Determine whether to print results
  print_data(exclusions, print)
}


#' Exclude unacceptable screen resolution
#'
#' @description
#' The `exclude_resolution()` function removes
#' rows that have unacceptable screen resolution.
#' The function is written to work with data from
#' [Qualtrics](https://www.qualtrics.com/) surveys.
#'
#' @inherit check_resolution details
#'
#' @inheritParams mark_resolution
#' @param silent Logical indicating whether to print message to console. Note
#' this argument controls the exclude message not the check message.
#'
#' @family resolution functions
#' @family exclude functions
#' @return
#' An object of the same type as `x` that excludes rows
#' that have unacceptable screen resolutions.
#' For a function that checks for these rows, use [check_resolution()].
#' For a function that marks these rows, use [mark_resolution()].
#' @export
#'
#' @examples
#' # Exclude low screen resolutions
#' data(qualtrics_text)
#' df <- exclude_resolution(qualtrics_text)
#'
#' # Remove preview data first
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   exclude_resolution()
exclude_resolution <- function(x,
                               res_min = 1000,
                               width_min = 0,
                               height_min = 0,
                               id_col = "ResponseId",
                               res_col = "Resolution",
                               rename = TRUE,
                               quiet = TRUE,
                               print = TRUE,
                               silent = FALSE) {
  # Mark and filter resolution
  remaining_data <- mark_resolution(x,
    width_min = width_min,
    height_min = height_min,
    id_col = id_col,
    res_col = res_col,
    rename = rename,
    quiet = quiet
  ) %>%
    dplyr::filter(.data$exclusion_resolution != "resolution") %>%
    dplyr::select(-"exclusion_resolution")

  # Print exclusion statement
  if (identical(silent, FALSE)) {
    print_exclusion(
      remaining_data, x,
      "rows with unacceptable screen resolution"
    )
  }

  # Determine whether to print results
  print_data(remaining_data, print)
}
