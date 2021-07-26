#' Remove columns that could include identifiable information
#'
#' @description
#' The `deidentify()` function selects out columns from
#' [Qualtrics](https://www.qualtrics.com/) surveys that may include identifiable
#' information such as IP address, location, or computer characteristics.
#'
#' @details
#' The function offers two levels of deidentification. The default strict level
#' removes columns associated with IP address and location and computer
#' information (browser type and version, operating system, and screen
#' resolution). The non-strict level removes only columns associated with
#' IP address and location.
#'
#' Typically, deidenification should be used at the end of a processing pipeline
#' so that these columns can be used to exclude rows.
#'
#' @param x Data frame (downloaded from Qualtrics).
#' @param strict Logical indicating whether to use strict or non-strict level
#' of deidentification. Strict removes computer information columns in addition
#' to IP address and location.
#'
#' @return
#' An object of the same type as `x` that excludes Qualtrics columns with
#' identifiable information.
#' @export
#'
#' @examples
#' names(qualtrics_numeric)
#'
#' # Remove IP address, location, and computer information columns
#' deid <- deidentify(qualtrics_numeric)
#' names(deid)
#'
#' # Remove only IP address and location columns
#' deid2 <- deidentify(qualtrics_numeric, strict = FALSE)
#' names(deid2)
deidentify <- function(x, strict = TRUE) {

  # Define columns to remove
  location_cols <- c("IPAddress", "LocationLatitude", "LocationLongitude", "UserLanguage", "IP Address", "Location Latitude", "Location Longitude", "User Language")
  computer_cols <- c("Browser", "Version", "Operating System", "Resolution")

  # Remove columns
  x <- x %>%
    dplyr::select(!dplyr::any_of(location_cols))

  if (strict == TRUE) {
    x <- x %>%
      dplyr::select(!dplyr::contains(computer_cols))
  }
  invisible(x)
}
