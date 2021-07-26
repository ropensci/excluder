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
#' [qualtRics::fetch_survey()].
#' The function only works for the United States.
#' It uses the #' [maps::map.where()] to determine if latitude and longitude
#' are inside the US.
#'
#' The function outputs to console a message about the number of rows
#' with locations outside of the US.
#'
#' @param x Data frame (preferably directly from Qualtrics imported
#' using {qualtRics}.)
#' @param location_col Two element vector specifying columns for latitude
#' and longitude (in that order).
#' @param include_na Logical indicating whether to include rows with NA in
#' latitude and longitude columns in the output list of potentially excluded data.
#' @param print_tibble Logical indicating whether to print returned tibble to
#' console.
#' @param quiet Logical indicating whether to print message to console.
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
#'   check_location(print_tibble = FALSE)
#'
#' # Do not print message to console
#' qualtrics_text %>%
#'   exclude_preview() %>%
#'   check_location(quiet = TRUE)
check_location <- function(x, location_col = c("LocationLatitude", "LocationLongitude"), include_na = FALSE, print_tibble = TRUE, quiet = FALSE) {

  # Check for presence of required columns
  column_names <- names(x)
  if (length(location_col) != 2) stop("Incorrect number of columns for location_col. You must specify two columns for latitude and longitude (respectively).")
  if (!location_col[1] %in% column_names | !location_col[2] %in% column_names) stop("The columns specifying participant location (location_col) are incorrect. Please check your data and specify location_col.")

  # Extract IP address, latitude, and longitude vectors
  latitude <- dplyr::pull(x, location_col[1])
  longitude <- dplyr::pull(x, location_col[2])

  # Check column types
  if (!is.numeric(latitude)) stop("Incorrect data type for latitude column. Please ensure data type is numeric.")
  if (!is.numeric(longitude)) stop("Incorrect data type for longitude column. Please ensure data type is numeric.")

  # Find number of rows
  n_rows <- nrow(x)

  # Check for participants with no location information
  no_location <- dplyr::filter(x, is.na(dplyr::across(location_col)))
  n_no_location <- nrow(no_location)
  x <- tidyr::drop_na(x, dplyr::all_of(location_col))

  # Extract latitude and longitude
  latitude <- dplyr::pull(x, location_col[1])
  longitude <- dplyr::pull(x, location_col[2])

  # Determine if geolocation is within US
  x$country <- maps::map.where(database = "usa", longitude, latitude)
  x <- dplyr::filter(x, is.na(.data$country)) %>%
    dplyr::select(-.data$country)
  n_outside_us <- nrow(x)

  # Combine no location with outside US
  if (include_na == FALSE) {
    location_issues <- rbind(no_location, x)
  } else {
    location_issues <- x
  }

  # Print messages and return output
  if (quiet == FALSE) {
    message(n_no_location, " out of ", n_rows, " rows had no information on location.")
    message(n_outside_us, " out of ", n_rows, " rows were located outside of the US.")
  }
  if (print_tibble == TRUE) {
    return(location_issues)
  } else {
    invisible(location_issues)
  }
}
