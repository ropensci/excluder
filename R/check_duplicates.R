#' Title
#'
#' @param .data
#' @param ip_col
#' @param location_col
#' @param check_ip
#' @param check_location
#' @param include_na
#' @param quiet
#'
#' @return
#' @export
#'
#' @examples
check_duplicates <- function(.data, ip_col = "IPAddress", location_col = c("LocationLatitude", "LocationLongitude"), check_ip = TRUE, check_location = TRUE, include_na = FALSE, quiet = FALSE) {

  # Check for duplicate locations
  if (check_location == TRUE) {
    if (include_na == FALSE) {
      .data <- tidyr::drop_na(.data, dplyr::any_of(location_col))
    }
    same_location <- janitor::get_dupes(.data, dplyr::all_of(location_col))
    n_same_location <- nrow(same_location)
    if (quiet == FALSE) {
      message(n_same_location, " participants have duplicate locations.")
    }
  }

  # Check for duplicate IP addresses
  if (check_ip == TRUE) {
    if (include_na == FALSE) {
      .data <- tidyr::drop_na(.data, dplyr::all_of(ip_col))
    }
    same_ip <- janitor::get_dupes(.data, dplyr::all_of(ip_col))
    n_same_ip <- nrow(same_ip)
    if (quiet == FALSE) {
      message(n_same_ip, " participants have duplicate IP addresses.")
    }
  }

  # Create data frame of duplicates if both location and IP address are used
  if (check_location == TRUE & check_ip == TRUE) {
    duplicates <- rbind(same_location, same_ip)
  } else if (check_location == TRUE) {
    duplicates <- same_location
  } else if (check_ip == TRUE) {
    duplicates <- same_ip
  } else {
    duplicates <- NULL
    warning("No check run. Please allow either location or IP address checks by setting check_location or check_ip to TRUE.")
  }
  return(duplicates)
}
