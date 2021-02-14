#' Check data rows where location information is absent and outside of the the US
#'
#' @param .data Data frame (preferably directly from Qualtrics imported using {qualtRics}.)
#' @param location_col Two element vector specifying columns for latitude and longitude (in that order).
#' @param include_na Logical indicating whether to include rows with NA in latitude and longitude columns in the output list of potentially excluded data.
#' @param quiet Logical indicating whether to print results to console.
#'
#' @return The output is a data frame of the rows that are located outside of the US and (if \code{include_na == FALSE}) rows with no location information. For a function that excludes these rows, use [exclude_location].
#' @export
#'
#' @examples
check_location <- function(.data, location_col = c("LocationLatitude", "LocationLongitude"), include_na = FALSE, quiet = FALSE) {

  # Check for presence of required columns
  column_names <- names(.data)
  if (length(location_col) != 2) stop("Incorrect number of columns for location_col. You must specify two columns for latitude and longitude (respectively).")
  if (!location_col[1] %in% column_names | !location_col[2] %in% column_names) stop("The columns specifying participant location (location_col) are incorrect. Please check your data and specify location_col.")

  # Quote column names
  location_col_enquo <- dplyr::enquo(location_col)

  # Check for participants with no location information
  no_location <- dplyr::filter(.data, is.na(dplyr::across(!!location_col_enquo)))
  n_no_location <- nrow(no_location)
  .data <- tidyr::drop_na(.data, location_col)

  # Extract latitude and longitude
  latitude <- dplyr::pull(.data, location_col[1])
  longitude <- dplyr::pull(.data, location_col[2])

  # Determine if geolocation is within US
  .data$country <- maps::map.where(database = "usa", longitude, latitude)
  .data <- dplyr::filter(.data, is.na(.data$country)) %>%
    dplyr::select(-.data$country)
  n_outside_us <- nrow(.data)

  # Combine no location with outside US
  if (include_na == FALSE) {
    location_issues <- rbind(no_location, .data)
  } else {
    location_issues <- .data
  }

  # Print messages and return output
  if (quiet == FALSE) {
    message(n_no_location, " participants had no information on location.")
    message(n_outside_us, " participants were located outside of the US.")
  }
  return(location_issues)
}
