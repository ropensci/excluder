#' Mark locations outside of US
#'
#' @description
#' The `mark_location()` function creates a column labeling
#' rows that have locations outside of the US.
#' The function is written to work with data from
#' [Qualtrics](https://www.qualtrics.com/) surveys.
#'
#' @details
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
#' @param include_na Logical indicating whether to include rows with NA in
#' latitude and longitude columns in the output list of potentially excluded
#' data.
#' @param quiet Logical indicating whether to print message to console.
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
                          include_na = FALSE,
                          quiet = FALSE) {

  # Check for presence of required column
  column_names <- names(x)
  ## id_col
  stopifnot(
    "'id_col' should only have a single column name" =
      length(id_col) == 1L
  )
  if (!id_col %in% column_names) {
    stop("The column specifying the participant ID ('id_col') was not found.")
  }
  ## location_col
  if (length(location_col) != 2) {
    stop("'location_col' must have two columns: latitude and longitude.")
  }
  if (!location_col[1] %in% column_names | !location_col[2] %in% column_names) {
    stop("The column specifying location ('location_col') was not found.")
  }

  # Extract latitude and longitude
  latitude <- x[[location_col[1]]]
  longitude <- x[[location_col[2]]]

  # Check column types
  if (!is.numeric(latitude)) {
    stop("Please ensure latitude column data type is numeric.")
  }
  if (!is.numeric(longitude)) {
    stop("Please ensure longitude column data type is numeric.")
  }

  # Find number of rows
  n_rows <- nrow(x)

  # Check for participants with no location information
  no_location <-
    dplyr::filter(x, is.na(dplyr::across(tidyselect::all_of(location_col))))
  n_no_location <- nrow(no_location)
  no_nas <- tidyr::drop_na(x, tidyselect::all_of(location_col))

  # Extract latitude and longitude
  latitude <- no_nas[[location_col[1]]]
  longitude <- no_nas[[location_col[2]]]

  # Determine if geolocation is within US
  no_nas$country <- maps::map.where(database = "usa", longitude, latitude)
  outside_us <- dplyr::filter(no_nas, is.na(.data$country)) %>%
    dplyr::select(-.data$country)
  n_outside_us <- nrow(outside_us)

  # Combine no location with outside US
  if (identical(include_na, FALSE)) {
    location_issues <- dplyr::bind_rows(no_location, outside_us)
  } else {
    location_issues <- outside_us
  }

  # Print messages and return output
  if (identical(quiet, FALSE)) {
    message(
      n_no_location, " out of ", n_rows,
      " rows had no information on location."
    )
    message(
      n_outside_us, " out of ", n_rows,
      " rows were located outside of the US."
    )
  }

  # Find rows to mark
  exclusions <- location_issues %>%
    dplyr::mutate(exclusion_location = "location_outside_us") %>%
    dplyr::select(tidyselect::all_of(id_col), .data$exclusion_location)

  # Mark rows
  invisible(dplyr::left_join(x, exclusions, by = id_col) %>%
    dplyr::mutate(
      exclusion_location =
        stringr::str_replace_na(
          .data$exclusion_location, ""
        )
    ))
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
#' @param print Logical indicating whether to print returned tibble to
#' console.
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
                           include_na = FALSE,
                           quiet = FALSE,
                           print = TRUE) {

  # Mark and filter location
  exclusions <- mark_location(x,
    id_col = id_col,
    location_col = location_col,
    include_na = include_na,
    quiet = quiet
  ) %>%
    dplyr::filter(.data$exclusion_location == "location_outside_us") %>%
    dplyr::select(-.data$exclusion_location)

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
#' @param print Logical indicating whether to print returned tibble to
#' console.
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
                             include_na = FALSE,
                             quiet = TRUE,
                             print = FALSE,
                             silent = FALSE) {

  # Mark and filter location
  remaining_data <- mark_location(x,
    id_col = id_col,
    location_col = location_col,
    include_na = include_na,
    quiet = quiet
  ) %>%
    dplyr::filter(.data$exclusion_location != "location_outside_us") %>%
    dplyr::select(-.data$exclusion_location)

  # Print exclusion statement
  if (identical(silent, FALSE)) {
    print_exclusion(remaining_data, x, "rows outside of the US")
  }

  # Determine whether to print results
  print_data(remaining_data, print)
}
