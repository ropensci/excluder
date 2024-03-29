#' Mark locations outside of US
#'
#' @description
#' The `mark_location()` function creates a column labeling
#' rows that have locations outside of the US.
#' The function is written to work with data from
#' [Qualtrics](https://www.qualtrics.com/) surveys.
#'
#' @details
#' To record this information in your Qualtrics survey, you must ensure that
#' [Anonymize responses is disabled](https://www.qualtrics.com/support/survey-platform/survey-module/survey-options/survey-protection/#AnonymizingResponses).
#'
#' Default column names are set based on output from the
#' [`qualtRics::fetch_survey()`](
#' https://docs.ropensci.org/qualtRics/reference/fetch_survey.html).
#' The function only works for the United States.
#' It uses the #' [maps::map.where()] to determine if latitude and longitude
#' are inside the US.
#'
#' The function outputs to console a message about the number of rows
#' with locations outside of the US.
#'
#' @param x Data frame (preferably imported from Qualtrics using \{qualtRics\}).
#' @param id_col Column name for unique row ID (e.g., participant).
#' @param location_col Two element vector specifying columns for latitude
#' and longitude (in that order).
#' @param rename Logical indicating whether to rename columns (using [rename_columns()])
#' @param include_na Logical indicating whether to include rows with NA in
#' latitude and longitude columns in the output list of potentially excluded
#' data.
#' @param quiet Logical indicating whether to print message to console.
#' @param print Logical indicating whether to print returned tibble to
#' console.
#'
#'
#' @family location functions
#' @family mark functions
#' @return
#' An object of the same type as `x` that includes a column marking rows
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
mark_location <- function(x,
                          id_col = "ResponseId",
                          location_col = c(
                            "LocationLatitude",
                            "LocationLongitude"
                          ),
                          rename = TRUE,
                          include_na = FALSE,
                          quiet = FALSE,
                          print = TRUE) {
  # Rename columns
  if (rename) {
    x <- rename_columns(x, alert = FALSE)
    id_col <- "ResponseId"
    location_col <- c("LocationLatitude", "LocationLongitude")
  }

  # Check for presence of required column
  validate_columns(x, id_col)
  validate_columns(x, location_col)

  # Extract latitude and longitude
  latitude <- x[[location_col[1]]]
  longitude <- x[[location_col[2]]]

  # Find number of rows
  n_rows <- nrow(x)

  # Check for participants with no location information
  no_location <-
    dplyr::filter(x, dplyr::if_all(tidyselect::all_of(location_col), is.na))
  n_no_location <- nrow(no_location)
  no_nas <- tidyr::drop_na(x, tidyselect::all_of(location_col))

  # Extract latitude and longitude
  latitude <- no_nas[[location_col[1]]]
  longitude <- no_nas[[location_col[2]]]

  # Determine if geolocation is within US
  no_nas$country <- maps::map.where(database = "usa", longitude, latitude)
  outside_us <- dplyr::filter(no_nas, is.na(.data$country)) %>%
    dplyr::select(-"country")
  n_outside_us <- nrow(outside_us)

  # Combine no location with outside US
  if (identical(include_na, FALSE)) {
    filtered_data <- dplyr::bind_rows(no_location, outside_us)
  } else {
    filtered_data <- outside_us
  }

  # Print messages and return output
  if (identical(quiet, FALSE)) {
    cli::cli_alert_info(
      "{n_no_location} out of {n_rows} row{?s} had no information on location."
    )
    cli::cli_alert_info(
      "{n_outside_us} out of {n_rows} row{?s} {cli::qty(n_outside_us)}w{?as/ere} located outside of the US."
    )
  }

  # Mark exclusion rows
  marked_data <- mark_rows(x, filtered_data, id_col, "location")
  print_data(marked_data, print)
}


#' Check for locations outside of the US
#'
#' @description
#' The `check_location()` function subsets rows of data, retaining rows
#' that have locations outside of the US.
#' The function is written to work with data from
#' [Qualtrics](https://www.qualtrics.com/) surveys.
#'
#' @details
#' To record this information in your Qualtrics survey, you must ensure that
#' [Anonymize responses is disabled](https://www.qualtrics.com/support/survey-platform/survey-module/survey-options/survey-protection/#AnonymizingResponses).
#'
#' Default column names are set based on output from the
#' [`qualtRics::fetch_survey()`](
#' https://docs.ropensci.org/qualtRics/reference/fetch_survey.html).
#' The function only works for the United States.
#' It uses the #' [maps::map.where()] to determine if latitude and longitude
#' are inside the US.
#'
#' The function outputs to console a message about the number of rows
#' with locations outside of the US.
#'
#' @inheritParams mark_location
#' @param keep Logical indicating whether to keep or remove exclusion column.
#'
#' @family location functions
#' @family check functions
#' @return The output is a data frame of the rows that are located outside of
#' the US and (if \code{include_na == FALSE}) rows with no location information.
#' For a function that marks these rows, use [mark_location()].
#' For a function that excludes these rows, use [exclude_location()].
#' @export
#'
#' @examples
#' # Check for locations outside of the US
#' data(qualtrics_text)
#' check_location(qualtrics_text)
#'
#' # Remove preview data first
#' qualtrics_text %>%
#'   exclude_preview() %>%
#'   check_location()
#'
#' # Do not print rows to console
#' qualtrics_text %>%
#'   exclude_preview() %>%
#'   check_location(print = FALSE)
#'
#' # Do not print message to console
#' qualtrics_text %>%
#'   exclude_preview() %>%
#'   check_location(quiet = TRUE)
check_location <- function(x,
                           id_col = "ResponseId",
                           location_col = c(
                             "LocationLatitude",
                             "LocationLongitude"
                           ),
                           rename = TRUE,
                           include_na = FALSE,
                           keep = FALSE,
                           quiet = FALSE,
                           print = TRUE) {
  # Mark and filter location
  exclusions <- mark_location(x,
    id_col = id_col,
    location_col = location_col,
    rename = rename,
    include_na = include_na,
    quiet = quiet
  ) %>%
    dplyr::filter(.data$exclusion_location == "location") %>%
    keep_marked_column("exclusion_location", keep)

  # Determine whether to print results
  print_data(exclusions, print)
}


#' Exclude locations outside of US
#'
#' @description
#' The `exclude_location()` function removes
#' rows that have locations outside of the US.
#' The function is written to work with data from
#' [Qualtrics](https://www.qualtrics.com/) surveys.
#'
#' @inherit check_location details
#'
#' @inheritParams mark_location
#' @param silent Logical indicating whether to print message to console. Note
#' this argument controls the exclude message not the check message.
#'
#' @family location functions
#' @family exclude functions
#' @return
#' An object of the same type as `x` that excludes rows
#' that are located outside of the US and (if `include_na == FALSE`) rows with
#' no location information.
#' For a function that checks for these rows, use [check_location()].
#' For a function that marks these rows, use [mark_location()].
#' @export
#'
#' @examples
#' # Exclude locations outside of the US
#' data(qualtrics_text)
#' df <- exclude_location(qualtrics_text)
#'
#' # Remove preview data first
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   exclude_location()
exclude_location <- function(x,
                             id_col = "ResponseId",
                             location_col = c(
                               "LocationLatitude",
                               "LocationLongitude"
                             ),
                             rename = TRUE,
                             include_na = FALSE,
                             quiet = TRUE,
                             print = TRUE,
                             silent = FALSE) {
  # Mark and filter location
  remaining_data <- mark_location(x,
    id_col = id_col,
    location_col = location_col,
    rename = rename,
    include_na = include_na,
    quiet = quiet
  ) %>%
    dplyr::filter(.data$exclusion_location != "location") %>%
    dplyr::select(-"exclusion_location")

  # Print exclusion statement
  if (identical(silent, FALSE)) {
    print_exclusion(remaining_data, x, "rows outside of the US")
  }

  # Determine whether to print results
  print_data(remaining_data, print)
}
